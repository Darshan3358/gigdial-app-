import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
          'About GigDial',
          style: TextStyle(
            color: AppTheme.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              // App Icon mockup
              Center(
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.12), width: 1.5),
                  ),
                  child: const Icon(
                    Icons.handyman_outlined,
                    size: 44,
                    color: AppTheme.primaryBlue,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'GigDial Client App',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Version 1.0.0 (Build 125)',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textLight,
                ),
              ),
              const SizedBox(height: 30),
              
              // Divider info list
              const Divider(color: Color(0xFFF1F5F9)),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Developer Info',
                      style: TextStyle(fontSize: 13, color: AppTheme.textLight),
                    ),
                    Text(
                      'Google DeepMind team',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                    ),
                  ],
                ),
              ),
              const Divider(color: Color(0xFFF1F5F9)),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Technological Stack',
                      style: TextStyle(fontSize: 13, color: AppTheme.textLight),
                    ),
                    Text(
                      'Flutter / Dart Framework',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                    ),
                  ],
                ),
              ),
              const Divider(color: Color(0xFFF1F5F9)),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Operating System',
                      style: TextStyle(fontSize: 13, color: AppTheme.textLight),
                    ),
                    Text(
                      'Android OS Package (APK)',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                    ),
                  ],
                ),
              ),
              const Divider(color: Color(0xFFF1F5F9)),
              const Spacer(),
              
              const Text(
                '© 2026 GigDial Inc. All rights reserved.',
                style: TextStyle(
                  fontSize: 11,
                  color: AppTheme.textLight,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
