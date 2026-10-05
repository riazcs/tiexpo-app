import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:tiexpo/theme.dart';

class ExhibitorRegistrationScreen extends StatefulWidget {
  const ExhibitorRegistrationScreen({super.key});

  @override
  State<ExhibitorRegistrationScreen> createState() =>
      _ExhibitorRegistrationScreenState();
}

class _ExhibitorRegistrationScreenState
    extends State<ExhibitorRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _designationController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _companyAddressController = TextEditingController();
  final _websiteController = TextEditingController();
  final _boothCountController = TextEditingController(text: '1');
  final _boothNumberPreferenceController = TextEditingController();
  final _companyProfileController = TextEditingController();

  final List<String> _selectedSegments = [];
  final List<String> _selectedExpos = [];
  final List<String> _additionalRequirements = [];
  String _boothPackage = '';
  bool _declaredAgreement = false;
  bool _isSubmitting = false;

  final List<String> businessSegments = [
    'Textile Machinery',
    'RMG/Apparel Manufacturer',
    'Yarn / Fabric Manufacturer',
    'Accessories & Trims',
    'Chemicals / Dyes / Auxiliaries',
    'Printing/Embroidery / Finishing',
    'Automation/Software/Technology',
    'Logistics/Supply Chain',
  ];

  final List<String> expoOptions = [
    'Dyeing & Printing Innovation Expo',
    'Garment Automation & Innovation Expo',
    'Textile Materials Innovation Expo',
    'Green & SusTech Innovation Expo',
  ];

  final List<String> structuralRequirements = [
    'Electricity for Tech Demonstration',
    'Table/Round Table',
    'Chair',
    'Branding & Graphics Support',
    'Audio Visual Making',
  ];

  @override
  void dispose() {
    _companyNameController.dispose();
    _contactPersonController.dispose();
    _designationController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _companyAddressController.dispose();
    _websiteController.dispose();
    _boothCountController.dispose();
    _boothNumberPreferenceController.dispose();
    _companyProfileController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(icon, color: brandMuted, size: 20),
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
    if (_selectedSegments.isEmpty ||
        _selectedExpos.isEmpty ||
        _boothPackage.isEmpty ||
        !_declaredAgreement) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please complete all required selections and agreement.',
          ),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booth booking request logged successfully.'),
          backgroundColor: brandPurple,
        ),
      );
      _formKey.currentState!.reset();
      setState(() {
        _companyNameController.clear();
        _contactPersonController.clear();
        _designationController.clear();
        _phoneController.clear();
        _emailController.clear();
        _companyAddressController.clear();
        _websiteController.clear();
        _boothCountController.text = '1';
        _boothNumberPreferenceController.clear();
        _companyProfileController.clear();
        _selectedSegments.clear();
        _selectedExpos.clear();
        _additionalRequirements.clear();
        _boothPackage = '';
        _declaredAgreement = false;
      });
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Submission failed: $err'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Exhibitor Registration'),
        backgroundColor: paper,
        foregroundColor: brandInk,
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: appBackgroundGradient),
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
                          colors: [brandCyan, brandPurple],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Booth Booking Form',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Exhibitor information & booth selection for the Textile Innovation Expo 2026.',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white70,
                            ),
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
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Company Details',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _companyNameController,
                              decoration: _inputDecoration(
                                hintText: 'Company Name *',
                                icon: Icons.business,
                              ),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                  ? 'Company Name is required'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _contactPersonController,
                              decoration: _inputDecoration(
                                hintText: 'Contact Person *',
                                icon: Icons.person,
                              ),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                  ? 'Contact Person is required'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _designationController,
                              decoration: _inputDecoration(
                                hintText: 'Designation *',
                                icon: Icons.work,
                              ),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                  ? 'Designation is required'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: _inputDecoration(
                                hintText: 'Phone Number *',
                                icon: Icons.phone,
                              ),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                  ? 'Phone Number is required'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: _inputDecoration(
                                hintText: 'Email Address *',
                                icon: Icons.email,
                              ),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                  ? 'Email is required'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _companyAddressController,
                              decoration: _inputDecoration(
                                hintText: 'Company Address',
                                icon: Icons.location_on,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _websiteController,
                              decoration: _inputDecoration(
                                hintText: 'Website',
                                icon: Icons.link,
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Business Segment',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: businessSegments.map((segment) {
                                final selected = _selectedSegments.contains(
                                  segment,
                                );
                                return FilterChip(
                                  label: Text(segment),
                                  selected: selected,
                                  selectedColor: paper2,
                                  onSelected: (value) {
                                    setState(() {
                                      if (value) {
                                        _selectedSegments.add(segment);
                                      } else {
                                        _selectedSegments.remove(segment);
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Selected Expo',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: expoOptions.map((expo) {
                                final selected = _selectedExpos.contains(expo);
                                return FilterChip(
                                  label: Text(expo),
                                  selected: selected,
                                  selectedColor: brandCyanSoft,
                                  onSelected: (value) {
                                    setState(() {
                                      if (value) {
                                        _selectedExpos.add(expo);
                                      } else {
                                        _selectedExpos.remove(expo);
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Booth Package',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children:
                                  [
                                    'Standard',
                                    'Premium',
                                    'Platinum',
                                    'Custom',
                                  ].map((pkg) {
                                    final selected = _boothPackage == pkg;
                                    return ChoiceChip(
                                      label: Text(pkg),
                                      selected: selected,
                                      selectedColor: paper2,
                                      onSelected: (_) =>
                                          setState(() => _boothPackage = pkg),
                                    );
                                  }).toList(),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _boothCountController,
                              keyboardType: TextInputType.number,
                              decoration: _inputDecoration(
                                hintText: 'Booth Count',
                                icon: Icons.format_list_numbered,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _boothNumberPreferenceController,
                              decoration: _inputDecoration(
                                hintText: 'Preferred Booth Number',
                                icon: Icons.pin_drop,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _companyProfileController,
                              maxLines: 4,
                              decoration: _inputDecoration(
                                hintText: 'Company Profile',
                                icon: Icons.description,
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Additional Requirements',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: structuralRequirements.map((
                                requirement,
                              ) {
                                final selected = _additionalRequirements
                                    .contains(requirement);
                                return FilterChip(
                                  label: Text(requirement),
                                  selected: selected,
                                  selectedColor: brandCyanSoft,
                                  onSelected: (value) {
                                    setState(() {
                                      if (value) {
                                        _additionalRequirements.add(
                                          requirement,
                                        );
                                      } else {
                                        _additionalRequirements.remove(
                                          requirement,
                                        );
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 24),
                            CheckboxListTile(
                              title: const Text(
                                'I confirm the information is accurate and agree to the event terms.',
                                style: TextStyle(fontSize: 12),
                              ),
                              value: _declaredAgreement,
                              activeColor: brandPurple,
                              contentPadding: EdgeInsets.zero,
                              controlAffinity: ListTileControlAffinity.leading,
                              onChanged: (value) => setState(
                                () => _declaredAgreement = value ?? false,
                              ),
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
                                onPressed: _isSubmitting ? null : _handleSubmit,
                                child: _isSubmitting
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        'Submit Booth Request',
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
