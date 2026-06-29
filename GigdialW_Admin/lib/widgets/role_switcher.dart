import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/app_config.dart';

class RoleSwitcherOverlay extends StatefulWidget {
  final Widget child;
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  const RoleSwitcherOverlay({super.key, required this.child});

  @override
  State<RoleSwitcherOverlay> createState() => _RoleSwitcherOverlayState();
}

class _RoleSwitcherOverlayState extends State<RoleSwitcherOverlay> {
  Offset position = const Offset(20, 100); // Default position of the floating button

  void _showNavigationDrawer(BuildContext context) {
    final navContext = RoleSwitcherOverlay.navigatorKey.currentContext;
    if (navContext == null) return;
    showModalBottomSheet(
      context: navContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Screen Navigator & Role Switcher',
                    style: AppTheme.titleLarge.copyWith(color: AppTheme.primaryBlue),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Quickly jump to any of the 17 screens',
                    style: AppTheme.bodyMedium,
                  ),
                  const Divider(height: 25),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        _buildSectionHeader('1. Onboarding & Authentication'),
                        _buildScreenItem(context, 'Splash Screen (1)', '/'),
                        _buildScreenItem(context, 'Onboarding Carousel (2)', '/onboarding'),
                        _buildScreenItem(context, 'Login Page (3)', '/login'),
                        _buildScreenItem(context, 'Register Page (3)', '/register'),
                        
                        _buildSectionHeader('2. User Flow (Client)'),
                        _buildScreenItem(context, 'Home Screen (4)', '/user_home'),
                        _buildScreenItem(context, 'Service Listing (5)', '/service_listing'),
                        _buildScreenItem(context, 'Worker Profile (6)', '/worker_profile'),
                        _buildScreenItem(context, 'Book Service Form (7)', '/book_service'),
                        _buildScreenItem(context, 'Booking Confirmation (8)', '/booking_confirmation'),
                        _buildScreenItem(context, 'My Leads List (9)', '/my_leads'),
                        _buildScreenItem(context, 'User Profile Settings (10)', '/user_profile'),

                        _buildSectionHeader('3. Worker Flow (Service Provider)'),
                        _buildScreenItem(context, 'Worker Dashboard (11)', '/worker_dashboard'),
                        _buildScreenItem(context, 'Lead Details (12)', '/lead_details'),

                        _buildSectionHeader('4. Subscription & Payment Flow'),
                        _buildScreenItem(context, 'Subscription Plans (13)', '/subscription_plans'),
                        _buildScreenItem(context, 'Payment Screen (14)', '/payment'),
                        _buildScreenItem(context, 'Payment Success (15)', '/payment_success'),

                        _buildSectionHeader('5. Admin Panel Flow'),
                        _buildScreenItem(context, 'Admin Dashboard (16)', '/admin_dashboard'),
                        _buildScreenItem(context, 'Manage Workers Table (17)', '/manage_workers'),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppTheme.accentYellow,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildScreenItem(BuildContext context, String name, String routePath) {
    return Card(
      elevation: 0,
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      margin: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        title: Text(name, style: AppTheme.bodyBold),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.primaryBlue),
        dense: true,
        onTap: () {
          final navState = RoleSwitcherOverlay.navigatorKey.currentState;
          if (navState != null) {
            navState.pop(); // Close sheet
            navState.pushNamed(routePath);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!AppConfig.showDebugSwitcher) {
      return widget.child;
    }
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          widget.child,
          Positioned(
            left: position.dx,
            top: position.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  position = Offset(
                    position.dx + details.delta.dx,
                    position.dy + details.delta.dy,
                  );
                });
              },
              child: FloatingActionButton(
                mini: true,
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: Colors.white,
                shape: const CircleBorder(),
                elevation: 6,
                onPressed: () => _showNavigationDrawer(context),
                child: const Icon(Icons.menu_open, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
