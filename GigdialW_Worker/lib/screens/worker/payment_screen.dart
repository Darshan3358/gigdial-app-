import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/booking_state.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedMethod = 'UPI';
  
  final _upiController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cardNameController = TextEditingController();
  String _selectedBank = 'SBI';
  String _selectedWallet = 'Paytm';

  @override
  void dispose() {
    _upiController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _cardNameController.dispose();
    super.dispose();
  }

  Widget _buildDynamicPaymentFields() {
    switch (_selectedMethod) {
      case 'UPI':
        return Container(
          margin: const EdgeInsets.only(top: 8, bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select UPI App',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.textDark),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildQuickUpiAppButton('Google Pay', Icons.account_balance_wallet_outlined),
                  _buildQuickUpiAppButton('PhonePe', Icons.mobile_friendly),
                  _buildQuickUpiAppButton('Paytm', Icons.payment),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Or Enter UPI ID',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.textDark),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _upiController,
                decoration: InputDecoration(
                  hintText: 'e.g. username@okaxis',
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.teal),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
            ],
          ),
        );
      case 'Cards':
        return Container(
          margin: const EdgeInsets.only(top: 8, bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Card Details',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.textDark),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _cardNumberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Card Number',
                  prefixIcon: const Icon(Icons.credit_card, size: 18),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _expiryController,
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        hintText: 'Expiry (MM/YY)',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _cvvController,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'CVV',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _cardNameController,
                decoration: InputDecoration(
                  hintText: 'Cardholder Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
            ],
          ),
        );
      case 'Net Banking':
        return Container(
          margin: const EdgeInsets.only(top: 8, bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Popular Bank',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.textDark),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedBank,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                items: const [
                  DropdownMenuItem(value: 'SBI', child: Text('State Bank of India')),
                  DropdownMenuItem(value: 'HDFC', child: Text('HDFC Bank')),
                  DropdownMenuItem(value: 'ICICI', child: Text('ICICI Bank')),
                  DropdownMenuItem(value: 'Axis', child: Text('Axis Bank')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedBank = val;
                    });
                  }
                },
              ),
            ],
          ),
        );
      case 'Wallets':
        return Container(
          margin: const EdgeInsets.only(top: 8, bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Wallet Provider',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.textDark),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedWallet,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                items: const [
                  DropdownMenuItem(value: 'Paytm', child: Text('Paytm Wallet')),
                  DropdownMenuItem(value: 'PhonePe', child: Text('PhonePe Wallet')),
                  DropdownMenuItem(value: 'AmazonPay', child: Text('Amazon Pay Wallet')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedWallet = val;
                    });
                  }
                },
              ),
            ],
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildQuickUpiAppButton(String appName, IconData icon) {
    return InkWell(
      onTap: () {
        setState(() {
          _upiController.text = '${appName.toLowerCase().replaceAll(' ', '')}@upi';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected $appName')),
        );
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.teal.withOpacity(0.08),
            child: Icon(icon, color: Colors.teal, size: 20),
          ),
          const SizedBox(height: 4),
          Text(appName, style: const TextStyle(fontSize: 10, color: AppTheme.textLight)),
        ],
      ),
    );
  }

  Widget _buildMethodItem(String title, IconData icon, String value) {
    bool isSelected = _selectedMethod == value;
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected ? Colors.teal : Colors.grey[200]!,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: RadioListTile<String>(
        value: value,
        groupValue: _selectedMethod,
        activeColor: Colors.teal,
        title: Row(
          children: [
            Icon(icon, color: Colors.teal, size: 20),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppTheme.textDark,
              ),
            ),
          ],
        ),
        onChanged: (newValue) {
          if (newValue != null) {
            setState(() {
              _selectedMethod = newValue;
            });
          }
        },
      ),
    );
  }

  void _processPayment(String planTitle, String planPrice) {
    // Validate inputs
    if (_selectedMethod == 'UPI' && _upiController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter or select a UPI ID')),
      );
      return;
    }
    if (_selectedMethod == 'Cards') {
      if (_cardNumberController.text.trim().isEmpty || 
          _expiryController.text.trim().isEmpty || 
          _cvvController.text.trim().isEmpty || 
          _cardNameController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all card details')),
        );
        return;
      }
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            String statusText = 'Initiating Secure Transaction...';
            double progress = 0.25;

            Future.delayed(const Duration(milliseconds: 1000), () {
              if (context.mounted) {
                setDialogState(() {
                  statusText = 'Contacting payment gateway...';
                  progress = 0.5;
                });
              }
            });

            Future.delayed(const Duration(milliseconds: 2000), () {
              if (context.mounted) {
                setDialogState(() {
                  statusText = 'Verifying details with your bank...';
                  progress = 0.75;
                });
              }
            });

            Future.delayed(const Duration(milliseconds: 3200), () async {
              if (context.mounted) {
                setDialogState(() {
                  statusText = 'Finalizing subscription details...';
                  progress = 1.0;
                });
                
                // Perform database update
                final priceCleaned = planPrice.replaceAll(RegExp(r'[^0-9.]'), '');
                final amount = double.tryParse(priceCleaned) ?? 0.0;
                await BookingState().buySubscription(planTitle, 30, amount: amount, paymentMethod: _selectedMethod);
                
                if (context.mounted) {
                  Navigator.pop(context); // Close loading dialog
                  Navigator.pushReplacementNamed(context, '/payment_success');
                }
              }
            });

            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              content: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        color: Colors.teal,
                        strokeWidth: 4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      statusText,
                      style: const TextStyle(
                        color: AppTheme.textDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: progress,
                      color: Colors.teal,
                      backgroundColor: Colors.teal.withOpacity(0.1),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Dynamic arguments processing
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
    final planTitle = args?['title'] ?? 'Professional Plan';
    final planPrice = args?['price'] ?? '₹299 / Month';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Payment Screen'),
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
                    // Plan Summary Info Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            planTitle,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.teal),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            planPrice,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                          ),
                          const Divider(height: 20),
                          const Text(
                            '• Unlimited Leads\n• Higher Visibility\n• Priority Support',
                            style: TextStyle(color: Colors.grey, fontSize: 12, height: 1.6),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Payment Options title
                    Text('Payment Methods', style: AppTheme.titleMedium),
                    const SizedBox(height: 12),

                    // Method list items
                    _buildMethodItem('UPI', Icons.phone_android, 'UPI'),
                    _buildMethodItem('Credit / Debit Cards', Icons.credit_card, 'Cards'),
                    _buildMethodItem('Net Banking', Icons.account_balance, 'Net Banking'),
                    _buildMethodItem('Wallets', Icons.account_balance_wallet, 'Wallets'),
                    const SizedBox(height: 12),
                    _buildDynamicPaymentFields(),
                  ],
                ),
              ),
            ),

            // Pay Button Footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  _processPayment(planTitle, planPrice);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Pay ${planPrice.split('/')[0]}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
