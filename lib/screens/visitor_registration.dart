import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:tiexpo/theme.dart';

class VisitorRegistrationScreen extends StatefulWidget {
  const VisitorRegistrationScreen({super.key});

  @override
  State<VisitorRegistrationScreen> createState() => _VisitorRegistrationScreenState();
}

class _VisitorRegistrationScreenState extends State<VisitorRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
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

  final List<String> expoOptions = [
    'Dyeing & Printing Innovation Expo',
    'Garment Automation & Innovation Expo',
    'Textile Materials Innovation Expo',
    'Green & SusTech Innovation Expo',
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
      prefixIcon: Icon(icon, color: Colors.grey, size: 20),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: brandPurple, width: 2),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedEvent.isEmpty || !_termsAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please choose an event and accept the terms.')),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() => _submitted = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration Successful! 🎉'),
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
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Visitor Registration'),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: appBackgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [brandPurple, brandFuchsia],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Register as a Visitor',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Join Bangladesh’s premier textile innovation exhibition.',
                            style: TextStyle(fontSize: 15, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
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
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.check_circle, color: Colors.green, size: 48),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Registration Successful!',
                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Your visitor pass will be sent to your email shortly.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 13, color: Colors.grey),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: brandPurple),
                                  onPressed: () => setState(() => _submitted = false),
                                  child: const Text('Register Another', style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            )
                          : Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Visitor Registration',
                                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Fill in your details to register',
                                    style: TextStyle(fontSize: 13, color: Colors.grey),
                                  ),
                                  const SizedBox(height: 24),
                                  TextFormField(
                                    controller: _nameController,
                                    decoration: _inputDecoration(hintText: 'Full Name *', icon: Icons.person),
                                    validator: (value) => value == null || value.isEmpty ? 'Full Name is required' : null,
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: _inputDecoration(hintText: 'Email Address *', icon: Icons.email),
                                    validator: (value) => value == null || value.isEmpty ? 'Email is required' : null,
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
                                      return DropdownMenuItem<String>(
                                        value: expo,
                                        child: Text(expo),
                                      );
                                    }).toList(),
                                    onChanged: (value) => setState(() => _selectedEvent = value ?? ''),
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _notesController,
                                    maxLines: 3,
                                    decoration: _inputDecoration(hintText: 'Any special requirements...', icon: Icons.note),
                                  ),
                                  const SizedBox(height: 12),
                                  CheckboxListTile(
                                    title: const Text(
                                      'I agree to the Terms & Conditions and confirm accuracy.',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    value: _termsAgreed,
                                    activeColor: brandPurple,
                                    contentPadding: EdgeInsets.zero,
                                    controlAffinity: ListTileControlAffinity.leading,
                                    onChanged: (value) => setState(() => _termsAgreed = value ?? false),
                                  ),
                                  const SizedBox(height: 24),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 52,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: brandPurple,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                      ),
                                      onPressed: _submitting ? null : _handleSubmit,
                                      child: _submitting
                                          ? const SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : const Text(
                                              'Register Now',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
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
        ),
      ),
    );
  }
}
