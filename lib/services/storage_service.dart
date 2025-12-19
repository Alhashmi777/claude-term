import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ssh_connection.dart';

class StorageService {
  static const String _connectionsKey = 'ssh_connections';
  static const String _quickCommandsKey = 'quick_commands';
  static const String _themeKey = 'terminal_theme';

  // 保存连接列表
  Future<void> saveConnections(List<SSHConnection> connections) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = connections.map((c) => c.toJson()).toList();
    await prefs.setString(_connectionsKey, jsonEncode(jsonList));
  }

  // 加载连接列表
  Future<List<SSHConnection>> loadConnections() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_connectionsKey);
    if (jsonString == null) return [];

    final jsonList = jsonDecode(jsonString) as List;
    return jsonList
        .map((json) => SSHConnection.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // 保存快捷命令
  Future<void> saveQuickCommands(List<String> commands) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_quickCommandsKey, commands);
  }

  // 加载快捷命令
  Future<List<String>> loadQuickCommands() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_quickCommandsKey) ?? _defaultQuickCommands;
  }

  // 默认的快捷命令（针对 Claude Code）
  static const List<String> _defaultQuickCommands = [
    'claude',
    'claude --help',
    'claude --version',
    '/help',
    '/clear',
    '/compact',
    'exit',
    'clear',
    'ls -la',
    'pwd',
  ];

  // 保存主题偏好
  Future<void> saveTheme(String themeName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, themeName);
  }

  // 加载主题偏好
  Future<String> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_themeKey) ?? 'default';
  }

  // 语言偏好 key
  static const String _localeKey = 'app_locale';

  // 保存语言偏好 (null 表示跟随系统)
  Future<void> saveLocale(String? localeCode) async {
    final prefs = await SharedPreferences.getInstance();
    if (localeCode == null) {
      await prefs.remove(_localeKey);
    } else {
      await prefs.setString(_localeKey, localeCode);
    }
  }

  // 加载语言偏好
  Future<String?> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_localeKey);
  }
}
