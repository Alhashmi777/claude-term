import 'package:flutter/material.dart';
import '../models/terminal_theme_config.dart';
import '../l10n/app_localizations.dart';

class ThemePickerDialog extends StatelessWidget {
  final String currentTheme;
  final Function(String) onThemeSelected;

  const ThemePickerDialog({
    Key? key,
    required this.currentTheme,
    required this.onThemeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(l10n.selectTheme),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: TerminalThemeConfig.presets.length,
          itemBuilder: (context, index) {
            final themeConfig = TerminalThemeConfig.presets[index];
            final isSelected = themeConfig.name == currentTheme;

            // 对 "默认" 主题使用本地化名称
            final displayName = themeConfig.name == 'default'
                ? l10n.themeDefault
                : themeConfig.displayName;

            return Card(
              color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
              child: ListTile(
                leading: _buildThemePreview(themeConfig),
                title: Text(
                  displayName,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                trailing: isSelected
                    ? Icon(Icons.check, color: Theme.of(context).primaryColor)
                    : null,
                onTap: () {
                  onThemeSelected(themeConfig.name);
                  Navigator.pop(context);
                },
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
      ],
    );
  }

  Widget _buildThemePreview(TerminalThemeConfig themeConfig) {
    return Container(
      width: 48,
      height: 32,
      decoration: BoxDecoration(
        color: themeConfig.theme.background,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Center(
        child: Text(
          '>_',
          style: TextStyle(
            color: themeConfig.theme.foreground,
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
