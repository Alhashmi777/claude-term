import 'package:flutter/material.dart';
import '../models/ssh_connection.dart';
import '../l10n/app_localizations.dart';

class ConnectionFormScreen extends StatefulWidget {
  final SSHConnection? connection;

  const ConnectionFormScreen({Key? key, this.connection}) : super(key: key);

  @override
  State<ConnectionFormScreen> createState() => _ConnectionFormScreenState();
}

class _ConnectionFormScreenState extends State<ConnectionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _hostController;
  late TextEditingController _portController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  // Claude API 配置
  late TextEditingController _apiKeyController;
  late TextEditingController _baseUrlController;
  late TextEditingController _maxTokensController;

  bool _obscurePassword = true;
  bool _obscureApiKey = true;
  bool _isEditing = false;
  bool _showClaudeConfig = false;

  // 自动启动 Claude Code
  bool _autoStartClaude = false;
  bool _skipPermissions = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.connection != null;

    _nameController = TextEditingController(
      text: widget.connection?.name ?? '',
    );
    _hostController = TextEditingController(
      text: widget.connection?.host ?? '',
    );
    _portController = TextEditingController(
      text: (widget.connection?.port ?? 22).toString(),
    );
    _usernameController = TextEditingController(
      text: widget.connection?.username ?? '',
    );
    _passwordController = TextEditingController(
      text: widget.connection?.password ?? '',
    );

    // Claude API 配置
    _apiKeyController = TextEditingController(
      text: widget.connection?.anthropicApiKey ?? '',
    );
    _baseUrlController = TextEditingController(
      text: widget.connection?.anthropicBaseUrl ?? '',
    );
    _maxTokensController = TextEditingController(
      text: widget.connection?.maxOutputTokens?.toString() ?? '',
    );

    // 如果有 Claude 配置，自动展开
    _showClaudeConfig = widget.connection?.anthropicApiKey != null &&
        widget.connection!.anthropicApiKey!.isNotEmpty;

    // 自动启动 Claude Code
    _autoStartClaude = widget.connection?.autoStartClaude ?? false;
    _skipPermissions = widget.connection?.skipPermissions ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _hostController.dispose();
    _portController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _apiKeyController.dispose();
    _baseUrlController.dispose();
    _maxTokensController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final connection = SSHConnection(
        id: widget.connection?.id,
        name: _nameController.text.trim(),
        host: _hostController.text.trim(),
        port: int.tryParse(_portController.text) ?? 22,
        username: _usernameController.text.trim(),
        password: _passwordController.text.isEmpty
            ? null
            : _passwordController.text,
        lastConnected: widget.connection?.lastConnected,
        anthropicApiKey: _apiKeyController.text.isEmpty
            ? null
            : _apiKeyController.text.trim(),
        anthropicBaseUrl: _baseUrlController.text.isEmpty
            ? null
            : _baseUrlController.text.trim(),
        maxOutputTokens: _maxTokensController.text.isEmpty
            ? null
            : int.tryParse(_maxTokensController.text),
        autoStartClaude: _autoStartClaude,
        skipPermissions: _skipPermissions,
      );

      Navigator.pop(context, connection);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.editConnection : l10n.addConnection),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          TextButton(
            onPressed: _save,
            child: Text(l10n.save),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 连接名称
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.connectionName,
                hintText: l10n.connectionNameHint,
                prefixIcon: const Icon(Icons.label),
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.connectionNameRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // 主机地址
            TextFormField(
              controller: _hostController,
              decoration: InputDecoration(
                labelText: l10n.hostAddress,
                hintText: l10n.hostAddressHint,
                prefixIcon: const Icon(Icons.computer),
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.hostAddressRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // 端口
            TextFormField(
              controller: _portController,
              decoration: InputDecoration(
                labelText: l10n.port,
                hintText: l10n.portHint,
                prefixIcon: const Icon(Icons.numbers),
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  final port = int.tryParse(value);
                  if (port == null || port < 1 || port > 65535) {
                    return l10n.portInvalid;
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // 用户名
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: l10n.username,
                hintText: l10n.usernameHint,
                prefixIcon: const Icon(Icons.person),
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.usernameRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // 密码
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: l10n.password,
                hintText: l10n.passwordHint,
                prefixIcon: const Icon(Icons.lock),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Claude API 配置区域
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.smart_toy, color: Colors.green),
                    title: Text(l10n.claudeApiConfig),
                    subtitle: Text(_showClaudeConfig ? l10n.tapToCollapse : l10n.tapToExpand),
                    trailing: Icon(
                      _showClaudeConfig
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                    ),
                    onTap: () {
                      setState(() {
                        _showClaudeConfig = !_showClaudeConfig;
                      });
                    },
                  ),
                  if (_showClaudeConfig)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        children: [
                          // API Key
                          TextFormField(
                            controller: _apiKeyController,
                            obscureText: _obscureApiKey,
                            decoration: InputDecoration(
                              labelText: 'ANTHROPIC_API_KEY',
                              hintText: 'sk-...',
                              prefixIcon: const Icon(Icons.key),
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureApiKey
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureApiKey = !_obscureApiKey;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Base URL
                          TextFormField(
                            controller: _baseUrlController,
                            decoration: InputDecoration(
                              labelText: 'ANTHROPIC_BASE_URL ${l10n.optional}',
                              hintText: 'https://api.anthropic.com',
                              prefixIcon: const Icon(Icons.link),
                              border: const OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.url,
                          ),
                          const SizedBox(height: 12),

                          // Max Output Tokens
                          TextFormField(
                            controller: _maxTokensController,
                            decoration: InputDecoration(
                              labelText: 'MAX_OUTPUT_TOKENS ${l10n.optional}',
                              hintText: '32000',
                              prefixIcon: const Icon(Icons.data_usage),
                              border: const OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),

                          // 自动启动 Claude Code
                          SwitchListTile(
                            title: Text(l10n.autoStartClaude),
                            subtitle: Text(l10n.autoStartClaudeHint),
                            value: _autoStartClaude,
                            onChanged: (value) {
                              setState(() {
                                _autoStartClaude = value;
                                if (!value) {
                                  _skipPermissions = false;
                                }
                              });
                            },
                            secondary: const Icon(Icons.play_arrow, color: Colors.green),
                          ),

                          // 跳过权限确认
                          if (_autoStartClaude)
                            SwitchListTile(
                              title: Text(l10n.skipPermissions),
                              subtitle: Text(
                                l10n.skipPermissionsWarning,
                                style: TextStyle(color: Colors.orange[700], fontSize: 12),
                              ),
                              value: _skipPermissions,
                              onChanged: (value) {
                                setState(() {
                                  _skipPermissions = value;
                                });
                              },
                              secondary: Icon(Icons.warning, color: Colors.orange[700]),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 提示信息
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[700]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.sshTip,
                      style: TextStyle(color: Colors.blue[700], fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
