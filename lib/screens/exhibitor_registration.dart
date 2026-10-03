import 'package:flutter/material.dart';
import 'dart:convert';

class ExhibitorRegistrationScreen extends StatefulWidget {
  const ExhibitorRegistrationScreen({super.key});

  @override
  State<ExhibitorRegistrationScreen> createState() => _ExhibitorRegistrationScreenState();
}

class _ExhibitorRegistrationScreenState extends State<ExhibitorRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form Controllers
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

  // Selections & States
  final List<String> _selectedSegments = [];
  final List<String> _selectedExpos = [];
  final List<String> _additionalRequirements = [];
  String _boothPackage = '';
  bool _declaredAgreement = false;
  bool _isSubmitting = false;

  final Color brandPurple = const Color(0xFF7E22CE);
  final Color brandMagenta = const Color(0xFFC026D3);

  final List<String> businessSegments = [
    "Textile Machinery",
    "RMG/Apparel Manufacturer",
    "Yarn / Fabric Manufacturer",
    "Accessories & Trims",
    "Chemicals / Dyes / Auxiliaries",
    "Printing/Embroidery / Finishing",
    "Automation/Software/Technology",
    "Logistics/Supply Chain",
    "Garment Automation Technology",
  ];

  final List<String> expoOptions = [
    "Dyeing & Printing Innovation Expo",
    "Garment Automation & Innovation Expo",
    "Textile Materials Innovation Expo",
    "Green & SusTech Innovation Expo",
  ];

  final List<String> structuralRequirements = [
    "Electricity for Tech Demonstration",
    "Table/Round Table",
    "Chair",
    "Branding & Graphics Support",
    "Audio Visual Making",
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

  InputDecoration _inputDecoration({required String hintText, required IconData icon}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
      prefixIcon: Icon(icon, color: Colors.grey, size: 20),
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

    if (_selectedSegments.isEmpty || _selectedExpos.isEmpty || _boothPackage.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required selections & package fields.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final eventId = "expo_${DateTime.now().millisecondsSinceEpoch}";
      final Map<String, dynamic> payload = {
        "company_name": _companyNameController.text,
        "contact_person": _contactPersonController.text,
        "designation": _designationController.text,
        "phone": _phoneController.text,
        "email": _emailController.text,
        "company_address": _companyAddressController.text,
        "website": _websiteController.text,
        "business_segments": _selectedSegments,
        "selected_expos": _selectedExpos,
        "booth_package": _boothPackage,
        "booth_count": int.tryParse(_boothCountController.text) ?? 1,
        "booth_preference": _boothNumberPreferenceController.text,
        "additional_requirements": _additionalRequirements,
        "company_profile": _companyProfileController.text,
        "event_id": eventId,
      };

      // Simulate network request matching Vue implementation
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Booth Booking Request Logged Successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Reset Form State
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Submission failed: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("Exhibitor Registration"),
        backgroundColor: const Color(0xFF020617),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section matching Vue UI Header Layout
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              decoration: const BoxDecoration(
                color: Color(0xFF020617),
                // image: DecorationImage(
                //   image: AssetImage('assets/image/expo_banner.png'),
                //   fit: BoxFit.cover,
                //   opacity: 0.35,
                // ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.15)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, size: 6, color: Colors.purpleAccent),
                        SizedBox(width: 8),
                        Text(
                          "NOV 12–14, 2026 · ICCB, DHAKA",
                          style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Booth Booking Form",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Exhibitor information & booth selection for the Textile Innovation Expo 2026.",
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ),

            // Form Content Card Container
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
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
                      // Section Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Reserve your space", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                              SizedBox(height: 4),
                              Text("Tell us about your company and booths.", style: TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(20)),
                            child: const Row(
                              children: [
                                Icon(Icons.lock_outline, size: 12, color: Colors.green),
                                SizedBox(width: 4),
                                Text("Secure", style: TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 32),

                      // Section 1: Profile Info
                      const Text("1. EXHIBITOR PROFILE INFO", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _companyNameController,
                        decoration: _inputDecoration(hintText: 'Legal corporate name', icon: Icons.domain),
                        validator: (v) => v!.isEmpty ? 'Company Name is required' : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _contactPersonController,
                              decoration: _inputDecoration(hintText: 'Full Name', icon: Icons.person),
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _designationController,
                              decoration: _inputDecoration(hintText: 'Designation', icon: Icons.badge),
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: _inputDecoration(hintText: 'Mobile Number', icon: Icons.phone),
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: _inputDecoration(hintText: 'Email Address', icon: Icons.email),
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _companyAddressController,
                        maxLines: 2,
                        decoration: _inputDecoration(hintText: 'Company Address', icon: Icons.map),
                        validator: (v) => v!.isEmpty ? 'Address is required' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _websiteController,
                        decoration: _inputDecoration(hintText: 'Website / Social URL', icon: Icons.language),
                      ),

                      // Section 2: Business Segment
                      const SizedBox(height: 28),
                      const Text("2. BUSINESS SEGMENT *", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: businessSegments.map((segment) {
                          final isSelected = _selectedSegments.contains(segment);
                          return FilterChip(
                            label: Text(segment, style: TextStyle(fontSize: 12, color: isSelected ? brandPurple : Colors.black87)),
                            selected: isSelected,
                            selectedColor: Colors.purple.shade50,
                            checkmarkColor: brandPurple,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedSegments.add(segment);
                                } else {
                                  _selectedSegments.remove(segment);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),

                      // Section 3: Expo Participation Selection
                      const SizedBox(height: 28),
                      const Text("3. EXPO PARTICIPATION SELECTION *", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                      const SizedBox(height: 8),
                      ...expoOptions.map((expo) {
                        return CheckboxListTile(
                          title: Text(expo, style: const TextStyle(fontSize: 13)),
                          value: _selectedExpos.contains(expo),
                          activeColor: brandPurple,
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (checked) {
                            setState(() {
                              if (checked == true) {
                                _selectedExpos.add(expo);
                              } else {
                                _selectedExpos.remove(expo);
                              }
                            });
                          },
                        );
                      }),

                      // Section 4: Booth Type & Volumetrics
                      const SizedBox(height: 28),
                      const Text("4. BOOTH TYPE & VOLUMETRICS *", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _boothPackage.isEmpty ? null : _boothPackage,
                        decoration: _inputDecoration(hintText: 'Select Package Structure', icon: Icons.storefront),
                        items: const [
                          DropdownMenuItem(value: 'Basic Booth (9 sqm)', child: Text('Basic Booth (9 sqm — 3m x 3m)')),
                          DropdownMenuItem(value: 'Standard Booth (18 sqm)', child: Text('Standard Booth (18 sqm — 3m x 6m)')),
                          DropdownMenuItem(value: 'Premium Booth (12 sqm)', child: Text('Premium Booth (12 sqm — 4m x 3m)')),
                          DropdownMenuItem(value: 'Factory Innovation Pavilion (4 sqm)', child: Text('Factory Innovation Pavilion (4 sqm)')),
                          DropdownMenuItem(value: 'Raw / Customized Space', child: Text('Raw / Customized Space (Min 36 sqm)')),
                        ],
                        onChanged: (val) => setState(() => _boothPackage = val ?? ''),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _boothCountController,
                              keyboardType: TextInputType.number,
                              decoration: _inputDecoration(hintText: 'Total Booths', icon: Icons.numbers),
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _boothNumberPreferenceController,
                              decoration: _inputDecoration(hintText: 'Booth Preference (e.g. A-12)', icon: Icons.pin_drop),
                            ),
                          ),
                        ],
                      ),

                      // Section 5: Additional Infrastructure
                      const SizedBox(height: 28),
                      const Text("5. ADDITIONAL INFRASTRUCTURE REQUIREMENTS", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: structuralRequirements.map((req) {
                          final isChecked = _additionalRequirements.contains(req);
                          return FilterChip(
                            label: Text(req, style: const TextStyle(fontSize: 11)),
                            selected: isChecked,
                            selectedColor: Colors.purple.shade50,
                            checkmarkColor: brandPurple,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _additionalRequirements.add(req);
                                } else {
                                  _additionalRequirements.remove(req);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),

                      // Section 6: Corporate Profile Summary
                      const SizedBox(height: 28),
                      const Text("6. CORPORATE BACKGROUND SUMMARY *", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _companyProfileController,
                        maxLines: 4,
                        decoration: _inputDecoration(hintText: 'Provide details concerning your core innovations, production capacity, etc...', icon: Icons.notes),
                        validator: (v) => v!.isEmpty ? 'Corporate profile summary is required' : null,
                      ),

                      // Terms Agreement Checkbox
                      const SizedBox(height: 20),
                      CheckboxListTile(
                        title: const Text(
                          'I/We confirm participation in Textile Innovation Expo 2026 and agree to organizing panel rules and payment terms.',
                          style: TextStyle(fontSize: 12),
                        ),
                        value: _declaredAgreement,
                        activeColor: brandPurple,
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (val) => setState(() => _declaredAgreement = val ?? false),
                      ),

                      const SizedBox(height: 24),

                      // Submit Action Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: brandPurple,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 4,
                          ),
                          onPressed: (_isSubmitting || !_declaredAgreement) ? null : _handleSubmit,
                          child: _isSubmitting
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.verified, size: 20, color: Colors.white),
                                        SizedBox(width: 10),
                                        Text(
                                          'Submit Form',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
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