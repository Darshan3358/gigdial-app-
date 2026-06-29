import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class PrivacyTermsScreen extends StatelessWidget {
  const PrivacyTermsScreen({super.key});

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
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
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textLight,
              height: 1.5,
            ),
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
          'Privacy & Terms',
          style: TextStyle(
            color: AppTheme.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(
                '1. Acceptable Terms',
                'Welcome to GigDial. By logging in or booking any local service on our application, you explicitly agree to follow our service conditions. If you disagree with any terms, please discontinue using this app immediately.',
              ),
              _buildSection(
                '2. Customer Booking Policies',
                'GigDial connects customers directly with local independent workers. Any terms of payment, additional tasks, and working hours are aligned directly between the worker and the customer. GigDial is not responsible for task disputes.',
              ),
              _buildSection(
                '3. Privacy & Personal Data',
                'We store your profile data (full name, email address, phone number, and location history) to facilitate booking notifications. Your credentials and credit cards are completely encrypted and never shared with third-party networks.',
              ),
              _buildSection(
                '4. Service Cancellations',
                'Customers may cancel pending requests at any time without fees. Once the worker has contacted you and status transitions to "Contacted", cancellation should be coordinated directly with the provider.',
              ),
              _buildSection(
                '5. Updates to Terms',
                'GigDial reserves the right to modify these operational guidelines at any time. Tapping accept or using our services post modifications is considered dynamic agreement.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
