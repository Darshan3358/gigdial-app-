import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/booking_state.dart';

class UserProfileScreen extends StatefulWidget {
  final bool isTab;
  const UserProfileScreen({super.key, this.isTab = false});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  int _currentTabIndex = 4; // Profile matches tab index 4
  late final BookingState _bookingState;

  @override
  void initState() {
    super.initState();
    _bookingState = BookingState();
    _bookingState.addListener(_rebuild);
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _bookingState.removeListener(_rebuild);
    super.dispose();
  }

  void _showSavedWorkersSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        final List<Map<String, dynamic>> savedWorkersList = BookingState().allWorkers.isNotEmpty
            ? BookingState().allWorkers.take(2).toList()
            : [
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
                                              'customerName': BookingState().currentUserProfile?['name'] ?? 'Jitendra Singh',
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

  void _showEditProfileDialog(BuildContext context) {
    final profile = BookingState().currentUserProfile;
    final nameController = TextEditingController(text: profile?['name'] ?? '');
    final phoneController = TextEditingController(text: profile?['phone'] ?? '');
    final emailController = TextEditingController(text: profile?['email'] ?? '');
    String selectedImage = profile?['image'] ?? 'assets/images/worker_mahesh.png';

    final List<String> avatarOptions = [
      'assets/images/worker_mahesh.png',
      'assets/images/worker_ramesh.png',
      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
      'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
      'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150',
      'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=150',
    ];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                'Edit Profile',
                style: TextStyle(
                  color: AppTheme.textDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Profile Picture:',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textLight,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 60,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: avatarOptions.length,
                        itemBuilder: (context, idx) {
                          final opt = avatarOptions[idx];
                          final isSelected = opt == selectedImage;
                          return GestureDetector(
                            onTap: () {
                              setStateDialog(() {
                                selectedImage = opt;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? AppTheme.primaryBlue : Colors.transparent,
                                  width: 3,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 24,
                                backgroundImage: opt.startsWith('http')
                                    ? NetworkImage(opt)
                                    : AssetImage(opt) as ImageProvider,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        labelStyle: TextStyle(color: AppTheme.textLight),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppTheme.primaryBlue),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        labelStyle: TextStyle(color: AppTheme.textLight),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppTheme.primaryBlue),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        labelStyle: TextStyle(color: AppTheme.textLight),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppTheme.primaryBlue),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: AppTheme.textLight),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    minimumSize: const Size(80, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    final name = nameController.text.trim();
                    final phone = phoneController.text.trim();
                    final email = emailController.text.trim();
                    if (name.isEmpty || phone.isEmpty || email.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill all fields')),
                      );
                      return;
                    }

                    // Show loading
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (ctx) => const Center(child: CircularProgressIndicator()),
                    );

                    final success = await BookingState().updateUserProfile(name, phone, email, image: selectedImage);

                    if (!context.mounted) return;

                    // Pop loading
                    Navigator.pop(context);

                    if (success) {
                      // Pop Edit dialog
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profile updated successfully!')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to update profile. Please try again.')),
                      );
                    }
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
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
    final profile = BookingState().currentUserProfile;
    final String name = profile?['name'] ?? 'Jitendra Singh';
    final String email = profile?['email'] ?? 'jitendra123@gmail.com';
    final String phone = profile?['phone'] ?? '+91 98765-43210';
    final String image = profile?['image'] ?? 'assets/images/worker_mahesh.png';

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
                      backgroundImage: (image.startsWith('http')
                          ? NetworkImage(image)
                          : AssetImage(image)) as ImageProvider,
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
                    _showEditProfileDialog(context);
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
                    BookingState().clearCurrentUser();
                    Navigator.pushReplacementNamed(context, '/login');
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: widget.isTab
          ? null
          : BottomNavigationBar(
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
