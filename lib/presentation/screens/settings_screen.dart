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
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        title: Text(
          'settings'.tr(),
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // Language Section
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C2C),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF4CAF50), width: 1),
            ),
            child: ListTile(
              leading: const Icon(Icons.language, color: Color(0xFF4CAF50)),
              title: Text(
                'language'.tr(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                _getLanguageName(settings.languageCode),
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
              onTap: () => _showLanguagePicker(context, ref),
            ),
          ),

          // Dark Mode Section
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C2C),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF4CAF50), width: 1),
            ),
            child: SwitchListTile(
              secondary: const Icon(Icons.dark_mode, color: Color(0xFF4CAF50)),
              title: Text(
                'dark_mode'.tr(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
              value: settings.isDarkMode,
              activeColor: const Color(0xFF4CAF50),
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
      builder: (context) => Theme(
        data: ThemeData.dark().copyWith(
          dialogBackgroundColor: const Color(0xFF2C2C2C),
        ),
        child: AlertDialog(
          backgroundColor: const Color(0xFF2C2C2C),
          title: Text(
            'select_language'.tr(),
            style: const TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _languageOption(context, ref, 'en', 'English'),
              _languageOption(context, ref, 'es', 'Español'),
              _languageOption(context, ref, 'he', 'עברית'),
            ],
          ),
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
      title: Text(
        name,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: const Icon(Icons.check_circle_outline, color: Color(0xFF4CAF50)),
      onTap: () {
        ref.read(settingsProvider.notifier).setLanguage(code);
        context.setLocale(Locale(code));
        Navigator.pop(context);
      },
    );
  }
}
