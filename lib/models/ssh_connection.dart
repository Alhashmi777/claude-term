import 'package:uuid/uuid.dart';

class SSHConnection {
  final String id;
  String name;
  String host;
  int port;
  String username;
  String? password;
  String? privateKey;
  DateTime? lastConnected;

  // Claude API 配置
  String? anthropicApiKey;
  String? anthropicBaseUrl;
  int? maxOutputTokens;

  // 自动启动 Claude Code
  bool autoStartClaude;
  bool skipPermissions;

  SSHConnection({
    String? id,
    required this.name,
    required this.host,
    this.port = 22,
    required this.username,
    this.password,
    this.privateKey,
    this.lastConnected,
    this.anthropicApiKey,
    this.anthropicBaseUrl,
    this.maxOutputTokens,
    this.autoStartClaude = false,
    this.skipPermissions = false,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'host': host,
      'port': port,
      'username': username,
      'password': password,
      'privateKey': privateKey,
      'lastConnected': lastConnected?.toIso8601String(),
      'anthropicApiKey': anthropicApiKey,
      'anthropicBaseUrl': anthropicBaseUrl,
      'maxOutputTokens': maxOutputTokens,
      'autoStartClaude': autoStartClaude,
      'skipPermissions': skipPermissions,
    };
  }

  factory SSHConnection.fromJson(Map<String, dynamic> json) {
    return SSHConnection(
      id: json['id'],
      name: json['name'],
      host: json['host'],
      port: json['port'] ?? 22,
      username: json['username'],
      password: json['password'],
      privateKey: json['privateKey'],
      lastConnected: json['lastConnected'] != null
          ? DateTime.parse(json['lastConnected'])
          : null,
      anthropicApiKey: json['anthropicApiKey'],
      anthropicBaseUrl: json['anthropicBaseUrl'],
      maxOutputTokens: json['maxOutputTokens'],
      autoStartClaude: json['autoStartClaude'] ?? false,
      skipPermissions: json['skipPermissions'] ?? false,
    );
  }

  SSHConnection copyWith({
    String? name,
    String? host,
    int? port,
    String? username,
    String? password,
    String? privateKey,
    DateTime? lastConnected,
    String? anthropicApiKey,
    String? anthropicBaseUrl,
    int? maxOutputTokens,
    bool? autoStartClaude,
    bool? skipPermissions,
  }) {
    return SSHConnection(
      id: id,
      name: name ?? this.name,
      host: host ?? this.host,
      port: port ?? this.port,
      username: username ?? this.username,
      password: password ?? this.password,
      privateKey: privateKey ?? this.privateKey,
      lastConnected: lastConnected ?? this.lastConnected,
      anthropicApiKey: anthropicApiKey ?? this.anthropicApiKey,
      anthropicBaseUrl: anthropicBaseUrl ?? this.anthropicBaseUrl,
      maxOutputTokens: maxOutputTokens ?? this.maxOutputTokens,
      autoStartClaude: autoStartClaude ?? this.autoStartClaude,
      skipPermissions: skipPermissions ?? this.skipPermissions,
    );
  }
}
