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

  Widget _buildMethodItem(String title, IconData icon, String value) {
    bool isSelected = _selectedMethod == value;
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected ? AppTheme.primaryBlue : Colors.grey[200]!,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: RadioListTile<String>(
        value: value,
        groupValue: _selectedMethod,
        activeColor: AppTheme.primaryBlue,
        title: Row(
          children: [
            Icon(icon, color: AppTheme.primaryBlue, size: 20),
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
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryBlue),
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
                  BookingState().buySubscription(planTitle, 30);
                  Navigator.pushReplacementNamed(context, '/payment_success');
                },
                child: Text('Pay ${planPrice.split('/')[0]}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
