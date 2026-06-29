import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/booking_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTabIndex = 0;
  String _selectedCity = 'Ahmedabad';

  final List<String> _cities = [
    'Ahmedabad',
    'Amritsar',
    'Bangalore',
    'Bhopal',
    'Bhubaneswar',
    'Chandigarh',
    'Chennai',
    'Coimbatore',
    'Dehradun',
    'Delhi',
    'Gandhinagar',
    'Gurgaon',
    'Guwahati',
    'Hyderabad',
    'Indore',
    'Jaipur',
    'Kochi',
    'Kolkata',
    'Lucknow',
    'Mumbai',
    'Nagpur',
    'Noida',
    'Patna',
    'Pune',
    'Rajkot',
    'Ranchi',
    'Surat',
    'Thiruvananthapuram',
    'Vadodara',
    'Visakhapatnam'
  ];

  final List<Map<String, dynamic>> _popularServices = [
    {'name': 'Plumber', 'icon': Icons.plumbing, 'color': Color(0xFFE0F2FE)},
    {'name': 'Electrician', 'icon': Icons.lightbulb_outline, 'color': Color(0xFFFEF3C7)},
    {'name': 'Carpenter', 'icon': Icons.handyman, 'color': Color(0xFFFFEDD5)},
    {'name': 'Painter', 'icon': Icons.brush, 'color': Color(0xFFFCE7F3)},
    {'name': 'AC Repair', 'icon': Icons.ac_unit, 'color': Color(0xFFCFFAFE)},
    {'name': 'Cleaner', 'icon': Icons.cleaning_services, 'color': Color(0xFFF3E8FF)},
    {'name': 'RO Service', 'icon': Icons.water_drop, 'color': Color(0xFFDCFCE7)},
    {'name': 'Appliance Repair', 'icon': Icons.home_repair_service, 'color': Color(0xFFFEF9C3)},
  ];

  final List<Map<String, dynamic>> _topRatedProfessionals = [
    {
      'name': 'Ramesh Yadav',
      'profession': 'Electrician',
      'rating': 4.8,
      'image': 'assets/images/worker_ramesh.png',
    },
    {
      'name': 'Suresh Patel',
      'profession': 'Plumber',
      'rating': 4.7,
      'image': 'assets/images/worker_mahesh.png',
    },
    {
      'name': 'Mahesh Kumar',
      'profession': 'AC Technician',
      'rating': 4.9,
      'image': 'assets/images/worker_ramesh.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 16,
        title: Row(
          children: [
            const Icon(Icons.location_on, color: AppTheme.textDark, size: 20),
            const SizedBox(width: 4),
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedCity,
                icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.textDark, size: 20),
                style: AppTheme.titleMedium.copyWith(
                  color: AppTheme.textDark,
                  fontWeight: FontWeight.bold,
                ),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedCity = newValue;
                    });
                  }
                },
                items: _cities.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: AppTheme.textDark),
            onPressed: () {
              Navigator.pushNamed(context, '/chat_list', arguments: {'isWorker': false});
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_outlined, color: AppTheme.textDark),
                onPressed: () {},
              ),
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar with Decreased Border Radius (6.0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  readOnly: true,
                  onTap: () => Navigator.pushNamed(context, '/service_listing'),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    hintText: 'What Service Do You Need Today?',
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6), // Sharp modern look (decreased radius)
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Banner Card with updated vector illustration and tagline content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBF2FA),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      // Text Contents
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Instant Professional\nHome Services\nat Your Doorstep!',
                              style: TextStyle(
                                color: AppTheme.textDark,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () => Navigator.pushNamed(context, '/service_listing'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.accentYellow,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                minimumSize: Size.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Find Service',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Right side worker image illustration (updated to new v2 banner)
                      Positioned(
                        right: 12,
                        bottom: 0,
                        top: 0,
                        child: Image.asset(
                          'assets/images/home_banner_v2.png',
                          width: 140,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox(width: 140);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Popular Services Section
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Popular Services',
                      style: AppTheme.titleMedium.copyWith(fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/service_listing'),
                      child: const Text(
                        'See All',
                        style: TextStyle(
                          color: AppTheme.primaryBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Services Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _popularServices.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemBuilder: (context, index) {
                    final item = _popularServices[index];
                    return GestureDetector(
                      onTap: () {
                        String category = item['name'];
                        Navigator.pushNamed(
                          context,
                          '/service_listing',
                          arguments: category,
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: item['color'],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              item['icon'],
                              color: AppTheme.primaryBlue,
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item['name'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textDark,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),
              
              // More Services Pill Button
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/service_listing'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                    minimumSize: Size.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    '+45 More Services',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Top Rated Professionals Section
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Top Rated Professionals',
                      style: AppTheme.titleMedium.copyWith(fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/service_listing'),
                      child: const Text(
                        'See All',
                        style: TextStyle(
                          color: AppTheme.primaryBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Horizontal row of 3 cards matching mockup exactly
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: _topRatedProfessionals.map((worker) {
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          final bookingState = BookingState();
                          WorkerModel? matchedWorker;
                          for (var list in bookingState.workersByCategory.values) {
                            for (var w in list) {
                              if (w.name == worker['name']) {
                                matchedWorker = w;
                                break;
                              }
                            }
                          }
                          // Fallback
                          matchedWorker ??= WorkerModel(
                            name: worker['name']!,
                            profession: worker['profession']!,
                            experience: '6 Years Experience',
                            rating: worker['rating']!,
                            reviews: '105 Reviews',
                            location: 'Ahmedabad',
                            image: worker['image']!,
                            skills: ['Professional Repair', 'Diagnostic Check', 'General Maintenance'],
                            about: 'I am a highly rated service professional providing reliable work in Ahmedabad.',
                          );
                          Navigator.pushNamed(
                            context,
                            '/worker_profile',
                            arguments: matchedWorker,
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFF1F5F9)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundImage: AssetImage(worker['image']!),
                                backgroundColor: const Color(0xFFF1F5F9),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                worker['name']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: AppTheme.textDark,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                worker['profession']!,
                                style: const TextStyle(
                                  color: AppTheme.textLight,
                                  fontSize: 10,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.star, color: Color(0xFFFBBF24), size: 12),
                                  const SizedBox(width: 2),
                                  Text(
                                    '${worker['rating']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                      color: AppTheme.textDark,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryBlue,
        unselectedItemColor: Colors.grey[400],
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        onTap: (index) {
          setState(() {
            _currentTabIndex = index;
          });
          if (index == 1) Navigator.pushNamed(context, '/service_listing');
          if (index == 2) Navigator.pushNamed(context, '/book_service');
          if (index == 3) Navigator.pushNamed(context, '/my_leads');
          if (index == 4) Navigator.pushNamed(context, '/user_profile');
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home, color: AppTheme.primaryBlue),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            activeIcon: Icon(Icons.grid_view, color: AppTheme.primaryBlue),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month, color: AppTheme.primaryBlue),
            label: 'Book',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment, color: AppTheme.primaryBlue),
            label: 'My Bookings', // Renamed label
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person, color: AppTheme.primaryBlue),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
