import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/app_config.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<Map<String, String>> get _onboardingData {
    if (AppConfig.flavor == AppFlavor.worker) {
      return [
        {
          'image': 'assets/images/onboarding_worker_1782205890507.png',
          'titlePart1': 'Get More Leads\n',
          'titlePart2': 'and Orders',
          'subtitle': 'Find customers near your location.\nGet booked directly with no middleman.',
        },
        {
          'image': 'assets/images/home_banner_worker_1782206027558.png',
          'titlePart1': 'Grow Your\n',
          'titlePart2': 'Business',
          'subtitle': 'Build your online reputation.\nEarn high ratings and receive direct bookings.',
        },
        {
          'image': 'assets/images/payment_success_screen.png',
          'titlePart1': 'Direct Instant\n',
          'titlePart2': 'Payments',
          'subtitle': 'Receive direct, safe payments from customers.\nNo deductions, keep 100% of your earnings.',
        },
      ];
    } else {
      return [
        {
          'image': 'assets/images/onboarding1.png',
          'titlePart1': 'Find Skilled\n',
          'titlePart2': 'Workers Near You',
          'subtitle': '45+ local services at your fingertips.\nConnect directly, work directly.',
        },
        {
          'image': 'assets/images/onboarding2.png',
          'titlePart1': 'Direct Worker\n',
          'titlePart2': 'Connection',
          'subtitle': 'Connect directly. Work directly.\nChoose top professionals easily.',
        },
        {
          'image': 'assets/images/onboarding3.png',
          'titlePart1': 'Book Services\n',
          'titlePart2': 'in Minutes',
          'subtitle': 'Book trusted services in just a few taps.\nFast, safe, and transparent pricing.',
        },
      ];
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = AppConfig.primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  final item = _onboardingData[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        
                        // Title (RichText for dynamic blue & dark text coloring)
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                            ),
                            children: [
                              TextSpan(
                                text: item['titlePart1']!,
                                style: TextStyle(color: primaryColor),
                              ),
                              TextSpan(
                                text: item['titlePart2']!,
                                style: const TextStyle(color: AppTheme.textDark),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Subtitle
                        Text(
                          item['subtitle']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 15,
                            color: Colors.grey[600],
                            height: 1.4,
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Image Container (centered illustration)
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Image.asset(
                              item['image']!,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    index == 0
                                        ? Icons.search
                                        : index == 1
                                            ? Icons.people
                                            : Icons.check_circle_outline,
                                    size: 120,
                                    color: primaryColor.withOpacity(0.5),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              ),
            ),
            
            // Bottom Page Indicators & Get Started Button
            Column(
              children: [
                // Page Indicator Dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _onboardingData.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      width: 8.0,
                      height: 8.0,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? primaryColor
                            : Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Get Started Button
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: const Text('Get Started'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
