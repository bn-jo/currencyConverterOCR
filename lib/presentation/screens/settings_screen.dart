import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../domain/providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('settings'.tr()),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // Language Section
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Theme.of(context).primaryColor, width: 1),
            ),
            child: ListTile(
              leading: Icon(Icons.language, color: Theme.of(context).primaryColor),
              title: Text(
                'language'.tr(),
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(_getLanguageName(settings.languageCode)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _showLanguagePicker(context, ref),
            ),
          ),

          // Dark Mode Section
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Theme.of(context).primaryColor, width: 1),
            ),
            child: SwitchListTile(
              secondary: Icon(Icons.dark_mode, color: Theme.of(context).primaryColor),
              title: Text(
                'dark_mode'.tr(),
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              value: settings.isDarkMode,
              activeColor: Theme.of(context).primaryColor,
              onChanged: (value) {
                ref.read(settingsProvider.notifier).toggleDarkMode();
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      case 'he':
        return 'עברית';
      default:
        return code;
    }
  }

  void _showLanguagePicker(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('select_language'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _languageOption(context, ref, 'en', 'English'),
            _languageOption(context, ref, 'es', 'Español'),
            _languageOption(context, ref, 'he', 'עברית'),
          ],
        ),
      ),
    );
  }

  Widget _languageOption(
    BuildContext context,
    WidgetRef ref,
    String code,
    String name,
  ) {
    return ListTile(
      title: Text(name),
      trailing: Icon(Icons.check_circle_outline, color: Theme.of(context).primaryColor),
      onTap: () {
        ref.read(settingsProvider.notifier).setLanguage(code);
        context.setLocale(Locale(code));
        Navigator.pop(context);
      },
    );
  }
}
