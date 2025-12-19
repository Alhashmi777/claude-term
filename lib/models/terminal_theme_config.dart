import 'package:flutter/material.dart';
import 'package:xterm/xterm.dart';

class TerminalThemeConfig {
  final String name;
  final String displayName;
  final TerminalTheme theme;

  const TerminalThemeConfig({
    required this.name,
    required this.displayName,
    required this.theme,
  });

  /// 预设主题列表
  static final List<TerminalThemeConfig> presets = [
    // Default - 原默认主题（黑底白字绿光标）
    TerminalThemeConfig(
      name: 'default',
      displayName: '默认',
      theme: TerminalTheme(
        cursor: Colors.green,
        selection: Colors.green.withOpacity(0.3),
        foreground: Colors.white,
        background: Colors.black,
        black: Colors.black,
        white: Colors.white,
        red: Colors.red,
        green: Colors.green,
        yellow: Colors.yellow,
        blue: Colors.blue,
        magenta: Colors.purple,
        cyan: Colors.cyan,
        brightBlack: Colors.grey,
        brightRed: Colors.redAccent,
        brightGreen: Colors.greenAccent,
        brightYellow: Colors.yellowAccent,
        brightBlue: Colors.blueAccent,
        brightMagenta: Colors.purpleAccent,
        brightCyan: Colors.cyanAccent,
        brightWhite: Colors.white,
        searchHitBackground: Colors.yellow,
        searchHitBackgroundCurrent: Colors.orange,
        searchHitForeground: Colors.black,
      ),
    ),

    // Homebrew - 经典绿色终端
    TerminalThemeConfig(
      name: 'homebrew',
      displayName: 'Homebrew',
      theme: TerminalTheme(
        cursor: const Color(0xFF00FF00),
        selection: const Color(0xFF00FF00).withOpacity(0.3),
        foreground: const Color(0xFF00FF00),
        background: const Color(0xFF000000),
        black: const Color(0xFF000000),
        white: const Color(0xFF00FF00),
        red: const Color(0xFFFF0000),
        green: const Color(0xFF00FF00),
        yellow: const Color(0xFFFFFF00),
        blue: const Color(0xFF0066FF),
        magenta: const Color(0xFFFF00FF),
        cyan: const Color(0xFF00FFFF),
        brightBlack: const Color(0xFF666666),
        brightRed: const Color(0xFFFF6666),
        brightGreen: const Color(0xFF66FF66),
        brightYellow: const Color(0xFFFFFF66),
        brightBlue: const Color(0xFF6699FF),
        brightMagenta: const Color(0xFFFF66FF),
        brightCyan: const Color(0xFF66FFFF),
        brightWhite: const Color(0xFFFFFFFF),
        searchHitBackground: const Color(0xFFFFFF00),
        searchHitBackgroundCurrent: const Color(0xFFFF9900),
        searchHitForeground: const Color(0xFF000000),
      ),
    ),

    // Pro - macOS 黑底白字
    TerminalThemeConfig(
      name: 'pro',
      displayName: 'Pro',
      theme: TerminalTheme(
        cursor: const Color(0xFF4D4D4D),
        selection: const Color(0xFFB4D5FF).withOpacity(0.4),
        foreground: const Color(0xFFF2F2F2),
        background: const Color(0xFF000000),
        black: const Color(0xFF000000),
        white: const Color(0xFFBFBFBF),
        red: const Color(0xFFFF6B68),
        green: const Color(0xFF8CEC72),
        yellow: const Color(0xFFEEDD5A),
        blue: const Color(0xFF7EB6FF),
        magenta: const Color(0xFFFF6FF0),
        cyan: const Color(0xFF6CFFFF),
        brightBlack: const Color(0xFF666666),
        brightRed: const Color(0xFFFF8785),
        brightGreen: const Color(0xFFB2F698),
        brightYellow: const Color(0xFFFFFD7A),
        brightBlue: const Color(0xFFACCFFF),
        brightMagenta: const Color(0xFFFF9AFF),
        brightCyan: const Color(0xFFA6FFFF),
        brightWhite: const Color(0xFFFFFFFF),
        searchHitBackground: const Color(0xFFFFFF00),
        searchHitBackgroundCurrent: const Color(0xFFFF9900),
        searchHitForeground: const Color(0xFF000000),
      ),
    ),

    // Ocean - 蓝色海洋风格
    TerminalThemeConfig(
      name: 'ocean',
      displayName: 'Ocean',
      theme: TerminalTheme(
        cursor: const Color(0xFF7F7F7F),
        selection: const Color(0xFF5A637E).withOpacity(0.5),
        foreground: const Color(0xFFFFFFFF),
        background: const Color(0xFF224FBC),
        black: const Color(0xFF000000),
        white: const Color(0xFFFFFFFF),
        red: const Color(0xFFFF6B68),
        green: const Color(0xFF8CEC72),
        yellow: const Color(0xFFEEDD5A),
        blue: const Color(0xFF7EB6FF),
        magenta: const Color(0xFFFF6FF0),
        cyan: const Color(0xFF6CFFFF),
        brightBlack: const Color(0xFF666666),
        brightRed: const Color(0xFFFF8785),
        brightGreen: const Color(0xFFB2F698),
        brightYellow: const Color(0xFFFFFD7A),
        brightBlue: const Color(0xFFACCFFF),
        brightMagenta: const Color(0xFFFF9AFF),
        brightCyan: const Color(0xFFA6FFFF),
        brightWhite: const Color(0xFFFFFFFF),
        searchHitBackground: const Color(0xFFFFFF00),
        searchHitBackgroundCurrent: const Color(0xFFFF9900),
        searchHitForeground: const Color(0xFF000000),
      ),
    ),

    // Dracula - 流行暗色主题
    TerminalThemeConfig(
      name: 'dracula',
      displayName: 'Dracula',
      theme: TerminalTheme(
        cursor: const Color(0xFFF8F8F2),
        selection: const Color(0xFF44475A).withOpacity(0.6),
        foreground: const Color(0xFFF8F8F2),
        background: const Color(0xFF282A36),
        black: const Color(0xFF21222C),
        white: const Color(0xFFF8F8F2),
        red: const Color(0xFFFF5555),
        green: const Color(0xFF50FA7B),
        yellow: const Color(0xFFF1FA8C),
        blue: const Color(0xFFBD93F9),
        magenta: const Color(0xFFFF79C6),
        cyan: const Color(0xFF8BE9FD),
        brightBlack: const Color(0xFF6272A4),
        brightRed: const Color(0xFFFF6E6E),
        brightGreen: const Color(0xFF69FF94),
        brightYellow: const Color(0xFFFFFFA5),
        brightBlue: const Color(0xFFD6ACFF),
        brightMagenta: const Color(0xFFFF92DF),
        brightCyan: const Color(0xFFA4FFFF),
        brightWhite: const Color(0xFFFFFFFF),
        searchHitBackground: const Color(0xFFF1FA8C),
        searchHitBackgroundCurrent: const Color(0xFFFFB86C),
        searchHitForeground: const Color(0xFF282A36),
      ),
    ),
  ];

  /// 根据名称获取主题
  static TerminalThemeConfig getByName(String name) {
    return presets.firstWhere(
      (t) => t.name == name,
      orElse: () => presets.first, // 默认返回 Homebrew
    );
  }

  /// 默认主题名称
  static const String defaultThemeName = 'default';
}
