import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../theme/app_theme.dart';
import '../../data/booking_state.dart';

class MyLeadsScreen extends StatefulWidget {
  final bool isTab;
  const MyLeadsScreen({super.key, this.isTab = false});

  @override
  State<MyLeadsScreen> createState() => _MyLeadsScreenState();
}

class _MyLeadsScreenState extends State<MyLeadsScreen> {
  int _currentTabIndex = 3; // Leads/Bookings matches tab index 3
  String _activeTab = 'All';
  late final BookingState _bookingState;

  @override
  void initState() {
    super.initState();
    _bookingState = BookingState();
    _bookingState.addListener(_onStateChange);
  }

  void _onStateChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _bookingState.removeListener(_onStateChange);
    super.dispose();
  }

  final List<String> _tabs = ['All', 'Pending', 'Contacted', 'Completed'];

  String _formatNotificationTime(dynamic timestamp) {
    if (timestamp == null) return '';
    int ts = 0;
    if (timestamp is int) {
      ts = timestamp;
    } else if (timestamp is String) {
      ts = int.tryParse(timestamp) ?? 0;
    }
    if (ts == 0) return '';
    final dt = DateTime.fromMillisecondsSinceEpoch(ts);
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} mins ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} hours ago';
    } else {
      return '${diff.inDays} days ago';
    }
  }

  void _showNotificationsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateSheet) {
            final notifications = _bookingState.notifications;
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
                        'Notifications',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark,
                        ),
                      ),
                      Row(
                        children: [
                          if (notifications.any((n) => n['read'] == false))
                            TextButton(
                              onPressed: () async {
                                await _bookingState.markAllNotificationsAsRead();
                                setStateSheet(() {});
                              },
                              child: const Text('Mark all read', style: TextStyle(color: AppTheme.primaryBlue, fontSize: 13)),
                            ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Close', style: TextStyle(color: AppTheme.primaryBlue)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Flexible(
                    child: notifications.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 24.0),
                              child: Text(
                                'No notifications yet',
                                style: TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                            ),
                          )
                        : Scrollbar(
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: notifications.length,
                              separatorBuilder: (context, index) => const Divider(),
                              itemBuilder: (context, index) {
                                final n = notifications[index];
                                final isUnread = n['read'] == false;
                                
                                IconData icon = Icons.info_outline;
                                Color color = Colors.blue;
                                if (n['title'] == 'Booking Accepted' || n['title'] == 'New Lead Alert') {
                                  icon = Icons.check_circle_outline;
                                  color = Colors.green;
                                } else if (n['title'] == 'New Message') {
                                  icon = Icons.chat_bubble_outline;
                                  color = Colors.teal;
                                } else if (n['title'] == 'Service Completed') {
                                  icon = Icons.task_alt;
                                  color = Colors.blue;
                                } else if (n['title'] == 'Booking Update') {
                                  icon = Icons.update;
                                  color = Colors.indigo;
                                }

                                return InkWell(
                                  onTap: () async {
                                    if (isUnread) {
                                      await _bookingState.markNotificationAsRead(n['id'] ?? n['key']);
                                      setStateSheet(() {});
                                    }
                                  },
                                  child: Container(
                                    color: isUnread ? Colors.blue.withOpacity(0.03) : Colors.transparent,
                                    child: _buildNotificationItem(
                                      icon: icon,
                                      color: color,
                                      title: n['title'] ?? 'Notification',
                                      body: n['message'] ?? '',
                                      time: _formatNotificationTime(n['timestamp']),
                                      isUnread: isUnread,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required Color color,
    required String title,
    required String body,
    required String time,
    bool isUnread = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                                fontSize: 13,
                                color: AppTheme.textDark,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isUnread) ...[
                            const SizedBox(width: 6),
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: TextStyle(
                    color: isUnread ? Colors.black87 : Colors.grey[600],
                    fontSize: 12,
                    fontWeight: isUnread ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg;
    Color text;
    if (status == 'Pending') {
      bg = const Color(0xFFFEF3C7);
      text = const Color(0xFFD97706);
    } else if (status == 'Completed') {
      bg = const Color(0xFFDCFCE7);
      text = const Color(0xFF15803D);
    } else if (status == 'Cancelled') {
      bg = const Color(0xFFFEE2E2);
      text = const Color(0xFFEF4444);
    } else {
      // Accepted, On the Way, In Progress
      bg = const Color(0xFFDBEAFE);
      text = const Color(0xFF2563EB);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: text,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTabItem(String tabName) {
    bool isActive = _activeTab == tabName;
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeTab = tabName;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primaryBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          tabName,
          style: TextStyle(
            color: isActive ? Colors.white : AppTheme.primaryBlue,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  void _showRatingDialog(BuildContext context, BookingModel lead) {
    double selectedRating = 5;
    final reviewController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text('Rate ${lead.workerName}', style: const TextStyle(fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('How was your experience with this service?'),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final starVal = index + 1;
                      return IconButton(
                        icon: Icon(
                          starVal <= selectedRating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 32,
                        ),
                        onPressed: () {
                          setStateDialog(() {
                            selectedRating = starVal.toDouble();
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: reviewController,
                    decoration: InputDecoration(
                      hintText: 'Write a review...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final bookingState = BookingState();
                    final worker = bookingState.allWorkersList.firstWhere(
                      (w) => w.name == lead.workerName,
                      orElse: () => WorkerModel(id: '', name: '', profession: '', experience: '', rating: 5.0, reviews: '', location: '', image: '', skills: [], about: '')
                    );
                    final customerId = FirebaseAuth.instance.currentUser?.uid ?? 'unknown_customer';

                    await bookingState.addRating(
                      lead.id.isNotEmpty ? lead.id : lead.title.replaceAll(' ', '_'),
                      worker.id.isNotEmpty ? worker.id : 'unknown_worker',
                      customerId,
                      selectedRating,
                      reviewController.text.trim(),
                    );

                    Navigator.pop(context);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Thank you for your rating!'), backgroundColor: Colors.green),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryBlue),
                  child: const Text('Submit', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showBookingDetailsSheet(BuildContext context, BookingModel lead) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Booking Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                  _buildStatusBadge(lead.status),
                ],
              ),
              const SizedBox(height: 20),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailItem('Work Type', lead.title),
                      _buildDetailItem('Service Category', lead.serviceName),
                      _buildDetailItem('Worker Assigned', lead.workerName),
                      _buildDetailItem('Date & Time', lead.dateTime),
                      _buildDetailItem('Service Location', lead.location),
                      _buildDetailItem('Total Amount', '₹${lead.price.toStringAsFixed(0)}'),
                      _buildDetailItem('Description', lead.description, isMultiLine: true),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  if (lead.status == 'Completed')
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _showRatingDialog(context, lead);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber[700],
                          minimumSize: const Size(double.infinity, 46),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.star, size: 16, color: Colors.white),
                        label: const Text('Rate Service', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                      ),
                    )
                  else if (lead.status == 'Cancelled')
                    Container()
                  else
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(
                            context,
                            '/chat_room',
                            arguments: {
                              'customerName': _bookingState.getCurrentUserName(),
                              'workerName': lead.workerName,
                              'isWorker': false,
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBlue,
                          minimumSize: const Size(double.infinity, 46),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.chat, size: 16, color: Colors.white),
                        label: const Text('Chat', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                      ),
                    ),
                  if (lead.status != 'Cancelled') const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey[700],
                        side: BorderSide(color: Colors.grey[300]!),
                        minimumSize: const Size(double.infinity, 46),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Close', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(String label, String value, {bool isMultiLine = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: isMultiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                color: AppTheme.textLight,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppTheme.textDark,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
              maxLines: isMultiLine ? 4 : 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allLeads = _bookingState.bookings;
    // Filter leads based on active tab
    final filteredLeads = _activeTab == 'All'
        ? allLeads
        : _activeTab == 'Contacted'
            ? allLeads.where((lead) => lead.status == 'Accepted' || lead.status == 'On the Way' || lead.status == 'In Progress').toList()
            : allLeads.where((lead) => lead.status == _activeTab).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: widget.isTab
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back, color: AppTheme.textDark),
                onPressed: () => Navigator.pop(context),
              ),
        title: const Text(
          'My Bookings', // Renamed title from My Leads
          style: TextStyle(
            color: AppTheme.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_outlined, color: AppTheme.textDark),
                onPressed: () {
                  _showNotificationsSheet(context);
                },
              ),
              if (_bookingState.notifications.any((n) => n['read'] == false && n['title'] != 'New Message'))
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
        child: Column(
          children: [
            // Custom Tabs Row matching mockup exactly
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: SizedBox(
                height: 38,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _tabs.length,
                  itemBuilder: (context, index) {
                    return _buildTabItem(_tabs[index]);
                  },
                ),
              ),
            ),
            
            const SizedBox(height: 12),

            // Leads List
            Expanded(
              child: filteredLeads.isEmpty
                  ? Center(
                      child: Text(
                        'No bookings in $_activeTab status',
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      ),
                    )
                  : Scrollbar(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredLeads.length,
                        itemBuilder: (context, index) {
                          final lead = filteredLeads[index];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFF1F5F9)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.01),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              lead.title,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: AppTheme.textDark,
                                              ),
                                            ),
                                            Text(
                                              '₹${lead.price.toStringAsFixed(0)}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: AppTheme.primaryBlue,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          lead.location,
                                          style: const TextStyle(
                                            color: AppTheme.textLight,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          lead.dateTime,
                                          style: const TextStyle(
                                            color: AppTheme.textLight,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        _buildStatusBadge(lead.status),
                                      ],
                                    ),
                                  ),
                                  // View Details Button (Opens Bottom Sheet showing details)
                                  ElevatedButton(
                                    onPressed: () {
                                      _showBookingDetailsSheet(context, lead);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: AppTheme.primaryBlue,
                                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                      minimumSize: Size.zero,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      'View',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
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
