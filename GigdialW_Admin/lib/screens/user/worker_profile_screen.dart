import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/booking_state.dart';

class WorkerProfileScreen extends StatefulWidget {
  const WorkerProfileScreen({super.key});

  @override
  State<WorkerProfileScreen> createState() => _WorkerProfileScreenState();
}

class _WorkerProfileScreenState extends State<WorkerProfileScreen> {
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

  Widget _buildSkillChip(String skill) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9), // light grey/blue background
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        skill,
        style: const TextStyle(
          fontSize: 12,
          color: AppTheme.textDark,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildReviewBar(int star, double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        children: [
          Text(
            '$star',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 11,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.star, color: Color(0xFFFBBF24), size: 11),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: const Color(0xFFF1F5F9),
                color: const Color(0xFFF59E0B), // orange bar
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${(percentage * 100).toInt()}%',
            style: const TextStyle(
              color: AppTheme.textLight,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final WorkerModel? passedWorker = ModalRoute.of(context)?.settings.arguments as WorkerModel?;
    final WorkerModel initialWorker = passedWorker ?? WorkerModel(
      name: 'Ramesh Yadav',
      profession: 'Electrician',
      experience: '8 Years Experience',
      rating: 4.8,
      reviews: '120 Reviews',
      location: 'Naroda, Ahmedabad',
      image: 'assets/images/worker_ramesh.png',
      skills: ['House Wiring', 'Fan Repair', 'Light Installation', 'Switch Board', 'MCB Repair', 'Short Circuit'],
      about: 'I am a professional electrician with 8 years of experience in all type of electrical work. I specialize in home electrical wirings, repairing appliances, installing lighting fixtures, and troubleshooting electrical panels.',
    );

    final worker = _bookingState.allWorkersList.firstWhere(
      (w) => w.id == initialWorker.id,
      orElse: () => initialWorker,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppTheme.textDark),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppTheme.textDark),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Worker Summary Header Card
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 46,
                          backgroundImage: (worker.image.startsWith('http')
                              ? NetworkImage(worker.image)
                              : AssetImage(worker.image)) as ImageProvider,
                          backgroundColor: const Color(0xFFF1F5F9),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                worker.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textDark,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                worker.profession,
                                style: const TextStyle(
                                  color: AppTheme.textLight,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Color(0xFFFBBF24), size: 15),
                                  const SizedBox(width: 3),
                                  Text(
                                    '${worker.rating}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: AppTheme.textDark,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '(${worker.reviews})',
                                    style: const TextStyle(
                                      color: AppTheme.textLight,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                worker.experience,
                                style: const TextStyle(
                                  color: AppTheme.textDark,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),

                    // Location & Availability Badge Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: AppTheme.textDark, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              worker.location,
                              style: const TextStyle(
                                color: AppTheme.textLight,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECFDF5),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF10B981),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                'Available Now',
                                style: TextStyle(
                                  color: Color(0xFF047857),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const Divider(height: 36, color: Color(0xFFF1F5F9)),

                    // About Me
                    const Text(
                      'About Me',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      worker.about,
                      style: const TextStyle(
                        color: AppTheme.textLight,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                    
                    const SizedBox(height: 24),

                    // Skills Tags
                    const Text(
                      'Skills',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: worker.skills.map((skill) => _buildSkillChip(skill)).toList(),
                    ),
                    
                    const SizedBox(height: 24),

                    // Customer Reviews Section
                    const Text(
                      'Customer Reviews',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Average Score Card Left
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '${worker.rating}',
                              style: const TextStyle(
                                fontSize: 44,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textDark,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                5,
                                (index) => const Icon(
                                  Icons.star,
                                  color: Color(0xFFFBBF24),
                                  size: 15,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '(${worker.reviews})',
                              style: const TextStyle(
                                color: AppTheme.textLight,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 28),
                        
                        // Progress Bars Right
                        Expanded(
                          child: Column(
                            children: [
                              _buildReviewBar(5, 0.90),
                              _buildReviewBar(4, 0.08),
                              _buildReviewBar(3, 0.02),
                              _buildReviewBar(2, 0.00),
                              _buildReviewBar(1, 0.00),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Action Call & WhatsApp Panel
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
              child: Row(
                children: [
                  // Book Now Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/book_service', arguments: worker);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.calendar_today, size: 16),
                      label: const Text(
                        'Book Now',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Call Button
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.15)),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.phone, color: AppTheme.primaryBlue, size: 20),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Calling ${worker.name} (${worker.phone ?? "+91 99887-76655"})...'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),

                  // WhatsApp Button
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF22C55E).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF22C55E).withOpacity(0.15)),
                    ),
                    child: IconButton(
                      icon: Image.asset(
                        'assets/images/ic_whatsapp.png',
                        width: 22,
                        height: 22,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Opening WhatsApp with ${worker.name}...'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
