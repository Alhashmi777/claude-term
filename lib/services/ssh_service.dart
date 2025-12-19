import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dartssh2/dartssh2.dart';
import 'package:xterm/xterm.dart';
import '../models/ssh_connection.dart';

class SSHService {
  SSHClient? _client;
  SSHSession? _session;
  bool _isConnected = false;

  // 用于正确处理分割的 UTF-8 字符
  final Utf8Decoder _utf8Decoder = const Utf8Decoder(allowMalformed: true);

  bool get isConnected => _isConnected;

  Future<void> connect({
    required SSHConnection connection,
    required Terminal terminal,
    required Function(String) onError,
  }) async {
    try {
      // 建立 SSH 连接
      final socket = await SSHSocket.connect(
        connection.host,
        connection.port,
        timeout: const Duration(seconds: 10),
      );

      _client = SSHClient(
        socket,
        username: connection.username,
        onPasswordRequest: () => connection.password ?? '',
        // 如果有私钥，可以使用私钥认证
        // identities: connection.privateKey != null
        //     ? [SSHKeyPair.fromPem(connection.privateKey!)]
        //     : null,
      );

      // 等待认证完成
      await _client!.authenticated;

      // 创建 shell 会话
      _session = await _client!.shell(
        pty: SSHPtyConfig(
          width: terminal.viewWidth,
          height: terminal.viewHeight,
        ),
      );

      _isConnected = true;

      // 自动 export Claude API 环境变量
      _exportClaudeEnvVars(connection);

      // 监听终端输出 (使用 allowMalformed 处理可能被分割的 UTF-8 字符)
      _session!.stdout.listen((data) {
        terminal.write(_utf8Decoder.convert(data));
      });

      _session!.stderr.listen((data) {
        terminal.write(_utf8Decoder.convert(data));
      });

      // 监听会话结束
      _session!.done.then((_) {
        _isConnected = false;
        terminal.write('\r\n[连接已断开]\r\n');
      });

      // 监听终端输入 (xterm 4.0 使用 onOutput)
      terminal.onOutput = (data) {
        final bytes = utf8.encode(data);
        _session?.write(Uint8List.fromList(bytes));
      };

      // 监听终端大小变化
      terminal.onResize = (width, height, pixelWidth, pixelHeight) {
        _session?.resizeTerminal(width, height);
      };

    } catch (e) {
      _isConnected = false;
      onError('连接失败: $e');
      rethrow;
    }
  }

  /// 自动设置环境变量 (LANG + Claude API)
  void _exportClaudeEnvVars(SSHConnection connection) {
    // 延迟一点确保 shell 就绪
    Future.delayed(const Duration(milliseconds: 500), () {
      final commands = <String>[];

      // 设置 UTF-8 编码支持中文
      commands.add('export LANG=en_US.UTF-8');
      commands.add('export LC_ALL=en_US.UTF-8');

      if (connection.anthropicApiKey != null && connection.anthropicApiKey!.isNotEmpty) {
        commands.add('export ANTHROPIC_API_KEY="${connection.anthropicApiKey}"');
      }
      if (connection.anthropicBaseUrl != null && connection.anthropicBaseUrl!.isNotEmpty) {
        commands.add('export ANTHROPIC_BASE_URL="${connection.anthropicBaseUrl}"');
      }
      if (connection.maxOutputTokens != null) {
        commands.add('export CLAUDE_CODE_MAX_OUTPUT_TOKENS=${connection.maxOutputTokens}');
      }

      // 用 && 连接所有命令，一次性执行，然后 clear 清屏
      final fullCommand = '${commands.join(' && ')} && clear';
      sendCommand(fullCommand);

      // 自动启动 Claude Code
      if (connection.autoStartClaude) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (connection.skipPermissions) {
            sendCommand('claude --dangerously-skip-permissions');
          } else {
            sendCommand('claude');
          }
        });
      }
    });
  }

  void sendCommand(String command) {
    if (_isConnected && _session != null) {
      _session!.write(Uint8List.fromList(utf8.encode('$command\n')));
    }
  }

  void sendData(Uint8List data) {
    if (_isConnected && _session != null) {
      _session!.write(data);
    }
  }

  Future<void> disconnect() async {
    _session?.close();
    _client?.close();
    _isConnected = false;
  }

  void dispose() {
    disconnect();
  }
}
