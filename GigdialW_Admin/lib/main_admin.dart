import 'package:flutter/material.dart';
import 'data/app_config.dart';
import 'main.dart' as app;

void main() {
  AppConfig.flavor = AppFlavor.admin;
  AppConfig.showDebugSwitcher = false;
  app.main();
}
