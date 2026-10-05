import 'package:flutter/material.dart';
import 'package:tiexpo/theme.dart';

class VisitorRegistrationScreen extends StatefulWidget {
  const VisitorRegistrationScreen({super.key});

  @override
  State<VisitorRegistrationScreen> createState() =>
      _VisitorRegistrationScreenState();
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

  static const Color brandPurple = Color(0xFF7E22CE);
  static const Color brandFuchsia = Color(0xFFC026D3);
  static const Color accentMauve = Color(0xFFA083B3);

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

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: accentMauve, size: 20),
      filled: true,
      fillColor: const Color(0xFFF8F7FC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      labelStyle: TextStyle(
        color: Colors.grey.shade600,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE8E4EE)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE8E4EE)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: brandPurple, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.red.shade300),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedEvent.isEmpty || !_termsAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please choose an event and accept the terms.'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() => _submitted = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Registration Successful! 🎉'),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Submission failed: $err'),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
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
        title: const Text(
          'Visitor Registration',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
            color: Color(0xFF1E1B2E), // brandInk
          ),
        ),
        backgroundColor: Colors.white, // was dark slate
        foregroundColor: const Color(0xFF1E1B2E),
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Color(0xFF1E1B2E)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: const Color(0xFFE8E4EE), // soft border under app bar
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: appBackgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ========== HERO HEADER ==========
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6D2077), Color(0xFFDE1B85)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: brandPurple.withOpacity(0.25),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.25),
                              ),
                            ),
                            child: const Text(
                              'TIEXPO 2026',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Register as a Visitor',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.15,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Join Bangladesh’s premier textile innovation exhibition and connect with industry leaders.',
                            style: TextStyle(
                              fontSize: 13.5,
                              color: Colors.white.withOpacity(0.85),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ========== FORM CARD ==========
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFEDE9F5)),
                        boxShadow: [
                          BoxShadow(
                            color: accentMauve.withOpacity(0.06),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: _submitted ? _buildSuccessState() : _buildForm(),
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

  Widget _buildSuccessState() {
    return Column(
      children: [
        const SizedBox(height: 12),
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_circle_rounded,
            color: Colors.green.shade600,
            size: 42,
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Registration Successful!',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E1B2E),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Your visitor pass will be sent to your email shortly. Please check your inbox.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13.5,
            color: Colors.grey.shade600,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: brandPurple, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () => setState(() => _submitted = false),
            child: const Text(
              'Register Another Visitor',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: brandPurple,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E1B2E),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Fill in the information below to complete registration',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 22),

          // Full Name
          TextFormField(
            controller: _nameController,
            textInputAction: TextInputAction.next,
            decoration: _inputDecoration(
              label: 'Full Name *',
              hint: 'Enter your full name',
              icon: Icons.person_outline_rounded,
            ),
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Full name is required' : null,
          ),
          const SizedBox(height: 14),

          // Email
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: _inputDecoration(
              label: 'Email Address *',
              hint: 'you@company.com',
              icon: Icons.email_outlined,
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Email is required';
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                return 'Enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),

          // Phone
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            decoration: _inputDecoration(
              label: 'Phone Number',
              hint: '+880 1XXX-XXXXXX',
              icon: Icons.phone_outlined,
            ),
          ),
          const SizedBox(height: 14),

          // Company
          TextFormField(
            controller: _companyController,
            textInputAction: TextInputAction.next,
            decoration: _inputDecoration(
              label: 'Company Name',
              hint: 'Your organization',
              icon: Icons.business_outlined,
            ),
          ),
          const SizedBox(height: 14),

          // Job Title
          TextFormField(
            controller: _jobTitleController,
            textInputAction: TextInputAction.next,
            decoration: _inputDecoration(
              label: 'Job Title / Designation',
              hint: 'e.g. Production Manager',
              icon: Icons.work_outline_rounded,
            ),
          ),
          const SizedBox(height: 14),

          // Event dropdown
          DropdownButtonFormField<String>(
            value: _selectedEvent.isEmpty ? null : _selectedEvent,
            isExpanded: true,
            decoration: _inputDecoration(
              label: 'Select an Expo *',
              hint: 'Choose event',
              icon: Icons.event_outlined,
            ),
            items: expoOptions
                .map(
                  (expo) => DropdownMenuItem(
                    value: expo,
                    child: Text(
                      expo,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                )
                .toList(),
            onChanged: (v) => setState(() => _selectedEvent = v ?? ''),
            validator: (v) =>
                v == null || v.isEmpty ? 'Please select an expo' : null,
          ),
          const SizedBox(height: 14),

          // Notes
          TextFormField(
            controller: _notesController,
            maxLines: 3,
            textInputAction: TextInputAction.done,
            decoration: _inputDecoration(
              label: 'Special Requirements',
              hint: 'Any notes or requests (optional)',
              icon: Icons.notes_rounded,
            ),
          ),
          const SizedBox(height: 8),

          // Terms
          Theme(
            data: Theme.of(context).copyWith(
              checkboxTheme: CheckboxThemeData(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            child: CheckboxListTile(
              title: Text(
                'I agree to the Terms & Conditions and confirm that the information provided is accurate.',
                style: TextStyle(
                  fontSize: 12.5,
                  color: Colors.grey.shade700,
                  height: 1.35,
                ),
              ),
              value: _termsAgreed,
              activeColor: brandPurple,
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
              onChanged: (v) => setState(() => _termsAgreed = v ?? false),
            ),
          ),

          const SizedBox(height: 20),

          // Submit
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: brandPurple,
                foregroundColor: Colors.white,
                elevation: 0,
                shadowColor: brandPurple.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: _submitting ? null : _handleSubmit,
              child: _submitting
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.2,
                      ),
                    )
                  : const Text(
                      'Register Now',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
