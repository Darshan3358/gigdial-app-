import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/booking_state.dart';
import '../chat/chat_list_screen.dart';

class WorkerDashboardScreen extends StatefulWidget {
  const WorkerDashboardScreen({super.key});

  @override
  State<WorkerDashboardScreen> createState() => _WorkerDashboardScreenState();
}

class _WorkerDashboardScreenState extends State<WorkerDashboardScreen> {
  int _currentTabIndex = 0;
  int _leadsFilterIndex = 0; // 0 for Pending, 1 for Active/Completed
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

  void _showNotificationsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
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
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close', style: TextStyle(color: Colors.teal)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Flexible(
                child: Scrollbar(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      _buildNotificationItem(
                        icon: Icons.assignment_outlined,
                        color: Colors.teal,
                        title: 'New Lead Alert',
                        body: 'Jitendra Singh requested AC Repair in Satellite, Ahmedabad.',
                        time: '5 mins ago',
                      ),
                      const Divider(),
                      _buildNotificationItem(
                        icon: Icons.star_outline,
                        color: Colors.amber,
                        title: 'New Review Received',
                        body: 'Amit Patel rated you 5 stars: \"Great work on fan repair!\"',
                        time: '2 hours ago',
                      ),
                      const Divider(),
                      _buildNotificationItem(
                        icon: Icons.warning_amber_outlined,
                        color: Colors.orange,
                        title: 'Subscription Expiry',
                        body: 'Your professional subscription plan will expire in 25 days. Renew now.',
                        time: '1 day ago',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textDark),
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
                  style: TextStyle(color: Colors.grey[700], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.teal.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textLight,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWideStatCard(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.teal.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textLight,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
        ],
      ),
    );
  }

  // TAB 0: DASHBOARD CONTENT
  Widget _buildDashboardTab(BookingState bookingState, List<BookingModel> recentLeads, int totalLeads) {
    final activePlan = bookingState.activePlan;
    final daysLeft = bookingState.subscriptionDaysLeft;
    final isSubscriptionActive = bookingState.isSubscriptionActive;

    return Scrollbar(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subscription Panel Card - TEAL GRADIENT
            GestureDetector(
              onTap: () {
                setState(() {
                  _currentTabIndex = 4; // Switch to Subscription tab
                });
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: isSubscriptionActive
                      ? const LinearGradient(
                          colors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : LinearGradient(
                          colors: [Colors.grey[400]!, Colors.grey[500]!],
                        ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isSubscriptionActive ? 'Subscription Active' : 'No Active Subscription',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isSubscriptionActive ? activePlan : 'Tap to Choose Plan',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    if (isSubscriptionActive)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '$daysLeft',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Days Left',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),

            // Stats Layout
            Row(
              children: [
                Expanded(
                  child: _buildTopStatCard("Today's Leads", "${recentLeads.length}"),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildTopStatCard("This Month", "${recentLeads.length + 15}"),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildTopStatCard("Profile Views", "125"),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            _buildWideStatCard("Total Leads", "$totalLeads"),
            
            const SizedBox(height: 24),

            // Recent Leads Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Leads',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentTabIndex = 1; // Switch to Leads Tab
                    });
                  },
                  child: const Text(
                    'See All',
                    style: TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Recent Leads List
            recentLeads.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.0),
                      child: Text(
                        'No pending leads right now',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ),
                  )
                : Column(
                    children: recentLeads.take(3).map((lead) {
                      return _buildLeadCard(lead);
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }

  // TAB 1: ALL LEADS LIST CONTENT
  Widget _buildLeadsTab(BookingState bookingState) {
    final pendingLeads = bookingState.bookings.where((b) => b.status == 'Pending').toList();
    final activeLeads = bookingState.bookings.where((b) => b.status != 'Pending').toList();

    final currentLeads = _leadsFilterIndex == 0 ? pendingLeads : activeLeads;

    return Column(
      children: [
        // Custom segmented tab toggle
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _leadsFilterIndex = 0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: _leadsFilterIndex == 0 ? Colors.teal : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Pending Leads (${pendingLeads.length})',
                      style: TextStyle(
                        color: _leadsFilterIndex == 0 ? Colors.white : AppTheme.textLight,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _leadsFilterIndex = 1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: _leadsFilterIndex == 1 ? Colors.teal : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Active / Completed (${activeLeads.length})',
                      style: TextStyle(
                        color: _leadsFilterIndex == 1 ? Colors.white : AppTheme.textLight,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: currentLeads.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.assignment_outlined, size: 64, color: Colors.grey[200]),
                      const SizedBox(height: 16),
                      Text(
                        _leadsFilterIndex == 0 ? 'No pending leads' : 'No active or completed leads',
                        style: TextStyle(color: Colors.grey[500], fontSize: 14),
                      ),
                    ],
                  ),
                )
              : Scrollbar(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: currentLeads.length,
                    itemBuilder: (context, index) {
                      return _buildLeadCard(currentLeads[index]);
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildLeadCard(BookingModel lead) {
    final statusColor = lead.status == 'Pending'
        ? Colors.orange
        : (lead.status == 'Contacted' ? Colors.blue : Colors.green);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/lead_details',
            arguments: lead,
          ).then((_) {
            // Refresh dashboard
            setState(() {});
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          lead.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: AppTheme.textDark,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            lead.status == 'Contacted' ? 'Accepted' : lead.status,
                            style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.grey, size: 13),
                        const SizedBox(width: 4),
                        Text(lead.location, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.grey, size: 11),
                        const SizedBox(width: 4),
                        Text(lead.dateTime, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.teal,
                  size: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // TAB 3: WORKER PROFILE CONTENT
  Widget _buildProfileTab(WorkerModel worker) {
    return Column(
      children: [
        // Worker details header card (TEAL GRADIENT)
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F766E), Color(0xFF115E59)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.teal.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundImage: AssetImage(worker.image.isNotEmpty ? worker.image : 'assets/images/worker_ramesh.png'),
                  backgroundColor: Colors.white24,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        worker.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        worker.email ?? 'ramesh.yadav@gmail.com',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        worker.phone ?? '+91 99887-76655',
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

        // Worker options
        Expanded(
          child: Scrollbar(
            child: ListView(
              children: [
                _buildProfileOption(Icons.assignment_outlined, 'My Leads (Orders)', () {
                  setState(() => _currentTabIndex = 1);
                }),
                _buildProfileOption(Icons.category_outlined, 'Manage Categories & Skills', () {
                  Navigator.pushNamed(context, '/manage_categories').then((_) => setState(() {}));
                }),
                _buildProfileOption(Icons.card_membership, 'Subscription Plans', () {
                  setState(() => _currentTabIndex = 4);
                }),
                _buildProfileOption(Icons.settings_outlined, 'Settings', () {
                  Navigator.pushNamed(context, '/settings');
                }),
                _buildProfileOption(Icons.logout, 'Logout', () {
                  Navigator.pushReplacementNamed(context, '/login');
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.teal, size: 22),
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

  // TAB 4: SUBSCRIPTION CONTENT
  Widget _buildSubscriptionTab() {
    return Scrollbar(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Subscription Overview',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textDark),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Current Plan', style: TextStyle(color: AppTheme.textLight, fontSize: 13)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.teal.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('ACTIVE', style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 10)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Professional Plan',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppTheme.textDark),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Price', style: TextStyle(color: AppTheme.textLight, fontSize: 13)),
                      Text('₹299 / Month', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textDark)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Remaining Days', style: TextStyle(color: AppTheme.textLight, fontSize: 13)),
                      Text('25 Days', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textDark)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Upgrade Plan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textDark),
            ),
            const SizedBox(height: 12),
            _buildUpgradeCard('Premium Plan', '₹599 / Month', ['Unlimited Leads', 'Top Ranking', 'Priority Support', 'Featured Profile']),
            _buildUpgradeCard('Elite Plan', '₹999 / Month', ['Unlimited Leads', 'Featured Profile', 'Dedicated Business Account', 'Priority Support']),
          ],
        ),
      ),
    );
  }

  Widget _buildUpgradeCard(String name, String price, List<String> perks) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.teal)),
              Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textDark)),
            ],
          ),
          const SizedBox(height: 10),
          ...perks.map((p) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline, color: Colors.teal, size: 14),
                    const SizedBox(width: 8),
                    Text(p, style: const TextStyle(fontSize: 12, color: AppTheme.textLight)),
                  ],
                ),
              )),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Upgrading to $name...')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              minimumSize: const Size(double.infinity, 40),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Upgrade Now', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = _bookingState;
    final recentLeads = bookingState.bookings.where((b) => b.status == 'Pending').toList();
    final totalLeads = bookingState.bookings.length;
    final worker = bookingState.getCurrentWorkerProfile() ?? WorkerModel(
      name: 'Ramesh Yadav',
      profession: 'Electrician',
      experience: '8 Years Experience',
      rating: 4.8,
      reviews: '120 Reviews',
      location: 'Naroda, Ahmedabad',
      image: 'assets/images/worker_ramesh.png',
      skills: [],
      about: '',
      email: 'ramesh.yadav@gmail.com',
      phone: '+91 99887-76655',
    );

    Widget bodyWidget;
    String appBarTitle;
    switch (_currentTabIndex) {
      case 0:
        bodyWidget = _buildDashboardTab(bookingState, recentLeads, totalLeads);
        appBarTitle = 'Welcome, ${worker.name}';
        break;
      case 1:
        bodyWidget = _buildLeadsTab(bookingState);
        appBarTitle = 'Leads & Orders';
        break;
      case 2:
        bodyWidget = const ChatListScreen(isWorker: true);
        appBarTitle = 'Messages';
        break;
      case 3:
        bodyWidget = _buildProfileTab(worker);
        appBarTitle = 'Worker Profile';
        break;
      case 4:
        bodyWidget = _buildSubscriptionTab();
        appBarTitle = 'My Subscription';
        break;
      default:
        bodyWidget = _buildDashboardTab(bookingState, recentLeads, totalLeads);
        appBarTitle = 'Worker Dashboard';
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _currentTabIndex == 2 
          ? null // Let ChatListScreen render its own Appbar
          : AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              automaticallyImplyLeading: false,
              titleSpacing: 16,
              title: Text(
                appBarTitle,
                style: const TextStyle(
                  color: AppTheme.textDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              actions: [
                if (_currentTabIndex == 0) ...[
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_none_outlined, color: AppTheme.textDark),
                        onPressed: () {
                          _showNotificationsSheet(context);
                        },
                      ),
                      if (bookingState.notifications.any((n) => n['read'] == false && n['title'] != 'New Message'))
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
                ]
              ],
            ),
      body: SafeArea(child: bodyWidget),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey[400],
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        onTap: (index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home, color: Colors.teal),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment, color: Colors.teal),
            label: 'Leads',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble, color: Colors.teal),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person, color: Colors.teal),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_membership_outlined),
            activeIcon: Icon(Icons.card_membership, color: Colors.teal),
            label: 'Subscription',
          ),
        ],
      ),
    );
  }
}
