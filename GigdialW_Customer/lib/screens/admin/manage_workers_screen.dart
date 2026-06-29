import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ManageWorkersScreen extends StatefulWidget {
  const ManageWorkersScreen({super.key});

  @override
  State<ManageWorkersScreen> createState() => _ManageWorkersScreenState();
}

class _ManageWorkersScreenState extends State<ManageWorkersScreen> {
  String _activeMenu = 'Workers';

  final List<Map<String, dynamic>> _workers = [
    {
      'name': 'Ramesh Yadav',
      'profession': 'Electrician',
      'status': 'Approved',
      'color': Colors.green,
    },
    {
      'name': 'Mahesh Patel',
      'profession': 'Plumber',
      'status': 'Pending',
      'color': Colors.orange,
    },
    {
      'name': 'Sanjay Sharma',
      'profession': 'Carpenter',
      'status': 'Approved',
      'color': Colors.green,
    },
    {
      'name': 'Jitendra Singh',
      'profession': 'Painter',
      'status': 'Rejected',
      'color': Colors.red,
    },
  ];

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
          });
          if (title == 'Dashboard') {
            Navigator.pushNamed(context, '/admin_dashboard');
          }
          if (title == 'Logout') {
            Navigator.pushReplacementNamed(context, '/login');
          }
        },
      ),
    );
  }

  Widget _buildStatusPill(String status, Color color) {
    Color bg = color.withOpacity(0.1);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isWideScreen = MediaQuery.of(context).size.width > 700;

    // Sidebar view
    Widget sidebar = Container(
      width: 220,
      color: AppTheme.primaryBlue,
      child: Column(
        children: [
          const SizedBox(height: 24),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.handyman, color: Colors.white, size: 24),
              SizedBox(width: 8),
              Text(
                'GigDial Admin',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
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
                _buildSidebarItem('Logout', Icons.logout),
              ],
            ),
          ),
        ],
      ),
    );

    // Main manage contents
    Widget mainContent = Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Manage Workers', style: AppTheme.titleLarge.copyWith(fontSize: 24)),
              // Search Worker Box
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, size: 16, color: Colors.grey),
                    hintText: 'Search Worker',
                    hintStyle: const TextStyle(fontSize: 12),
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
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Workers Records List/Table
          Expanded(
            child: Container(
              decoration: AppTheme.cardDecoration(showBorder: true),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columnSpacing: 20,
                    headingRowColor: MaterialStateProperty.all(Colors.grey[50]),
                    columns: const [
                      DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark))),
                      DataColumn(label: Text('Profession', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark))),
                      DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark))),
                      DataColumn(label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark))),
                    ],
                    rows: _workers
                        .map((worker) => DataRow(
                              cells: [
                                DataCell(
                                  Row(
                                    children: [
                                      const CircleAvatar(
                                        radius: 12,
                                        backgroundImage: AssetImage('assets/images/worker_ramesh.png'),
                                        backgroundColor: Colors.grey,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(worker['name']!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                    ],
                                  ),
                                ),
                                DataCell(Text(worker['profession']!, style: const TextStyle(fontSize: 13))),
                                DataCell(_buildStatusPill(worker['status']!, worker['color']!)),
                                DataCell(
                                  TextButton(
                                    onPressed: () {
                                      // Demo action goes to worker profile
                                      Navigator.pushNamed(context, '/worker_profile');
                                    },
                                    child: const Text(
                                      'View',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.primaryBlue),
                                    ),
                                  ),
                                ),
                              ],
                            ))
                        .toList(),
                  ),
                ),
              ),
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
              title: const Text('Manage Workers'),
            ),
      drawer: isWideScreen ? null : Drawer(child: sidebar),
      body: SafeArea(
        child: Row(
          children: [
            if (isWideScreen) sidebar,
            Expanded(child: mainContent),
          ],
        ),
      ),
    );
  }
}
