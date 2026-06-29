import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../theme/app_theme.dart';
import '../../data/app_config.dart';
import '../../data/booking_state.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  String _activeMenu = 'Dashboard';

  // Dynamic lists pointing to BookingState / Realtime Database
  List<Map<String, dynamic>> get _users {
    final list = BookingState().usersList;
    if (list.isEmpty) {
      return [
        {'uid': 'u1', 'name': 'Anita Sharma', 'phone': '9876543210', 'city': 'Mumbai', 'status': 'Active', 'color': Colors.green},
        {'uid': 'u2', 'name': 'Amit Patel', 'phone': '8765432109', 'city': 'Ahmedabad', 'status': 'Active', 'color': Colors.green},
        {'uid': 'u3', 'name': 'Sneha Rao', 'phone': '7654321098', 'city': 'Bangalore', 'status': 'Suspended', 'color': Colors.orange},
        {'uid': 'u4', 'name': 'Rajesh Kumar', 'phone': '6543210987', 'city': 'Delhi', 'status': 'Active', 'color': Colors.green},
      ];
    }
    return list.map((user) {
      final status = user['status'] ?? 'Active';
      final color = status == 'Active' ? Colors.green : Colors.orange;
      return {
        'uid': user['uid'],
        'name': user['name'] ?? 'User',
        'phone': user['phone'] ?? '',
        'city': user['city'] ?? '',
        'status': status,
        'color': color,
      };
    }).toList();
  }

  List<Map<String, dynamic>> get _workers {
    final list = BookingState().allWorkersList;
    if (list.isEmpty) {
      return [
        {'uid': 'worker_ramesh', 'name': 'Ramesh Yadav', 'profession': 'Electrician', 'status': 'Approved', 'color': Colors.green},
        {'uid': 'worker_mahesh', 'name': 'Mahesh Patel', 'profession': 'Plumber', 'status': 'Pending', 'color': Colors.orange},
        {'uid': 'worker_sanjay', 'name': 'Sanjay Sharma', 'profession': 'Carpenter', 'status': 'Approved', 'color': Colors.green},
        {'uid': 'worker_jitendra', 'name': 'Jitendra Singh', 'profession': 'Painter', 'status': 'Rejected', 'color': Colors.red},
      ];
    }
    return list.map((w) {
      final status = w.email != null && w.email!.isNotEmpty ? 'Approved' : 'Pending';
      final color = status == 'Approved' ? Colors.green : Colors.orange;
      return {
        'uid': w.id,
        'name': w.name,
        'profession': w.profession,
        'status': status,
        'color': color,
        'model': w,
      };
    }).toList();
  }

  List<Map<String, dynamic>> get _dynamicBookings {
    final list = <Map<String, dynamic>>[];
    for (var b in BookingState().bookings) {
      Color color;
      if (b.status == 'Pending') {
        color = Colors.orange;
      } else if (b.status == 'Accepted') {
        color = Colors.blue;
      } else if (b.status == 'On the Way') {
        color = Colors.teal;
      } else if (b.status == 'In Progress') {
        color = Colors.indigo;
      } else if (b.status == 'Completed') {
        color = Colors.green;
      } else {
        color = Colors.red;
      }

      list.add({
        'id': '#GB-${(b.title + b.workerName).hashCode.abs() % 1000}',
        'customer': b.customerName,
        'worker': b.workerName,
        'service': b.serviceName,
        'price': '₹${b.price.toStringAsFixed(0)}',
        'status': b.status,
        'color': color,
        'model': b,
      });
    }
    return list;
  }

  final List<Map<String, dynamic>> _subscriptions = [
    {'worker': 'Sanjay Sharma', 'plan': 'Gold (Quarterly)', 'amount': '₹599', 'method': 'UPI', 'status': 'Approved', 'color': Colors.green},
    {'worker': 'Mahesh Patel', 'plan': 'Silver (Monthly)', 'amount': '₹199', 'method': 'UPI', 'status': 'Pending Approval', 'color': Colors.orange},
    {'worker': 'Ramesh Yadav', 'plan': 'Platinum (Yearly)', 'amount': '₹1,999', 'method': 'Net Banking', 'status': 'Approved', 'color': Colors.green},
  ];

  // System Settings state variables
  double _commissionRate = 12.0;
  bool _maintenanceMode = false;
  bool _allowRegistrations = true;

  // Controllers
  final _searchController = TextEditingController();
  final _commissionController = TextEditingController(text: '12.0');

  // Scroll Controllers for Table Scrollbars
  final ScrollController _usersVerticalController = ScrollController();
  final ScrollController _usersHorizontalController = ScrollController();
  final ScrollController _workersVerticalController = ScrollController();
  final ScrollController _workersHorizontalController = ScrollController();
  final ScrollController _bookingsVerticalController = ScrollController();
  final ScrollController _bookingsHorizontalController = ScrollController();
  final ScrollController _subscriptionsVerticalController = ScrollController();
  final ScrollController _subscriptionsHorizontalController = ScrollController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    BookingState().addListener(_rebuild);
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  void _onSearchChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    BookingState().removeListener(_rebuild);
    _searchController.dispose();
    _commissionController.dispose();
    _usersVerticalController.dispose();
    _usersHorizontalController.dispose();
    _workersVerticalController.dispose();
    _workersHorizontalController.dispose();
    _bookingsVerticalController.dispose();
    _bookingsHorizontalController.dispose();
    _subscriptionsVerticalController.dispose();
    _subscriptionsHorizontalController.dispose();
    super.dispose();
  }

  // Sidebar navigation builder helper
  Widget _buildSidebarItem(String title, IconData icon) {
    bool isActive = _activeMenu == title;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? Colors.white.withOpacity(0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white, size: 20),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
        dense: true,
        onTap: () {
          setState(() {
            _activeMenu = title;
            _searchController.clear(); // Clear search query when changing tabs
          });
          // Close drawer on small screen when clicked
          if (MediaQuery.of(context).size.width <= 700) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  Widget _buildStatusPill(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  // View Layout Decider based on Sidebar Menu Selection
  Widget _buildMainContent() {
    switch (_activeMenu) {
      case 'Dashboard':
        return _buildDashboardView();
      case 'Users':
        return _buildUsersView();
      case 'Workers':
        return _buildWorkersView();
      case 'Bookings':
        return _buildBookingsView();
      case 'Subscriptions':
        return _buildSubscriptionsView();
      case 'Reports':
        return _buildReportsView();
      case 'Settings':
        return _buildSettingsView();
      default:
        return _buildDashboardView();
    }
  }

  // --- 1. DASHBOARD VIEW ---
  Widget _buildDashboardView() {
    bool isWideScreen = MediaQuery.of(context).size.width > 700;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Dashboard Overview', style: AppTheme.titleLarge.copyWith(fontSize: 24)),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isWideScreen ? 4 : 1,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: isWideScreen ? 1.6 : 3.2,
            children: [
              _buildMetricCard('Total Users', '${_users.length}', Icons.people_outline, Colors.blue),
              _buildMetricCard('Total Workers', '${_workers.length}', Icons.engineering_outlined, Colors.teal),
              _buildMetricCard('Total Bookings', '${BookingState().bookings.length}', Icons.assignment_outlined, Colors.orange),
              _buildMetricCard('Total Revenue', '₹${BookingState().bookings.length * 800}', Icons.currency_rupee, Colors.green),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: AppTheme.cardDecoration(showBorder: true),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Booking Trends (Weekly)', style: AppTheme.titleMedium),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 180,
                        width: double.infinity,
                        child: CustomPaint(painter: LineChartPainter()),
                      ),
                    ],
                  ),
                ),
              ),
              if (isWideScreen) const SizedBox(width: 16),
              if (isWideScreen)
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: AppTheme.cardDecoration(showBorder: true),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Bookings Status Breakdown', style: AppTheme.titleMedium),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            SizedBox(
                              width: 110,
                              height: 110,
                              child: CustomPaint(painter: PieChartPainter()),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LegendItem(color: Colors.green, label: 'Completed (65%)'),
                                SizedBox(height: 8),
                                LegendItem(color: Colors.blue, label: 'Accepted (25%)'),
                                SizedBox(height: 8),
                                LegendItem(color: Colors.orange, label: 'Pending (10%)'),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: AppTheme.cardDecoration(showBorder: true),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 11, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader({required String title, required Widget trailing}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 550) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTheme.titleLarge.copyWith(fontSize: 20),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 16),
              trailing,
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.titleLarge.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 12),
              trailing,
            ],
          );
        }
      },
    );
  }

  // --- 2. USERS VIEW ---
  Widget _buildUsersView() {
    final query = _searchController.text.toLowerCase().trim();
    final filteredUsers = _users.where((user) {
      return user['name'].toString().toLowerCase().contains(query) ||
             user['phone'].toString().toLowerCase().contains(query) ||
             user['city'].toString().toLowerCase().contains(query) ||
             user['status'].toString().toLowerCase().contains(query);
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(
            title: 'Manage Users',
            trailing: _buildSearchBox('Search User'),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: AppTheme.cardDecoration(showBorder: true),
              child: Scrollbar(
                controller: _usersVerticalController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _usersVerticalController,
                  scrollDirection: Axis.vertical,
                  child: Scrollbar(
                    controller: _usersHorizontalController,
                    thumbVisibility: true,
                    notificationPredicate: (notif) => notif.depth == 1,
                    child: SingleChildScrollView(
                      controller: _usersHorizontalController,
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Phone', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('City', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                        rows: filteredUsers.map((user) {
                          return DataRow(cells: [
                            DataCell(Text(user['name']!, style: const TextStyle(fontWeight: FontWeight.w600))),
                            DataCell(Text(user['phone']!)),
                            DataCell(Text(user['city']!)),
                            DataCell(_buildStatusPill(user['status']!, user['color']!)),
                            DataCell(Row(
                              children: [
                                TextButton(
                                  onPressed: () async {
                                    final currentStatus = user['status'] ?? 'Active';
                                    final newStatus = currentStatus == 'Active' ? 'Suspended' : 'Active';
                                    if (user['uid'] != null && !user['uid'].startsWith('u')) {
                                      await FirebaseDatabase.instance.ref('users/${user['uid']}/status').set(newStatus);
                                    } else {
                                      // If mock user, mock locally
                                      setState(() {
                                        user['status'] = newStatus;
                                      });
                                    }
                                  },
                                  child: Text(
                                    user['status'] == 'Active' ? 'Suspend' : 'Activate',
                                    style: TextStyle(color: user['status'] == 'Active' ? Colors.orange : Colors.green),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
                                  onPressed: () async {
                                    if (user['uid'] != null && !user['uid'].startsWith('u')) {
                                      await BookingState().deleteUser(user['uid']);
                                    }
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('User ${user['name']} deleted')),
                                    );
                                  },
                                ),
                              ],
                            )),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 3. WORKERS VIEW ---
  Widget _buildWorkersView() {
    final query = _searchController.text.toLowerCase().trim();
    final filteredWorkers = _workers.where((worker) {
      return worker['name'].toString().toLowerCase().contains(query) ||
             worker['profession'].toString().toLowerCase().contains(query) ||
             worker['status'].toString().toLowerCase().contains(query);
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(
            title: 'Manage Workers',
            trailing: _buildSearchBox('Search Worker'),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: AppTheme.cardDecoration(showBorder: true),
              child: Scrollbar(
                controller: _workersVerticalController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _workersVerticalController,
                  scrollDirection: Axis.vertical,
                  child: Scrollbar(
                    controller: _workersHorizontalController,
                    thumbVisibility: true,
                    notificationPredicate: (notif) => notif.depth == 1,
                    child: SingleChildScrollView(
                      controller: _workersHorizontalController,
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Profession', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                        rows: filteredWorkers.map((worker) {
                          return DataRow(cells: [
                            DataCell(Text(worker['name']!, style: const TextStyle(fontWeight: FontWeight.w600))),
                            DataCell(Text(worker['profession']!)),
                            DataCell(_buildStatusPill(worker['status']!, worker['color']!)),
                            DataCell(Row(
                              children: [
                                if (worker['status'] == 'Pending') ...[
                                  TextButton(
                                    onPressed: () async {
                                      if (worker['uid'] != null && !worker['uid'].toString().startsWith('worker_')) {
                                        await FirebaseDatabase.instance.ref('workers/${worker['uid']}/email').set('approved@gigdial.com');
                                      } else {
                                        setState(() {
                                          worker['status'] = 'Approved';
                                          worker['color'] = Colors.green;
                                        });
                                      }
                                    },
                                    child: const Text('Approve', style: TextStyle(color: Colors.green)),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      if (worker['uid'] != null && !worker['uid'].toString().startsWith('worker_')) {
                                        await FirebaseDatabase.instance.ref('workers/${worker['uid']}/email').set('');
                                      } else {
                                        setState(() {
                                          worker['status'] = 'Rejected';
                                          worker['color'] = Colors.red;
                                        });
                                      }
                                    },
                                    child: const Text('Reject', style: TextStyle(color: Colors.red)),
                                  ),
                                ] else ...[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/worker_profile', arguments: worker['model']);
                                    },
                                    child: const Text('View Profile', style: TextStyle(color: AppTheme.primaryBlue)),
                                  ),
                                ],
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
                                  onPressed: () async {
                                    if (worker['uid'] != null && !worker['uid'].toString().startsWith('worker_')) {
                                      await BookingState().deleteWorker(worker['uid']);
                                    }
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Worker ${worker['name']} deleted')),
                                    );
                                  },
                                )
                              ],
                            )),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 4. BOOKINGS VIEW ---
  Widget _buildBookingsView() {
    final query = _searchController.text.toLowerCase().trim();
    final filteredBookings = _dynamicBookings.where((booking) {
      return booking['id'].toString().toLowerCase().contains(query) ||
             booking['customer'].toString().toLowerCase().contains(query) ||
             booking['worker'].toString().toLowerCase().contains(query) ||
             booking['service'].toString().toLowerCase().contains(query) ||
             booking['status'].toString().toLowerCase().contains(query);
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(
            title: 'Manage Bookings',
            trailing: _buildSearchBox('Search ID/Name'),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: AppTheme.cardDecoration(showBorder: true),
              child: Scrollbar(
                controller: _bookingsVerticalController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _bookingsVerticalController,
                  scrollDirection: Axis.vertical,
                  child: Scrollbar(
                    controller: _bookingsHorizontalController,
                    thumbVisibility: true,
                    notificationPredicate: (notif) => notif.depth == 1,
                    child: SingleChildScrollView(
                      controller: _bookingsHorizontalController,
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Customer', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Worker', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Service', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Price', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                        rows: filteredBookings.map((booking) {
                          final model = booking['model'] as BookingModel;
                          return DataRow(cells: [
                            DataCell(Text(booking['id']!, style: const TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text(booking['customer']!)),
                            DataCell(Text(booking['worker']!)),
                            DataCell(Text(booking['service']!)),
                            DataCell(Text(booking['price']!)),
                            DataCell(_buildStatusPill(booking['status']!, booking['color']!)),
                            DataCell(
                              booking['status'] == 'Accepted' || booking['status'] == 'Pending' || booking['status'] == 'On the Way' || booking['status'] == 'In Progress'
                                  ? Row(
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            BookingState().updateBookingStatus(model.id, 'Completed');
                                          },
                                          child: const Text('Complete', style: TextStyle(color: Colors.green)),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            BookingState().updateBookingStatus(model.id, 'Cancelled');
                                          },
                                          child: const Text('Cancel', style: TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    )
                                  : const Text('-'),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 5. SUBSCRIPTIONS VIEW ---
  Widget _buildSubscriptionsView() {
    final query = _searchController.text.toLowerCase().trim();
    final filteredSubs = _subscriptions.where((sub) {
      return sub['worker'].toString().toLowerCase().contains(query) ||
             sub['plan'].toString().toLowerCase().contains(query) ||
             sub['status'].toString().toLowerCase().contains(query);
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(
            title: 'Partner Subscription Payments',
            trailing: _buildSearchBox('Search Partner/Plan'),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: AppTheme.cardDecoration(showBorder: true),
              child: Scrollbar(
                controller: _subscriptionsVerticalController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _subscriptionsVerticalController,
                  scrollDirection: Axis.vertical,
                  child: Scrollbar(
                    controller: _subscriptionsHorizontalController,
                    thumbVisibility: true,
                    notificationPredicate: (notif) => notif.depth == 1,
                    child: SingleChildScrollView(
                      controller: _subscriptionsHorizontalController,
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Partner', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Plan', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Payment Method', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                        rows: filteredSubs.map((sub) {
                          return DataRow(cells: [
                            DataCell(Text(sub['worker']!, style: const TextStyle(fontWeight: FontWeight.w600))),
                            DataCell(Text(sub['plan']!)),
                            DataCell(Text(sub['amount']!)),
                            DataCell(Text(sub['method']!)),
                            DataCell(_buildStatusPill(sub['status']!, sub['color']!)),
                            DataCell(
                              sub['status'] == 'Pending Approval'
                                  ? ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          sub['status'] = 'Approved';
                                          sub['color'] = Colors.green;
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Payment Approved successfully!')),
                                        );
                                      },
                                      child: const Text('Approve', style: TextStyle(fontSize: 12)),
                                    )
                                  : const Text('-'),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 6. REPORTS VIEW ---
  Widget _buildReportsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('System Reports & Logs', style: AppTheme.titleLarge.copyWith(fontSize: 24)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: AppTheme.cardDecoration(showBorder: true),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Platform Activity Audit Log', style: AppTheme.titleMedium),
                const SizedBox(height: 16),
                _buildAuditLogItem('System', 'Daily automated worker payout processed successfully.', '10 mins ago', Colors.green),
                const Divider(),
                _buildAuditLogItem('New User Signup', 'Anita Sharma registered as Customer from Mumbai.', '1 hour ago', Colors.blue),
                const Divider(),
                _buildAuditLogItem('Payment API', 'UPI Subscription received from partner Mahesh Patel.', '2 hours ago', Colors.orange),
                const Divider(),
                _buildAuditLogItem('Settings', 'Admin configured system commission rate to 12.0%.', '1 day ago', Colors.purple),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuditLogItem(String module, String detail, String timestamp, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.circle, size: 8, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(module, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textDark)),
                    Text(timestamp, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(detail, style: TextStyle(color: Colors.grey[700], fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 7. SETTINGS VIEW ---
  Widget _buildSettingsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('System Parameters', style: AppTheme.titleLarge.copyWith(fontSize: 24)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: AppTheme.cardDecoration(showBorder: true),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Commission Parameters', style: AppTheme.titleMedium),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Platform Fee Rate (%): ', style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.textDark)),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 80,
                      height: 40,
                      child: TextField(
                        controller: _commissionController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text('Operational Modes', style: AppTheme.titleMedium),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Maintenance Mode', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  subtitle: const Text('Render platform offline for scheduled maintenance', style: TextStyle(fontSize: 12)),
                  value: _maintenanceMode,
                  activeColor: AppConfig.primaryColor,
                  onChanged: (val) {
                    setState(() {
                      _maintenanceMode = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text('Allow New Registrations', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  subtitle: const Text('Temporarily lock sign-up routes for new profiles', style: TextStyle(fontSize: 12)),
                  value: _allowRegistrations,
                  activeColor: AppConfig.primaryColor,
                  onChanged: (val) {
                    setState(() {
                      _allowRegistrations = val;
                    });
                  },
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConfig.primaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(180, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    setState(() {
                      _commissionRate = double.tryParse(_commissionController.text) ?? _commissionRate;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Configuration saved: Commission rate set to $_commissionRate%')),
                    );
                  },
                  child: const Text('Save Parameters'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox(String hint) {
    return SizedBox(
      width: 180,
      height: 36,
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, size: 14, color: Colors.grey),
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 11),
          fillColor: Colors.grey[50],
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Colors.grey[200]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Colors.grey[200]!),
          ),
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isWideScreen = MediaQuery.of(context).size.width > 700;

    // Unified Sidebar panel structure matching Admin style
    Widget sidebar = Container(
      width: 220,
      color: AppConfig.primaryColor,
      child: Column(
        children: [
          const SizedBox(height: 24),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.handyman, color: Colors.white, size: 24),
              SizedBox(width: 8),
              Text(
                'GigDial Control',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Expanded(
            child: ListView(
              children: [
                _buildSidebarItem('Dashboard', Icons.dashboard_outlined),
                _buildSidebarItem('Users', Icons.people_outline),
                _buildSidebarItem('Workers', Icons.engineering_outlined),
                _buildSidebarItem('Bookings', Icons.assignment_outlined),
                _buildSidebarItem('Subscriptions', Icons.card_membership),
                _buildSidebarItem('Reports', Icons.bar_chart),
                _buildSidebarItem('Settings', Icons.settings_outlined),
                const Divider(color: Colors.white24, height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: ListTile(
                    leading: const Icon(Icons.logout, color: Colors.white, size: 20),
                    title: const Text('Logout', style: TextStyle(color: Colors.white, fontSize: 13)),
                    dense: true,
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: isWideScreen
          ? null
          : AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(color: AppConfig.primaryColor),
              title: Text(
                _activeMenu,
                style: TextStyle(color: AppConfig.primaryColor, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
      drawer: isWideScreen ? null : Drawer(child: sidebar),
      body: SafeArea(
        child: Row(
          children: [
            if (isWideScreen) sidebar,
            Expanded(child: _buildMainContent()),
          ],
        ),
      ),
    );
  }
}

// Line chart painter
class LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF5E72E4)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final gridPaint = Paint()
      ..color = Colors.grey[100]!
      ..strokeWidth = 1;

    final dotPaint = Paint()
      ..color = const Color(0xFF2DCE89)
      ..style = PaintingStyle.fill;

    // Draw grid lines
    double stepY = size.height / 4;
    for (int i = 0; i <= 4; i++) {
      canvas.drawLine(Offset(0, i * stepY), Offset(size.width, i * stepY), gridPaint);
    }

    // Graph points
    final points = [
      Offset(0, size.height * 0.7),
      Offset(size.width * 0.2, size.height * 0.55),
      Offset(size.width * 0.4, size.height * 0.75),
      Offset(size.width * 0.6, size.height * 0.4),
      Offset(size.width * 0.8, size.height * 0.45),
      Offset(size.width, size.height * 0.2),
    ];

    // Connect line
    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, paint);

    // Draw dots
    for (var point in points) {
      canvas.drawCircle(point, 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Pie chart painter
class PieChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()..style = PaintingStyle.fill;

    // Completed 65% (Green)
    paint.color = Colors.green;
    canvas.drawArc(rect, -1.57, 4.08, true, paint);

    // Accepted 25% (Blue)
    paint.color = Colors.blue;
    canvas.drawArc(rect, 2.51, 1.57, true, paint);

    // Pending 10% (Orange)
    paint.color = Colors.orange;
    canvas.drawArc(rect, 4.08, 0.63, true, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const LegendItem({super.key, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textDark),
        ),
      ],
    );
  }
}
