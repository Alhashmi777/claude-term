import 'package:flutter/material.dart';
import '../models/ssh_connection.dart';
import '../services/storage_service.dart';
import '../l10n/app_localizations.dart';
import 'terminal_screen.dart';
import 'connection_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storageService = StorageService();
  List<SSHConnection> _connections = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConnections();
  }

  Future<void> _loadConnections() async {
    final connections = await _storageService.loadConnections();
    setState(() {
      _connections = connections;
      _isLoading = false;
    });
  }

  Future<void> _saveConnections() async {
    await _storageService.saveConnections(_connections);
  }

  void _addConnection() async {
    final result = await Navigator.push<SSHConnection>(
      context,
      MaterialPageRoute(
        builder: (context) => const ConnectionFormScreen(),
      ),
    );

    if (result != null) {
      setState(() {
        _connections.add(result);
      });
      _saveConnections();
    }
  }

  void _editConnection(SSHConnection connection) async {
    final result = await Navigator.push<SSHConnection>(
      context,
      MaterialPageRoute(
        builder: (context) => ConnectionFormScreen(connection: connection),
      ),
    );

    if (result != null) {
      setState(() {
        final index = _connections.indexWhere((c) => c.id == result.id);
        if (index != -1) {
          _connections[index] = result;
        }
      });
      _saveConnections();
    }
  }

  void _deleteConnection(SSHConnection connection) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteConnectionTitle),
        content: Text(l10n.deleteConnectionConfirm(connection.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _connections.removeWhere((c) => c.id == connection.id);
              });
              _saveConnections();
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  void _connectTo(SSHConnection connection) {
    // 更新最后连接时间
    final updated = connection.copyWith(lastConnected: DateTime.now());
    setState(() {
      final index = _connections.indexWhere((c) => c.id == connection.id);
      if (index != -1) {
        _connections[index] = updated;
      }
    });
    _saveConnections();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TerminalScreen(connection: updated),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appName),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // 关于
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationName: l10n.appName,
                applicationVersion: '1.0.0',
                children: [
                  Text(l10n.appDescription),
                ],
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _connections.isEmpty
              ? _buildEmptyState(l10n)
              : _buildConnectionList(l10n),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addConnection,
        icon: const Icon(Icons.add),
        label: Text(l10n.addConnection),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.terminal,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noConnections,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.noConnectionsHint,
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionList(AppLocalizations l10n) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _connections.length,
      itemBuilder: (context, index) {
        final connection = _connections[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.computer, color: Colors.white),
            ),
            title: Text(
              connection.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${connection.username}@${connection.host}:${connection.port}',
              style: const TextStyle(fontFamily: 'monospace'),
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    _editConnection(connection);
                    break;
                  case 'delete':
                    _deleteConnection(connection);
                    break;
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      const Icon(Icons.edit),
                      const SizedBox(width: 8),
                      Text(l10n.edit),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      const Icon(Icons.delete, color: Colors.red),
                      const SizedBox(width: 8),
                      Text(l10n.delete, style: const TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () => _connectTo(connection),
          ),
        );
      },
    );
  }
}
