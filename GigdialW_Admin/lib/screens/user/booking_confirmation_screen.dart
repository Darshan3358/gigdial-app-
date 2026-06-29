import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/booking_state.dart';

class BookingConfirmationScreen extends StatelessWidget {
  const BookingConfirmationScreen({super.key});

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textLight,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.textDark,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final BookingModel? passedBooking = ModalRoute.of(context)?.settings.arguments as BookingModel?;
    final BookingModel booking = passedBooking ?? BookingModel(
      title: 'House Wiring Work',
      location: 'Naroda, Ahmedabad',
      dateTime: '25 May 2024 • 10:00 AM',
      status: 'Pending',
      workerName: 'Ramesh Yadav',
      serviceName: 'Electrician',
      description: 'I need to do new house wiring in 2BHK flat.',
    );

    final bookingState = BookingState();
    WorkerModel? matchedWorker;
    for (var list in bookingState.workersByCategory.values) {
      for (var w in list) {
        if (w.name == booking.workerName) {
          matchedWorker = w;
          break;
        }
      }
    }
    final WorkerModel worker = matchedWorker ?? WorkerModel(
      name: booking.workerName,
      profession: booking.serviceName,
      experience: '8 Years Experience',
      rating: 4.8,
      reviews: '120 Reviews',
      location: booking.location,
      image: 'assets/images/worker_ramesh.png',
      skills: [],
      about: '',
    );

    final dateTimeParts = booking.dateTime.split(' • ');
    final dateStr = dateTimeParts.isNotEmpty ? dateTimeParts[0] : '25 May 2024';
    final timeStr = dateTimeParts.length > 1 ? dateTimeParts[1] : '10:00 AM';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Booking Confirmation',
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
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    
                    // Mockup-matched Solid Green Circle with White Check
                    Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981), // Solid green accent
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    const Text(
                      'Booking Confirmed!',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      'Your request has been sent to ${worker.name}.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textLight,
                        height: 1.4,
                      ),
                    ),
                    
                    const SizedBox(height: 28),

                    // Worker Mini Card
                    Container(
                      padding: const EdgeInsets.all(12),
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
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage(worker.image),
                            backgroundColor: const Color(0xFFF1F5F9),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  worker.name,
                                  style: AppTheme.bodyBold.copyWith(
                                    fontSize: 15,
                                    color: AppTheme.textDark,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  worker.profession,
                                  style: const TextStyle(
                                    color: AppTheme.textLight,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: Color(0xFFFBBF24), size: 14),
                                    const SizedBox(width: 2),
                                    Text(
                                      '${worker.rating}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                        color: AppTheme.textDark,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '(${worker.reviews})',
                                      style: const TextStyle(
                                        color: AppTheme.textLight,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on, color: AppTheme.textLight, size: 12),
                                    const SizedBox(width: 2),
                                    Text(
                                      worker.location,
                                      style: const TextStyle(
                                        color: AppTheme.textLight,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),

                    // Flat Booking Details List Row (No enclosing box borders)
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Booking Details',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    _buildDetailRow('Service', booking.serviceName),
                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    _buildDetailRow('Work Type', booking.title),
                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    _buildDetailRow('Date', dateStr),
                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    _buildDetailRow('Time', timeStr),
                  ],
                ),
              ),
            ),

            // Bottom View Booking Pill Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/my_leads');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24), // pill-shaped
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'View Booking',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
