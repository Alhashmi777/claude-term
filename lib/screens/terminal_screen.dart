import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xterm/xterm.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import '../models/ssh_connection.dart';
import '../models/terminal_theme_config.dart';
import '../services/ssh_service.dart';
import '../services/storage_service.dart';
import '../services/foreground_service.dart';
import '../widgets/theme_picker_dialog.dart';
import '../l10n/app_localizations.dart';

class TerminalScreen extends StatefulWidget {
  final SSHConnection connection;

  const TerminalScreen({Key? key, required this.connection}) : super(key: key);

  @override
  State<TerminalScreen> createState() => _TerminalScreenState();
}

class _TerminalScreenState extends State<TerminalScreen> {
  late Terminal _terminal;
  final SSHService _sshService = SSHService();
  final StorageService _storageService = StorageService();
  final FocusNode _focusNode = FocusNode();

  bool _isConnecting = true;
  String? _errorMessage;
  List<String> _quickCommands = [];
  bool _showQuickCommands = false;
  String _currentThemeName = TerminalThemeConfig.defaultThemeName;
  late TerminalThemeConfig _currentTheme;

  @override
  void initState() {
    super.initState();
    _currentTheme = TerminalThemeConfig.getByName(_currentThemeName);
    _terminal = Terminal(
      maxLines: 10000,
    );
    _loadQuickCommands();
    _loadTheme();
    _connect();
  }

  Future<void> _loadTheme() async {
    final themeName = await _storageService.loadTheme();
    setState(() {
      _currentThemeName = themeName;
      _currentTheme = TerminalThemeConfig.getByName(themeName);
    });
  }

  void _showThemePicker() {
    showDialog(
      context: context,
      builder: (context) => ThemePickerDialog(
        currentTheme: _currentThemeName,
        onThemeSelected: (themeName) async {
          await _storageService.saveTheme(themeName);
          setState(() {
            _currentThemeName = themeName;
            _currentTheme = TerminalThemeConfig.getByName(themeName);
          });
        },
      ),
    );
  }

  Future<void> _loadQuickCommands() async {
    final commands = await _storageService.loadQuickCommands();
    setState(() {
      _quickCommands = commands;
    });
  }

  Future<void> _connect() async {
    setState(() {
      _isConnecting = true;
      _errorMessage = null;
    });

    _terminal.write('正在连接到 ${widget.connection.host}...\r\n');

    try {
      await _sshService.connect(
        connection: widget.connection,
        terminal: _terminal,
        onError: (error) {
          setState(() {
            _errorMessage = error;
          });
        },
      );

      setState(() {
        _isConnecting = false;
      });

      // 启动前台服务保活
      await ForegroundServiceManager.startService(widget.connection.host);
    } catch (e) {
      setState(() {
        _isConnecting = false;
        _errorMessage = e.toString();
      });
      _terminal.write('\r\n连接失败: $e\r\n');
    }
  }

  void _sendQuickCommand(String command) {
    _sshService.sendCommand(command);
    setState(() {
      _showQuickCommands = false;
    });
  }

  void _disconnect() async {
    await ForegroundServiceManager.stopService();
    _sshService.disconnect();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _sshService.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.connection.name),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        actions: [
          // 主题切换按钮
          IconButton(
            icon: const Icon(Icons.palette),
            onPressed: _showThemePicker,
            tooltip: l10n.switchTheme,
          ),
          // 快捷命令按钮
          IconButton(
            icon: Icon(
              _showQuickCommands ? Icons.keyboard_hide : Icons.keyboard,
            ),
            onPressed: () {
              setState(() {
                _showQuickCommands = !_showQuickCommands;
              });
            },
            tooltip: l10n.quickCommands,
          ),
          // 重连按钮
          if (_errorMessage != null || !_sshService.isConnected)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _connect,
              tooltip: l10n.reconnect,
            ),
          // 断开连接
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: _disconnect,
            tooltip: l10n.disconnect,
          ),
        ],
      ),
      body: Column(
        children: [
          // 终端区域
          Expanded(
            child: Container(
              color: _currentTheme.theme.background,
              child: _isConnecting
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: _currentTheme.theme.foreground,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.connecting,
                            style: TextStyle(color: _currentTheme.theme.foreground),
                          ),
                        ],
                      ),
                    )
                  : TerminalView(
                      _terminal,
                      focusNode: _focusNode,
                      autofocus: true,
                      hardwareKeyboardOnly: false,
                      keyboardType: TextInputType.multiline,
                      deleteDetection: true,
                      onKeyEvent: (node, event) {
                        // 处理回车键
                        if (event is KeyDownEvent &&
                            event.logicalKey == LogicalKeyboardKey.enter) {
                          _sshService.sendData(Uint8List.fromList([13])); // CR
                          return KeyEventResult.handled;
                        }
                        return KeyEventResult.ignored;
                      },
                      theme: _currentTheme.theme,
                      textStyle: const TerminalStyle(
                        fontSize: 14,
                      ),
                    ),
            ),
          ),

          // 快捷命令栏
          if (_showQuickCommands) _buildQuickCommandsBar(l10n),
        ],
      ),
    );
  }

  Widget _buildQuickCommandsBar(AppLocalizations l10n) {
    return Container(
      color: Colors.grey[900],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Claude Code 专用快捷键
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              l10n.claudeCodeCommands,
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: [
                _buildCommandChip('claude', Icons.smart_toy),
                _buildCommandChip('/help', Icons.help_outline),
                _buildCommandChip('/compact', Icons.compress),
                _buildCommandChip('/cost', Icons.attach_money),
                _buildCommandChip('/clear', Icons.clear_all),
                _buildCommandChip('/config', Icons.settings),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.grey),

          // 常用终端命令
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              l10n.commonCommands,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: [
                _buildCommandChip('ll', Icons.folder),
                _buildCommandChip('pwd', Icons.place),
                _buildCommandChip('clear', Icons.cleaning_services),
                _buildCommandChip('cd ~', Icons.home),
                _buildCommandChip('git status', Icons.code),
                _buildCommandChip('top', Icons.monitor),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // 特殊按键
          Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSpecialKey('Enter', () => _sendControlChar('\r')),
                _buildSpecialKey('Tab', () => _sendControlChar('\t')),
                _buildSpecialKey('Ctrl+C', () => _sendControlChar('\x03')),
                _buildSpecialKey('Ctrl+D', () => _sendControlChar('\x04')),
                _buildSpecialKey('↑', () => _sendControlChar('\x1B[A')),
                _buildSpecialKey('↓', () => _sendControlChar('\x1B[B')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommandChip(String command, IconData icon, {String? label}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ActionChip(
        avatar: Icon(icon, size: 16, color: Colors.green),
        label: Text(
          label ?? command,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 12,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.grey[800],
        side: BorderSide.none,
        onPressed: () => _sendQuickCommand(command),
      ),
    );
  }

  Widget _buildSpecialKey(String label, VoidCallback onPressed) {
    return SizedBox(
      height: 36,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[700],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          textStyle: const TextStyle(fontSize: 11),
        ),
        child: Text(label),
      ),
    );
  }

  void _sendControlChar(String char) {
    _sshService.sendData(Uint8List.fromList(char.codeUnits));
  }
}
