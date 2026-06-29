import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/booking_state.dart';

class BookServiceScreen extends StatefulWidget {
  const BookServiceScreen({super.key});

  @override
  State<BookServiceScreen> createState() => _BookServiceScreenState();
}

class _BookServiceScreenState extends State<BookServiceScreen> {
  final _serviceController = TextEditingController();
  final _workTypeController = TextEditingController(text: 'House Wiring');
  final _dateController = TextEditingController(text: '25 May 2024');
  final _timeController = TextEditingController(text: '10:00 AM');
  final _addressController = TextEditingController();
  final _descController = TextEditingController(text: 'I need to do new house wiring in 2BHK flat.');

  bool _initialized = false;
  late WorkerModel _worker;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final passedWorker = ModalRoute.of(context)?.settings.arguments as WorkerModel?;
      _worker = passedWorker ?? WorkerModel(
        name: 'Ramesh Yadav',
        profession: 'Electrician',
        experience: '8 Years Experience',
        rating: 4.8,
        reviews: '120 Reviews',
        location: 'Naroda, Ahmedabad',
        image: 'assets/images/worker_ramesh.png',
        skills: ['House Wiring'],
        about: '',
      );
      _serviceController.text = _worker.profession;
      _addressController.text = _worker.location;
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _serviceController.dispose();
    _workTypeController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _addressController.dispose();
    _descController.dispose();
    super.dispose();
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryBlue,
              onPrimary: Colors.white,
              onSurface: AppTheme.textDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.day} ${_getMonthName(picked.month)} ${picked.year}";
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryBlue,
              onPrimary: Colors.white,
              onSurface: AppTheme.textDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  Widget _buildStepIndicator(int stepNumber, String title, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 13,
          backgroundColor: isActive ? AppTheme.primaryBlue : const Color(0xFFE2E8F0),
          child: Text(
            '$stepNumber',
            style: TextStyle(
              color: isActive ? Colors.white : const Color(0xFF64748B),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? AppTheme.primaryBlue : AppTheme.textLight,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    Widget? suffix,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
          const SizedBox(height: 2),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  maxLines: maxLines,
                  readOnly: readOnly,
                  onTap: onTap,
                  style: const TextStyle(
                    color: AppTheme.textDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 6),
                  ),
                ),
              ),
              if (suffix != null) suffix,
            ],
          ),
          const Divider(height: 12, color: Color(0xFFE2E8F0)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          'Book Service',
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
            // Mockup-matched Stepper Progress Indicator
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              child: Row(
                children: [
                  Expanded(child: _buildStepIndicator(1, 'Select Service', true)),
                  Container(
                    width: 40,
                    height: 1,
                    color: const Color(0xFFE2E8F0),
                    margin: const EdgeInsets.only(bottom: 18),
                  ),
                  Expanded(child: _buildStepIndicator(2, 'Select Worker', false)),
                  Container(
                    width: 40,
                    height: 1,
                    color: const Color(0xFFE2E8F0),
                    margin: const EdgeInsets.only(bottom: 18),
                  ),
                  Expanded(child: _buildStepIndicator(3, 'Confirm', false)),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Form Content with minimal Divider design
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFormField(
                      label: 'Service',
                      controller: _serviceController,
                    ),
                    _buildFormField(
                      label: 'Work Type',
                      controller: _workTypeController,
                    ),
                    
                    // Date & Time Side-by-Side
                    Row(
                      children: [
                        Expanded(
                          child: _buildFormField(
                            label: 'Date',
                            controller: _dateController,
                            readOnly: true,
                            onTap: () => _selectDate(context),
                            suffix: GestureDetector(
                              onTap: () => _selectDate(context),
                              child: const Icon(
                                Icons.calendar_today_outlined,
                                size: 16,
                                color: AppTheme.textDark,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: _buildFormField(
                            label: 'Time',
                            controller: _timeController,
                            readOnly: true,
                            onTap: () => _selectTime(context),
                            suffix: GestureDetector(
                              onTap: () => _selectTime(context),
                              child: const Icon(
                                Icons.access_time,
                                size: 16,
                                color: AppTheme.textDark,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    _buildFormField(
                      label: 'Address',
                      controller: _addressController,
                    ),
                    _buildFormField(
                      label: 'Description',
                      controller: _descController,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Bottom Continue Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(color: AppTheme.textLight, fontSize: 12),
                      ),
                      const Text(
                        '₹0',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final bookingState = BookingState();
                      final newBooking = BookingModel(
                        title: _workTypeController.text,
                        location: _addressController.text,
                        dateTime: '${_dateController.text} • ${_timeController.text}',
                        status: 'Pending',
                        workerName: _worker.name,
                        customerName: bookingState.getCurrentUserName(),
                        serviceName: _serviceController.text,
                        description: _descController.text,
                      );
                      bookingState.addBooking(newBooking);

                      Navigator.pushNamed(
                        context,
                        '/booking_confirmation',
                        arguments: newBooking,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 12),
                      minimumSize: Size.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24), // pill-shaped
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
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
