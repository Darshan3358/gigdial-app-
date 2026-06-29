import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _pushEnabled = true;
  bool _emailEnabled = true;
  bool _smsEnabled = false;
  bool _offersEnabled = true;

  Widget _buildSwitchTile(String title, String description, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeColor: AppTheme.primaryBlue,
            onChanged: onChanged,
          ),
        ],
      ),
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
          'Notifications',
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
            _buildSwitchTile(
              'Push Notifications',
              'Receive instant notifications when a job updates',
              _pushEnabled,
              (val) => setState(() => _pushEnabled = val),
            ),
            const Divider(indent: 20, endIndent: 20),
            _buildSwitchTile(
              'Email Notifications',
              'Receive monthly transaction invoices and receipts via email',
              _emailEnabled,
              (val) => setState(() => _emailEnabled = val),
            ),
            const Divider(indent: 20, endIndent: 20),
            _buildSwitchTile(
              'SMS Messages',
              'Receive updates and confirmation details on mobile',
              _smsEnabled,
              (val) => setState(() => _smsEnabled = val),
            ),
            const Divider(indent: 20, endIndent: 20),
            _buildSwitchTile(
              'Promotions & Offers',
              'Get notified about coupons, visibility plans, and new services',
              _offersEnabled,
              (val) => setState(() => _offersEnabled = val),
            ),
            const Divider(indent: 20, endIndent: 20),
          ],
        ),
      ),
    );
  }
}
