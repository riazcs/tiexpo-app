import 'package:flutter/material.dart';
import 'dart:convert';

class VisitorRegistrationScreen extends StatefulWidget {
  const VisitorRegistrationScreen({super.key});

  @override
  State<VisitorRegistrationScreen> createState() => _VisitorRegistrationScreenState();
}

class _VisitorRegistrationScreenState extends State<VisitorRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _companyController = TextEditingController();
  final _jobTitleController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedEvent = '';
  bool _submitted = false;
  bool _submitting = false;
  bool _termsAgreed = false;

  final Color brandPurple = const Color(0xFF7E22CE);
  final Color brandFuchsia = const Color(0xFFC026D3);

  final List<Map<String, String>> benefits = [
    {
      'title': '300+ Exhibitors',
      'description': 'Latest machinery & innovations',
    },
    {
      'title': 'Innovation Zone',
      'description': 'Next-gen textile solutions',
    },
    {
      'title': 'Networking',
      'description': 'Meet industry leaders',
    },
    {
      'title': '3 Days of Excellence',
      'description': '12–14 November 2026',
    },
  ];

  final List<String> expoOptions = [
    "Dyeing & Printing Innovation Expo 2026",
    "Textile Materials Innovation Expo 2026",
    "Garments Automation Innovation Expo 2026",
    "Green & SusTech Innovation Expo 2026",
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _companyController.dispose();
    _jobTitleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration({required String hintText, required IconData icon}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      prefixIcon: Icon(icon, color: brandPurple, size: 20),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: brandPurple, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedEvent.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an expo type.')),
      );
      return;
    }
    if (!_termsAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must agree to the Terms & Conditions.')),
      );
      return;
    }

    setState(() => _submitting = true);

    try {
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;
      setState(() => _submitted = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration Successful! 🎉 Your e-badge will be sent shortly.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Submission failed: $err'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("Visitor Registration"),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Stack(
              children: [
                Container(
                  height: 380,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage('https://images.unsplash.com/photo-1540575467063-178a50c2df87?auto=format&fit=crop&w=1400&q=80'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: 380,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.85),
                        Colors.black.withOpacity(0.65),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.home, size: 16, color: Colors.white70),
                          SizedBox(width: 6),
                          Text("Home", style: TextStyle(color: Colors.white70, fontSize: 13)),
                          SizedBox(width: 6),
                          Icon(Icons.chevron_right, size: 14, color: Colors.white38),
                          SizedBox(width: 6),
                          Text("Visitor Registration", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Register as a Visitor",
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -0.5),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Join Bangladesh’s premier textile & garment innovation exhibition. Free admission for industry professionals.",
                        style: TextStyle(fontSize: 14, color: Colors.white70, height: 1.4),
                      ),
                      const SizedBox(height: 18),
                      Wrap(
                        spacing: 16,
                        runSpacing: 8,
                        children: const [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.calendar_today, size: 15, color: Color(0xFFE9D5FF)),
                              SizedBox(width: 6),
                              Text("12–14 Nov 2026", style: TextStyle(color: Colors.white70, fontSize: 12)),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.location_on, size: 15, color: Color(0xFFE9D5FF)),
                              SizedBox(width: 6),
                              Text("ICCB, Dhaka", style: TextStyle(color: Colors.white70, fontSize: 12)),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.groups, size: 15, color: Color(0xFFE9D5FF)),
                              SizedBox(width: 6),
                              Text("300+ Exhibitors", style: TextStyle(color: Colors.white70, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Main Content Container
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Benefits / Info Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.purple.shade50,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.purple.shade100),
                              ),
                              child: const Text(
                                "WHY ATTEND",
                                style: TextStyle(color: Color(0xFF7E22CE), fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Experience the Future of Textile Innovation",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              "Connect with 300+ leading exhibitors, explore groundbreaking technologies, and network with key decision-makers.",
                              style: TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                            const SizedBox(height: 16),
                            // Safe Wrap instead of fixed GridView to solve 180px overflow warnings
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final itemWidth = (constraints.maxWidth - 12) / 2;
                                return Wrap(
                                  spacing: 12,
                                  runSpacing: 12,
                                  children: benefits.map((benefit) {
                                    return SizedBox(
                                      width: itemWidth > 0 ? itemWidth : constraints.maxWidth,
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF8FAFC),
                                          borderRadius: BorderRadius.circular(14),
                                          border: Border.all(color: const Color(0xFFE2E8F0)),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 32,
                                              width: 32,
                                              decoration: BoxDecoration(
                                                color: Colors.purple.shade100,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Icon(Icons.star_outline, color: brandPurple, size: 16),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(benefit['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                                                  const SizedBox(height: 2),
                                                  Text(benefit['description']!, style: const TextStyle(fontSize: 9.5, color: Colors.grey)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Registration Form Card
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: _submitted
                            ? Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(color: Colors.green.shade50, shape: BoxShape.circle),
                                    child: const Icon(Icons.check_circle, color: Colors.green, size: 48),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text("Registration Successful!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "Thank you for registering. Your e-badge and event details will be sent to your email shortly.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 13, color: Colors.grey),
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: brandPurple),
                                    onPressed: () => setState(() => _submitted = false),
                                    child: const Text("Register Another", style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              )
                            : Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Visitor Registration", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    const Text("Fill in your details to register", style: TextStyle(fontSize: 13, color: Colors.grey)),
                                    const Divider(height: 32),

                                    // Form Inputs with Responsive Vertical Spacing
                                    TextFormField(
                                      controller: _nameController,
                                      decoration: _inputDecoration(hintText: 'Full Name *', icon: Icons.person),
                                      validator: (v) => v!.isEmpty ? 'Full Name is required' : null,
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: _inputDecoration(hintText: 'Email Address *', icon: Icons.email),
                                      validator: (v) => v!.isEmpty ? 'Email is required' : null,
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: _phoneController,
                                      keyboardType: TextInputType.phone,
                                      decoration: _inputDecoration(hintText: 'Phone Number', icon: Icons.phone),
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: _companyController,
                                      decoration: _inputDecoration(hintText: 'Company Name', icon: Icons.business),
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: _jobTitleController,
                                      decoration: _inputDecoration(hintText: 'Job Title / Designation', icon: Icons.work),
                                    ),
                                    const SizedBox(height: 16),
                                    DropdownButtonFormField<String>(
                                      value: _selectedEvent.isEmpty ? null : _selectedEvent,
                                      decoration: _inputDecoration(hintText: 'Select an expo *', icon: Icons.event),
                                      items: expoOptions.map((expo) {
                                        return DropdownMenuItem(value: expo, child: Text(expo, overflow: TextOverflow.ellipsis));
                                      }).toList(),
                                      onChanged: (val) => setState(() => _selectedEvent = val ?? ''),
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: _notesController,
                                      maxLines: 3,
                                      maxLength: 500,
                                      decoration: _inputDecoration(hintText: 'Any special requirements or questions...', icon: Icons.note),
                                    ),
                                    const SizedBox(height: 8),

                                    CheckboxListTile(
                                      title: const Text('I agree to the Terms & Conditions and confirm accuracy.', style: TextStyle(fontSize: 12)),
                                      value: _termsAgreed,
                                      activeColor: brandPurple,
                                      contentPadding: EdgeInsets.zero,
                                      controlAffinity: ListTileControlAffinity.leading,
                                      onChanged: (val) => setState(() => _termsAgreed = val ?? false),
                                    ),
                                    const SizedBox(height: 24),

                                    SizedBox(
                                      width: double.infinity,
                                      height: 52,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: brandPurple,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                        ),
                                        onPressed: _submitting ? null : _handleSubmit,
                                        child: _submitting
                                            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                            : const Text("Register Now", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ],
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