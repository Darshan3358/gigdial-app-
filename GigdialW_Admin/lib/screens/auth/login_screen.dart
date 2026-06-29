import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../theme/app_theme.dart';
import '../../data/app_config.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isWorker = AppConfig.flavor == AppFlavor.worker;
    final bool isAdmin = AppConfig.flavor == AppFlavor.admin;
    final Color primaryColor = AppConfig.primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textDark),
          onPressed: () => Navigator.pushReplacementNamed(context, isAdmin ? '/' : '/onboarding'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Welcome Header
              Text(
                'Welcome Back',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isAdmin ? 'Login as Admin' : (isWorker ? 'Login as Partner' : 'Login to Continue'),
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 40),

              // Email / Mobile Input
              Text(
                isAdmin ? 'Enter Email' : 'Enter Mobile Number',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _phoneController,
                keyboardType: isAdmin ? TextInputType.emailAddress : TextInputType.phone,
                decoration: InputDecoration(
                  hintText: isAdmin ? 'Enter Email Address' : 'Enter Mobile Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 24),

              // Password Input
              const Text(
                'Enter Password',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Enter Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: Colors.grey[500],
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              
              // Forgot Password link
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
                            // Login Button
              ElevatedButton(
                onPressed: _isLoading ? null : () async {
                  final phone = _phoneController.text.trim();
                  final password = _passwordController.text.trim();

                  if (phone.isEmpty || password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill all fields'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  String resolvedEmail = phone;
                  if (!phone.contains('@')) {
                    setState(() {
                      _isLoading = true;
                    });
                    try {
                      final usersSnapshot = await FirebaseDatabase.instance.ref('users').get();
                      String? email;
                      if (usersSnapshot.exists && usersSnapshot.value is Map) {
                        final users = Map<String, dynamic>.from(usersSnapshot.value as Map);
                        for (var user in users.values) {
                          if (user is Map && user['phone'] == phone) {
                            email = user['email'];
                            break;
                          }
                        }
                      }
                      if (email == null) {
                        final workersSnapshot = await FirebaseDatabase.instance.ref('workers').get();
                        if (workersSnapshot.exists && workersSnapshot.value is Map) {
                          final workers = Map<String, dynamic>.from(workersSnapshot.value as Map);
                          for (var worker in workers.values) {
                            if (worker is Map && worker['phone'] == phone) {
                              email = worker['email'];
                              break;
                            }
                          }
                        }
                      }
                      resolvedEmail = email ?? '$phone@gigdial.com';
                    } catch (e) {
                      print("Error resolving phone: $e");
                      resolvedEmail = '$phone@gigdial.com';
                    }
                  }

                  setState(() {
                    _isLoading = true;
                  });

                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: resolvedEmail,
                      password: password,
                    );
                    if (mounted) {
                      Navigator.pushReplacementNamed(context, AppConfig.homeRoute);
                    }
                  } on FirebaseAuthException catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.message ?? 'Login failed'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('An unexpected error occurred: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } finally {
                    if (mounted) {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading 
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text('Login'),
              ),
              const SizedBox(height: 32),
              if (!isAdmin) ...[
                // Register Redirection
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? ", style: TextStyle(color: Colors.grey[600])),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final double radius = width / 2;
    
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width * 0.22
      ..strokeCap = StrokeCap.square;
    
    final Rect rect = Rect.fromCircle(center: Offset(radius, radius), radius: radius - paint.strokeWidth / 2);
    
    // Red arc (top-left to top-right)
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(rect, -2.4, 1.35, false, paint);
    
    // Yellow arc (bottom-left to top-left)
    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(rect, -3.85, 1.45, false, paint);
    
    // Green arc (bottom-right to bottom-left)
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(rect, 0.45, 1.7, false, paint);
    
    // Blue arc (top-right to bottom-right, with crossbar)
    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(rect, -1.1, 1.55, false, paint);
    
    // Draw the horizontal bar
    final Paint barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;
    final Rect bar = Rect.fromLTWH(radius, radius - paint.strokeWidth / 2, radius, paint.strokeWidth);
    canvas.drawRect(bar, barPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
