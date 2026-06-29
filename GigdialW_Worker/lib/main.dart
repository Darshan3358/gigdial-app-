import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'widgets/role_switcher.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/user/home_screen.dart';
import 'screens/user/service_listing_screen.dart';
import 'screens/user/worker_profile_screen.dart';
import 'screens/user/book_service_screen.dart';
import 'screens/user/booking_confirmation_screen.dart';
import 'screens/user/my_leads_screen.dart';
import 'screens/user/user_profile_screen.dart';
import 'screens/user/settings_screen.dart';
import 'screens/user/settings/notification_settings_screen.dart';
import 'screens/user/settings/security_settings_screen.dart';
import 'screens/user/settings/privacy_terms_screen.dart';
import 'screens/user/settings/support_screen.dart';
import 'screens/user/settings/about_screen.dart';
import 'screens/worker/worker_dashboard_screen.dart';
import 'screens/worker/lead_details_screen.dart';
import 'screens/worker/manage_categories_screen.dart';
import 'screens/worker/subscription_plans_screen.dart';
import 'screens/worker/payment_screen.dart';
import 'screens/worker/payment_success_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/admin/manage_workers_screen.dart';
import 'screens/chat/chat_list_screen.dart';
import 'screens/chat/chat_room_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'data/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyB7QeB-gUg0y8j5c75PF4YDAINMM93ff7A",
        appId: "1:455116120101:android:88e9a3dc85619475171fcc",
        messagingSenderId: "455116120101",
        projectId: "gigdial-8a19a",
        databaseURL: "https://gigdial-8a19a-default-rtdb.firebaseio.com/",
      ),
    );
  } catch (e) {
    print("Firebase initialization error: $e");
  }
  AppConfig.flavor = AppFlavor.worker;
  AppConfig.showDebugSwitcher = false;
  runApp(const GigDialApp());
}

class GigDialApp extends StatelessWidget {
  const GigDialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: RoleSwitcherOverlay.navigatorKey,
      title: 'GigDial',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      
      // Global builder wrapping every route in our Floating Role Switcher debug tool
      builder: (context, child) {
        return RoleSwitcherOverlay(child: child!);
      },

      // Navigation Routes
      initialRoute: '/',
      routes: {
        // Onboarding & Auth
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),

        // User Flow (Client)
        '/user_home': (context) => const HomeScreen(),
        '/service_listing': (context) => const ServiceListingScreen(),
        '/worker_profile': (context) => const WorkerProfileScreen(),
        '/book_service': (context) => const BookServiceScreen(),
        '/booking_confirmation': (context) => const BookingConfirmationScreen(),
        '/my_leads': (context) => const MyLeadsScreen(),
        '/user_profile': (context) => const UserProfileScreen(),

        // User Settings screens
        '/settings': (context) => const SettingsScreen(),
        '/settings/notifications': (context) => const NotificationSettingsScreen(),
        '/settings/security': (context) => const SecuritySettingsScreen(),
        '/settings/privacy': (context) => const PrivacyTermsScreen(),
        '/settings/support': (context) => const SupportScreen(),
        '/settings/about': (context) => const AboutScreen(),

        // In-App Chats
        '/chat_list': (context) => const ChatListScreen(),
        '/chat_room': (context) => const ChatRoomScreen(),

        // Worker Flow (Service Provider)
        '/worker_dashboard': (context) => const WorkerDashboardScreen(),
        '/lead_details': (context) => const LeadDetailsScreen(),
        '/manage_categories': (context) => const ManageCategoriesScreen(),

        // Subscription & Payments
        '/subscription_plans': (context) => const SubscriptionPlansScreen(),
        '/payment': (context) => const PaymentScreen(),
        '/payment_success': (context) => const PaymentSuccessScreen(),

        // Admin Panel Flow
        '/admin_dashboard': (context) => const AdminDashboardScreen(),
        '/manage_workers': (context) => const ManageWorkersScreen(),
      },
    );
  }
}
