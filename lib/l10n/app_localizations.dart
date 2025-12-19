import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // App
      'appName': 'Claude Term',
      'appDescription': 'A terminal app for remote Claude Code connection',

      // Common
      'save': 'Save',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'edit': 'Edit',
      'confirm': 'Confirm',
      'settings': 'Settings',

      // Home Screen
      'addConnection': 'Add Connection',
      'noConnections': 'No saved connections',
      'noConnectionsHint': 'Tap the button below to add your first connection',
      'deleteConnectionTitle': 'Delete Connection',
      'deleteConnectionConfirm': 'Are you sure you want to delete "{name}"?',
      'lastConnected': 'Last connected: {time}',

      // Connection Form
      'editConnection': 'Edit Connection',
      'connectionName': 'Connection Name',
      'connectionNameHint': 'e.g. My Mac',
      'connectionNameRequired': 'Please enter connection name',
      'hostAddress': 'Host Address',
      'hostAddressHint': 'e.g. 192.168.1.100',
      'hostAddressRequired': 'Please enter host address',
      'port': 'Port',
      'portHint': 'Default 22',
      'portInvalid': 'Please enter valid port (1-65535)',
      'username': 'Username',
      'usernameHint': 'e.g. admin',
      'usernameRequired': 'Please enter username',
      'password': 'Password',
      'passwordHint': 'Enter password',
      'claudeApiConfig': 'Claude API Configuration',
      'tapToExpand': 'Tap to expand',
      'tapToCollapse': 'Tap to collapse',
      'optional': '(Optional)',
      'sshTip': 'Make sure SSH is enabled on your computer\nmacOS: System Settings -> General -> Sharing -> Remote Login',

      // Terminal Screen
      'connecting': 'Connecting...',
      'connectingTo': 'Connecting to {host}...',
      'connectionFailed': 'Connection failed: {error}',
      'disconnected': '[Disconnected]',
      'switchTheme': 'Switch Theme',
      'quickCommands': 'Quick Commands',
      'reconnect': 'Reconnect',
      'disconnect': 'Disconnect',
      'claudeCodeCommands': 'Claude Code Commands',
      'commonCommands': 'Common Commands',
      'connectClaude': 'Connect Claude',

      // Theme
      'selectTheme': 'Select Terminal Theme',
      'themeDefault': 'Default',

      // Language
      'language': 'Language',
      'selectLanguage': 'Select Language',
      'followSystem': 'Follow System',
      'chinese': 'Chinese',
      'english': 'English',
      'japanese': 'Japanese',

      // Auto Start Claude
      'autoStartClaude': 'Auto Start Claude Code',
      'autoStartClaudeHint': 'Automatically run claude command after connection',
      'skipPermissions': 'Skip Permissions',
      'skipPermissionsWarning': 'Use --dangerously-skip-permissions flag (not recommended for production)',

      // Foreground Service
      'foregroundServiceChannel': 'Claude Term Connection',
      'foregroundServiceDescription': 'Keep SSH connection alive',
      'connectedTo': 'Connected to {host}',
    },
    'zh': {
      // App
      'appName': 'Claude Term',
      'appDescription': '一个用于远程连接 Claude Code 的终端应用',

      // Common
      'save': '保存',
      'cancel': '取消',
      'delete': '删除',
      'edit': '编辑',
      'confirm': '确定',
      'settings': '设置',

      // Home Screen
      'addConnection': '添加连接',
      'noConnections': '还没有保存的连接',
      'noConnectionsHint': '点击下方按钮添加第一个连接',
      'deleteConnectionTitle': '删除连接',
      'deleteConnectionConfirm': '确定要删除 "{name}" 吗？',
      'lastConnected': '上次连接: {time}',

      // Connection Form
      'editConnection': '编辑连接',
      'connectionName': '连接名称',
      'connectionNameHint': '例如：我的 Mac',
      'connectionNameRequired': '请输入连接名称',
      'hostAddress': '主机地址',
      'hostAddressHint': '例如：192.168.1.100',
      'hostAddressRequired': '请输入主机地址',
      'port': '端口',
      'portHint': '默认 22',
      'portInvalid': '请输入有效端口 (1-65535)',
      'username': '用户名',
      'usernameHint': '例如：admin',
      'usernameRequired': '请输入用户名',
      'password': '密码',
      'passwordHint': '输入密码',
      'claudeApiConfig': 'Claude API 配置',
      'tapToExpand': '点击展开配置',
      'tapToCollapse': '点击收起',
      'optional': '(可选)',
      'sshTip': '确保你的电脑已开启远程登录 (SSH)\nmacOS: 系统设置 -> 通用 -> 共享 -> 远程登录',

      // Terminal Screen
      'connecting': '正在连接...',
      'connectingTo': '正在连接到 {host}...',
      'connectionFailed': '连接失败: {error}',
      'disconnected': '[连接已断开]',
      'switchTheme': '切换主题',
      'quickCommands': '快捷命令',
      'reconnect': '重新连接',
      'disconnect': '断开连接',
      'claudeCodeCommands': 'Claude Code 快捷命令',
      'commonCommands': '常用命令',
      'connectClaude': '连接Claude',

      // Theme
      'selectTheme': '选择终端主题',
      'themeDefault': '默认',

      // Language
      'language': '语言',
      'selectLanguage': '选择语言',
      'followSystem': '跟随系统',
      'chinese': '中文',
      'english': 'English',
      'japanese': '日本語',

      // Auto Start Claude
      'autoStartClaude': '自动启动 Claude Code',
      'autoStartClaudeHint': '连接成功后自动执行 claude 命令',
      'skipPermissions': '跳过权限确认',
      'skipPermissionsWarning': '使用 --dangerously-skip-permissions 参数（不建议在生产环境使用）',

      // Foreground Service
      'foregroundServiceChannel': 'Claude Term 连接',
      'foregroundServiceDescription': '保持 SSH 连接活跃',
      'connectedTo': '已连接到 {host}',
    },
    'ja': {
      // App
      'appName': 'Claude Term',
      'appDescription': 'Claude Codeリモート接続用ターミナルアプリ',

      // Common
      'save': '保存',
      'cancel': 'キャンセル',
      'delete': '削除',
      'edit': '編集',
      'confirm': '確認',
      'settings': '設定',

      // Home Screen
      'addConnection': '接続を追加',
      'noConnections': '保存された接続がありません',
      'noConnectionsHint': '下のボタンをタップして最初の接続を追加',
      'deleteConnectionTitle': '接続を削除',
      'deleteConnectionConfirm': '"{name}" を削除しますか？',
      'lastConnected': '最終接続: {time}',

      // Connection Form
      'editConnection': '接続を編集',
      'connectionName': '接続名',
      'connectionNameHint': '例：マイMac',
      'connectionNameRequired': '接続名を入力してください',
      'hostAddress': 'ホストアドレス',
      'hostAddressHint': '例：192.168.1.100',
      'hostAddressRequired': 'ホストアドレスを入力してください',
      'port': 'ポート',
      'portHint': 'デフォルト 22',
      'portInvalid': '有効なポート番号を入力 (1-65535)',
      'username': 'ユーザー名',
      'usernameHint': '例：admin',
      'usernameRequired': 'ユーザー名を入力してください',
      'password': 'パスワード',
      'passwordHint': 'パスワードを入力',
      'claudeApiConfig': 'Claude API 設定',
      'tapToExpand': 'タップして展開',
      'tapToCollapse': 'タップして折りたたむ',
      'optional': '(任意)',
      'sshTip': 'コンピュータでSSHが有効になっていることを確認\nmacOS: システム設定 -> 一般 -> 共有 -> リモートログイン',

      // Terminal Screen
      'connecting': '接続中...',
      'connectingTo': '{host} に接続中...',
      'connectionFailed': '接続失敗: {error}',
      'disconnected': '[切断されました]',
      'switchTheme': 'テーマ切替',
      'quickCommands': 'クイックコマンド',
      'reconnect': '再接続',
      'disconnect': '切断',
      'claudeCodeCommands': 'Claude Code コマンド',
      'commonCommands': 'よく使うコマンド',
      'connectClaude': 'Claude接続',

      // Theme
      'selectTheme': 'ターミナルテーマを選択',
      'themeDefault': 'デフォルト',

      // Language
      'language': '言語',
      'selectLanguage': '言語を選択',
      'followSystem': 'システムに従う',
      'chinese': '中国語',
      'english': '英語',
      'japanese': '日本語',

      // Auto Start Claude
      'autoStartClaude': 'Claude Code を自動起動',
      'autoStartClaudeHint': '接続後に自動で claude コマンドを実行',
      'skipPermissions': '権限確認をスキップ',
      'skipPermissionsWarning': '--dangerously-skip-permissions を使用（本番環境では非推奨）',

      // Foreground Service
      'foregroundServiceChannel': 'Claude Term 接続',
      'foregroundServiceDescription': 'SSH接続を維持',
      'connectedTo': '{host} に接続中',
    },
  };

  String get(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }

  String getWithParams(String key, Map<String, String> params) {
    String result = get(key);
    params.forEach((paramKey, value) {
      result = result.replaceAll('{$paramKey}', value);
    });
    return result;
  }

  // Convenience getters
  String get appName => get('appName');
  String get appDescription => get('appDescription');
  String get save => get('save');
  String get cancel => get('cancel');
  String get delete => get('delete');
  String get edit => get('edit');
  String get confirm => get('confirm');
  String get settings => get('settings');
  String get addConnection => get('addConnection');
  String get noConnections => get('noConnections');
  String get noConnectionsHint => get('noConnectionsHint');
  String get deleteConnectionTitle => get('deleteConnectionTitle');
  String get editConnection => get('editConnection');
  String get connectionName => get('connectionName');
  String get connectionNameHint => get('connectionNameHint');
  String get connectionNameRequired => get('connectionNameRequired');
  String get hostAddress => get('hostAddress');
  String get hostAddressHint => get('hostAddressHint');
  String get hostAddressRequired => get('hostAddressRequired');
  String get port => get('port');
  String get portHint => get('portHint');
  String get portInvalid => get('portInvalid');
  String get username => get('username');
  String get usernameHint => get('usernameHint');
  String get usernameRequired => get('usernameRequired');
  String get password => get('password');
  String get passwordHint => get('passwordHint');
  String get claudeApiConfig => get('claudeApiConfig');
  String get tapToExpand => get('tapToExpand');
  String get tapToCollapse => get('tapToCollapse');
  String get optional => get('optional');
  String get sshTip => get('sshTip');
  String get connecting => get('connecting');
  String get disconnected => get('disconnected');
  String get switchTheme => get('switchTheme');
  String get quickCommands => get('quickCommands');
  String get reconnect => get('reconnect');
  String get disconnect => get('disconnect');
  String get claudeCodeCommands => get('claudeCodeCommands');
  String get commonCommands => get('commonCommands');
  String get connectClaude => get('connectClaude');
  String get selectTheme => get('selectTheme');
  String get themeDefault => get('themeDefault');
  String get language => get('language');
  String get selectLanguage => get('selectLanguage');
  String get followSystem => get('followSystem');
  String get chinese => get('chinese');
  String get english => get('english');
  String get japanese => get('japanese');
  String get autoStartClaude => get('autoStartClaude');
  String get autoStartClaudeHint => get('autoStartClaudeHint');
  String get skipPermissions => get('skipPermissions');
  String get skipPermissionsWarning => get('skipPermissionsWarning');

  String deleteConnectionConfirm(String name) =>
      getWithParams('deleteConnectionConfirm', {'name': name});
  String connectingTo(String host) =>
      getWithParams('connectingTo', {'host': host});
  String connectionFailed(String error) =>
      getWithParams('connectionFailed', {'error': error});
  String connectedTo(String host) =>
      getWithParams('connectedTo', {'host': host});
  String lastConnected(String time) =>
      getWithParams('lastConnected', {'time': time});
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'zh', 'ja'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
