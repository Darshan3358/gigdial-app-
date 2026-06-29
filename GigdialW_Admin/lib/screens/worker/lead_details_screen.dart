import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/booking_state.dart';

class LeadDetailsScreen extends StatefulWidget {
  const LeadDetailsScreen({super.key});

  @override
  State<LeadDetailsScreen> createState() => _LeadDetailsScreenState();
}

class _LeadDetailsScreenState extends State<LeadDetailsScreen> {
  Widget _buildStatusBadge(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: const BorderRadius.all(Radius.circular(6)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[500], fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: AppTheme.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final BookingModel? passedLead = ModalRoute.of(context)?.settings.arguments as BookingModel?;
    final BookingModel lead = passedLead ?? BookingState().bookings.first;
    final BookingState bookingState = BookingState();
    final userMap = bookingState.usersList.firstWhere(
      (u) => u['name'] == lead.customerName,
      orElse: () => <String, dynamic>{
        'name': lead.customerName,
        'email': 'customer@gigdial.com',
        'phone': '+91 98765-43210',
      }
    );
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

    final bool isPending = lead.status == 'Pending';
    final Color statusColor = isPending
        ? Colors.orange
        : (lead.status == 'Contacted' ? Colors.blue : Colors.green);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isPending ? 'Pending Lead Request' : 'Active Job Details',
          style: const TextStyle(
            color: AppTheme.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status alert banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: statusColor.withOpacity(0.15)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isPending ? Icons.pending_actions : Icons.verified_user_outlined, 
                            color: statusColor, 
                            size: 24
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isPending ? 'Pending Acceptance' : (lead.status == 'Contacted' ? 'Job Accepted' : 'Job Completed'),
                                  style: TextStyle(fontWeight: FontWeight.bold, color: statusColor, fontSize: 14),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  isPending 
                                      ? 'Accept this lead to receive customer details and communicate.' 
                                      : 'You are registered for this job. Connect via chat or call below.',
                                  style: TextStyle(color: statusColor.withOpacity(0.8), fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Work Request Card
                    Container(
                      width: double.infinity,
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
                              Expanded(
                                child: Text(
                                  lead.title,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.textDark),
                                ),
                              ),
                              _buildStatusBadge(lead.status == 'Contacted' ? 'Accepted' : lead.status, statusColor),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.grey, size: 14),
                              const SizedBox(width: 4),
                              Text(lead.location, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, color: Colors.grey, size: 12),
                              const SizedBox(width: 4),
                              Text(lead.dateTime, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 1. Show Customer Profile (If Accepted/Contacted)
                    if (!isPending) ...[
                      const Text('Customer Profile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textDark)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 24,
                              backgroundImage: AssetImage('assets/images/worker_mahesh.png'), // Mock customer profile image
                              backgroundColor: Color(0xFFF1F5F9),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userMap['name'] ?? lead.customerName,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textDark),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    userMap['email'] ?? 'customer@gigdial.com',
                                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    userMap['phone'] ?? '+91 98765-43210',
                                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.call, color: Colors.teal, size: 20),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Calling ${userMap['name'] ?? lead.customerName}...')),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 2. Show Worker Details (Ramesh Yadav)
                      const Text('Assigned Professional Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textDark)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundImage: AssetImage(worker.image.isNotEmpty ? worker.image : 'assets/images/worker_ramesh.png'),
                              backgroundColor: const Color(0xFFF1F5F9),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${worker.name} (You)',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textDark),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${worker.profession} • ${worker.experience}',
                                    style: const TextStyle(color: AppTheme.textLight, fontSize: 12),
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      const Icon(Icons.star, color: Colors.amber, size: 12),
                                      const SizedBox(width: 4),
                                      Text('${worker.rating} (${worker.reviews})', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Work Details
                    const Text('Work Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textDark)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow('Service', lead.serviceName),
                          const Divider(height: 16),
                          _buildDetailRow('Work Type', lead.title),
                          const Divider(height: 16),
                          _buildDetailRow('Address', lead.location),
                          const Divider(height: 16),
                          _buildDetailRow('Description', lead.description),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // In-app Chat Section button (if Accepted)
                    if (!isPending) ...[
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/chat_room',
                            arguments: {
                              'customerName': lead.customerName,
                              'workerName': worker.name,
                              'isWorker': true,
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        icon: const Icon(Icons.chat, color: Colors.white),
                        label: const Text('Chat with Customer', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
            ),

            // Bottom Buttons
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: isPending
                  ? Row(
                      children: [
                        // Accept button
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                BookingState().updateBookingStatus(lead.id, 'Contacted');
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Lead Accepted successfully! customer profile is unlocked.'),
                                  backgroundColor: Colors.teal,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Accept Lead', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Reject button
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Reject Lead', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    )
                  : (lead.status == 'Contacted'
                      ? ElevatedButton(
                          onPressed: () {
                            setState(() {
                              BookingState().updateBookingStatus(lead.id, 'Completed');
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Job marked as Completed successfully!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Mark as Completed', style: TextStyle(fontWeight: FontWeight.bold)),
                        )
                      : Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle, color: Colors.green, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'JOB COMPLETED',
                                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ],
                          ),
                        )),
            ),
          ],
        ),
      ),
    );
  }
}
