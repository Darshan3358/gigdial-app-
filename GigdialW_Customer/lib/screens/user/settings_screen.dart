import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Widget _buildSettingsTile(BuildContext context, IconData icon, String title, String subtitle, String routeName) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppTheme.primaryBlue, size: 20),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          onTap: () => Navigator.pushNamed(context, routeName),
        ),
        const Divider(height: 1, indent: 72, endIndent: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: AppTheme.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 16),
            _buildSettingsTile(
              context,
              Icons.lock_outline,
              'Security & Biometrics',
              'Update password and biometrics parameters',
              '/settings/security',
            ),
            _buildSettingsTile(
              context,
              Icons.notifications_none_outlined,
              'Notification Preferences',
              'Configure email, push and text alerts',
              '/settings/notifications',
            ),
            _buildSettingsTile(
              context,
              Icons.privacy_tip_outlined,
              'Privacy Policy & Terms',
              'Review app terms of service and license',
              '/settings/privacy',
            ),
            _buildSettingsTile(
              context,
              Icons.support_agent_outlined,
              'Help & Support',
              'Contact customer support and query tickets',
              '/settings/support',
            ),
            _buildSettingsTile(
              context,
              Icons.info_outline,
              'About GigDial',
              'Check application details and version info',
              '/settings/about',
            ),
          ],
        ),
      ),
    );
  }
}
