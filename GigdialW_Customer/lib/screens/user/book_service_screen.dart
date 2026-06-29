import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/booking_state.dart';

class BookServiceScreen extends StatefulWidget {
  final bool isTab;
  const BookServiceScreen({super.key, this.isTab = false});

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
  late WorkerModel _selectedWorker;
  int _currentStep = 1;

  double get _basePrice {
    final service = _serviceController.text.trim().toLowerCase();
    if (service.contains('electrician')) return 299.0;
    if (service.contains('plumber')) return 249.0;
    if (service.contains('carpenter')) return 349.0;
    if (service.contains('painter')) return 599.0;
    if (service.contains('ac')) return 499.0;
    if (service.contains('clean')) return 399.0;
    return 299.0;
  }
  
  double get _serviceFee => 49.0;
  double get _totalPrice => _basePrice + _serviceFee;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final passedWorker = ModalRoute.of(context)?.settings.arguments as WorkerModel?;
      _selectedWorker = passedWorker ?? WorkerModel(
        id: 'worker_ramesh',
        name: 'Ramesh Yadav',
        profession: 'Electrician',
        experience: '8 Years Experience',
        rating: 4.8,
        reviews: '120 Reviews',
        location: 'Naroda, Ahmedabad',
        image: 'assets/images/worker_ramesh.png',
        skills: ['House Wiring'],
        about: 'Professional Electrician',
      );
      _serviceController.text = _selectedWorker.profession;
      _addressController.text = _selectedWorker.location;
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

  Widget _buildStepIndicator(int stepNumber, String title, bool isCompleted, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: isCompleted
              ? const Color(0xFF10B981) // Completed green
              : (isActive ? AppTheme.primaryBlue : const Color(0xFFE2E8F0)),
          child: isCompleted
              ? const Icon(Icons.check, color: Colors.white, size: 14)
              : Text(
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
            fontWeight: isActive || isCompleted ? FontWeight.bold : FontWeight.normal,
            color: isCompleted
                ? const Color(0xFF10B981)
                : (isActive ? AppTheme.primaryBlue : AppTheme.textLight),
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

  // Step 1: Input details form
  Widget _buildStepDetailsForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormField(
            label: 'Service Category',
            controller: _serviceController,
          ),
          _buildFormField(
            label: 'Work Title',
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
            label: 'Service Address',
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
    );
  }

  // Step 2: Worker selection list
  Widget _buildStepWorkerSelection() {
    final List<WorkerModel> availableWorkers = BookingState().getWorkersForService(_serviceController.text);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Text(
            'Select Available Professional',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
        ),
        Expanded(
          child: availableWorkers.isEmpty
              ? const Center(child: Text('No professionals available in this category.'))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  itemCount: availableWorkers.length,
                  itemBuilder: (context, index) {
                    final worker = availableWorkers[index];
                    final isSelected = _selectedWorker.name == worker.name;
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedWorker = worker;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? AppTheme.primaryBlue : const Color(0xFFE2E8F0),
                            width: isSelected ? 2.0 : 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundImage: AssetImage(worker.image),
                              backgroundColor: const Color(0xFFF1F5F9),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    worker.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: AppTheme.textDark,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    worker.experience,
                                    style: const TextStyle(
                                      color: AppTheme.textLight,
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.star, color: Color(0xFFFBBF24), size: 12),
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
                                ],
                              ),
                            ),
                            Icon(
                              isSelected ? Icons.check_circle : Icons.radio_button_off,
                              color: isSelected ? AppTheme.primaryBlue : const Color(0xFF94A3B8),
                              size: 22,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // Step 3: Booking Summary Confirmation
  Widget _buildStepConfirmation() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Confirm Booking Details',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 16),
          
          // Worker summary card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage(_selectedWorker.image),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedWorker.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppTheme.textDark,
                        ),
                      ),
                      Text(
                        _selectedWorker.profession,
                        style: const TextStyle(
                          color: AppTheme.textLight,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Booking details summary
          _buildSummaryRow('Work Type', _workTypeController.text),
          _buildSummaryRow('Date', _dateController.text),
          _buildSummaryRow('Time', _timeController.text),
          _buildSummaryRow('Location', _addressController.text),
          _buildSummaryRow('Description', _descController.text),
          
          const SizedBox(height: 24),
          const Divider(color: Color(0xFFE2E8F0)),
          const SizedBox(height: 12),
          
          // Price Breakdown
          const Text(
            'Price Details',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 12),
          _buildPriceRow('Service Charge', '₹${_basePrice.toStringAsFixed(0)}'),
          _buildPriceRow('Visiting & Platform Fee', '₹${_serviceFee.toStringAsFixed(0)}'),
          const SizedBox(height: 8),
          const Divider(color: Color(0xFFE2E8F0)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Amount',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppTheme.textDark,
                ),
              ),
              Text(
                '₹${_totalPrice.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppTheme.primaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textLight,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.textDark,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textLight,
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.textDark,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
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
        leading: widget.isTab && _currentStep == 1
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back, color: AppTheme.textDark),
                onPressed: () {
                  if (_currentStep > 1) {
                    setState(() {
                      _currentStep--;
                    });
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
        title: Text(
          _currentStep == 1
              ? 'Book Service'
              : (_currentStep == 2 ? 'Select Worker' : 'Confirm Summary'),
          style: const TextStyle(
            color: AppTheme.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Custom multi-step indicator
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              child: Row(
                children: [
                  Expanded(child: _buildStepIndicator(1, 'Select Service', _currentStep > 1, _currentStep == 1)),
                  Container(
                    width: 30,
                    height: 2,
                    color: _currentStep > 1 ? const Color(0xFF10B981) : const Color(0xFFE2E8F0),
                    margin: const EdgeInsets.only(bottom: 18),
                  ),
                  Expanded(child: _buildStepIndicator(2, 'Select Worker', _currentStep > 2, _currentStep == 2)),
                  Container(
                    width: 30,
                    height: 2,
                    color: _currentStep > 2 ? const Color(0xFF10B981) : const Color(0xFFE2E8F0),
                    margin: const EdgeInsets.only(bottom: 18),
                  ),
                  Expanded(child: _buildStepIndicator(3, 'Confirm', false, _currentStep == 3)),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Dynamic Step content
            Expanded(
              child: _currentStep == 1
                  ? _buildStepDetailsForm()
                  : (_currentStep == 2 ? _buildStepWorkerSelection() : _buildStepConfirmation()),
            ),

            // Bottom Navigation bar
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
                      Text(
                        '₹${_totalPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_currentStep == 1) {
                        if (_addressController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter service address'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        setState(() {
                          _currentStep = 2;
                        });
                      } else if (_currentStep == 2) {
                        setState(() {
                          _currentStep = 3;
                        });
                      } else {
                        // Create and add the booking
                        final customerName = BookingState().getCurrentUserName();
                        final newBooking = BookingModel(
                          title: _workTypeController.text,
                          location: _addressController.text,
                          dateTime: '${_dateController.text} • ${_timeController.text}',
                          status: 'Pending',
                          workerName: _selectedWorker.name,
                          serviceName: _serviceController.text,
                          description: _descController.text,
                          price: _totalPrice,
                          customerName: customerName,
                        );
                        BookingState().addBooking(newBooking);

                        Navigator.pushNamed(
                          context,
                          '/booking_confirmation',
                          arguments: newBooking,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                      minimumSize: Size.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      _currentStep == 3 ? 'Confirm Booking' : 'Continue',
                      style: const TextStyle(
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
