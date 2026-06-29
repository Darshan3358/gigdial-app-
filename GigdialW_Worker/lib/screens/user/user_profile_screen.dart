import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../theme/app_theme.dart';
import '../../data/booking_state.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  int _currentTabIndex = 4; // Profile matches tab index 4

  void _showSavedWorkersSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        final List<Map<String, dynamic>> savedWorkersList = [
          {
            'name': 'Ramesh Yadav',
            'profession': 'Electrician',
            'rating': 4.8,
            'image': 'assets/images/worker_ramesh.png',
            'location': 'Naroda, Ahmedabad',
          },
          {
            'name': 'Mahesh Kumar',
            'profession': 'AC Technician',
            'rating': 4.9,
            'image': 'assets/images/worker_ramesh.png',
            'location': 'Satellite, Ahmedabad',
          },
        ];

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Saved Workers',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close', style: TextStyle(color: AppTheme.primaryBlue)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              savedWorkersList.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Center(
                        child: Text(
                          'No saved workers yet.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  : Flexible(
                      child: Scrollbar(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: savedWorkersList.length,
                          itemBuilder: (context, index) {
                            final workerData = savedWorkersList[index];
                            return Column(
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: CircleAvatar(
                                    radius: 24,
                                    backgroundImage: AssetImage(workerData['image']),
                                    backgroundColor: const Color(0xFFF1F5F9),
                                  ),
                                  title: Text(
                                    workerData['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: AppTheme.textDark,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${workerData['profession']} • ${workerData['location']}',
                                    style: const TextStyle(fontSize: 12, color: AppTheme.textLight),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.chat_outlined, color: AppTheme.primaryBlue, size: 20),
                                        onPressed: () {
                                          Navigator.pop(context); // Close sheet
                                          Navigator.pushNamed(
                                            context,
                                            '/chat_room',
                                            arguments: {
                                              'customerName': 'Jitendra Singh',
                                              'workerName': workerData['name'],
                                              'isWorker': false,
                                            },
                                          );
                                        },
                                      ),
                                      const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.pop(context); // Close sheet
                                    final tempWorker = WorkerModel(
                                      name: workerData['name'],
                                      profession: workerData['profession'],
                                      experience: '8 Years Experience',
                                      rating: workerData['rating'],
                                      reviews: '120 Reviews',
                                      location: workerData['location'],
                                      image: workerData['image'],
                                      skills: ['Diagnostic Check', 'Repair Work'],
                                      about: 'Saved service provider.',
                                    );
                                    Navigator.pushNamed(
                                      context,
                                      '/worker_profile',
                                      arguments: tempWorker,
                                    );
                                  },
                                ),
                                if (index < savedWorkersList.length - 1) const Divider(),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuOption(IconData icon, String title, VoidCallback onTap) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: AppTheme.primaryBlue, size: 22),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textDark,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          onTap: onTap,
        ),
        const Divider(height: 1, indent: 56, endIndent: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = BookingState();
    final userMap = bookingState.getCurrentUserProfile();
    final String name = userMap?['name'] ?? 'Jitendra Singh';
    final String email = userMap?['email'] ?? 'jitendra123@gmail.com';
    final String phone = userMap?['phone'] ?? '+91 98765-43210';
    final String image = userMap?['image'] ?? 'assets/images/worker_mahesh.png';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: AppTheme.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Deep Blue Profile Header Card
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryBlue.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundImage: AssetImage(image.isNotEmpty ? image : 'assets/images/worker_mahesh.png'),
                      backgroundColor: Colors.white24,
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            email,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            phone,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Profile Options list
            Expanded(
              child: ListView(
                children: [
                  _buildMenuOption(Icons.edit_outlined, 'Edit Profile', () {
                    Navigator.pushNamed(context, '/settings/security');
                  }),
                  _buildMenuOption(Icons.assignment_outlined, 'My Bookings', () {
                    Navigator.pushReplacementNamed(context, '/my_leads');
                  }),
                  _buildMenuOption(Icons.bookmark_border_outlined, 'Saved Workers', () {
                    _showSavedWorkersSheet(context);
                  }),
                  _buildMenuOption(Icons.notifications_none_outlined, 'Notifications', () {
                    Navigator.pushNamed(context, '/settings/notifications');
                  }),
                  _buildMenuOption(Icons.support_agent_outlined, 'Support', () {
                    Navigator.pushNamed(context, '/settings/support');
                  }),
                  _buildMenuOption(Icons.settings_outlined, 'Settings', () {
                    Navigator.pushNamed(context, '/settings');
                  }),
                  _buildMenuOption(Icons.logout, 'Logout', () {
                    Navigator.pushReplacementNamed(context, '/login');
                  }),
                ],
              ),
            ),
          ],
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
          if (index == 0) Navigator.pushNamed(context, '/user_home');
          if (index == 1) Navigator.pushNamed(context, '/service_listing');
          if (index == 2) Navigator.pushNamed(context, '/book_service');
          if (index == 3) Navigator.pushNamed(context, '/my_leads');
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
