import 'package:flutter/material.dart';

enum AppFlavor { customer, worker, admin }

class AppConfig {
  static AppFlavor flavor = AppFlavor.customer;
  static bool showDebugSwitcher = false;

  static String get appName {
    switch (flavor) {
      case AppFlavor.customer:
        return 'GigDial';
      case AppFlavor.worker:
        return 'GigDial Partner';
      case AppFlavor.admin:
        return 'GigDial Control';
    }
  }
  
  static String get homeRoute {
    switch (flavor) {
      case AppFlavor.customer:
        return '/user_home';
      case AppFlavor.worker:
        return '/worker_dashboard';
      case AppFlavor.admin:
        return '/admin_dashboard';
    }
  }
  
  static Color get primaryColor {
    switch (flavor) {
      case AppFlavor.customer:
        return const Color(0xFF0F3D8D);
      case AppFlavor.worker:
        return Colors.teal;
      case AppFlavor.admin:
        return const Color(0xFF32325D); // Deep Indigo/Slate
    }
  }
}
