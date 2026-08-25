import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/vendor_registration_model.dart';
import 'vendor_registration_controller.dart';

class VendorRegistrationPage extends ConsumerStatefulWidget {
  const VendorRegistrationPage({super.key});

  @override
  ConsumerState<VendorRegistrationPage> createState() => _VendorRegistrationPageState();
}

class _VendorRegistrationPageState extends ConsumerState<VendorRegistrationPage> {
  final _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  int _currentStep = 0;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _pincodeController = TextEditingController();
  
  final _panController = TextEditingController();
  final _gstController = TextEditingController();
  final _aadhaarController = TextEditingController();
  
  final _bankAccountController = TextEditingController();
  final _ifscController = TextEditingController();
  final _otpController = TextEditingController();

  bool _isFetchingLocation = false;
  static const String _draftKey = 'vendor_registration_draft';

  // Mocked user data to trigger OTP
  final String _mockRegisteredPhone = "9876543210";
  final String _mockRegisteredEmail = "user@example.com";

  bool get _requiresOtp {
    return _phoneController.text.trim() != _mockRegisteredPhone ||
           _emailController.text.trim() != _mockRegisteredEmail;
  }

  @override
  void initState() {
    super.initState();
    _loadDraft();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _pincodeController.dispose();
    _panController.dispose();
    _gstController.dispose();
    _aadhaarController.dispose();
    _bankAccountController.dispose();
    _ifscController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _saveDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final draft = {
      'name': _nameController.text,
      'phone': _phoneController.text,
      'email': _emailController.text,
      'address': _addressController.text,
      'pincode': _pincodeController.text,
      'pan': _panController.text,
      'gst': _gstController.text,
      'aadhaar': _aadhaarController.text,
      'bankAccount': _bankAccountController.text,
      'ifsc': _ifscController.text,
    };
    await prefs.setString(_draftKey, jsonEncode(draft));
  }

  Future<void> _loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final draftString = prefs.getString(_draftKey);
    if (draftString != null) {
      try {
        final draft = jsonDecode(draftString) as Map<String, dynamic>;
        setState(() {
          _nameController.text = draft['name'] ?? '';
          _phoneController.text = draft['phone'] ?? '';
          _emailController.text = draft['email'] ?? '';
          _addressController.text = draft['address'] ?? '';
          _pincodeController.text = draft['pincode'] ?? '';
          _panController.text = draft['pan'] ?? '';
          _gstController.text = draft['gst'] ?? '';
          _aadhaarController.text = draft['aadhaar'] ?? '';
          _bankAccountController.text = draft['bankAccount'] ?? '';
          _ifscController.text = draft['ifsc'] ?? '';
        });
      } catch (e) {
        // Ignored
      }
    }
  }

  Future<void> _clearDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_draftKey);
  }

  Future<void> _fetchCurrentLocation() async {
    setState(() => _isFetchingLocation = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        _addressController.text = "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}";
        _pincodeController.text = place.postalCode ?? "";
        _saveDraft();
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location fetched successfully! You can edit the details if needed.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch location: $e')),
      );
    } finally {
      setState(() => _isFetchingLocation = false);
    }
  }

  void _nextStep() {
    if (_formKeys[_currentStep].currentState!.validate()) {
      if (_currentStep == 0 && _requiresOtp && _otpController.text != "1234") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid OTP. Please enter 1234 for testing.')),
        );
        return;
      }
      
      if (_currentStep < 2) {
        setState(() => _currentStep++);
      } else {
        _submit();
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _submit() async {
    final model = VendorRegistrationModel(
      vendorName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      address: _addressController.text.trim(),
      pincode: _pincodeController.text.trim(),
      panNumber: _panController.text.trim().toUpperCase(),
      gstNumber: _gstController.text.trim().toUpperCase(),
      aadhaarNumber: _aadhaarController.text.trim(),
      bankAccountNumber: _bankAccountController.text.trim(),
      ifscCode: _ifscController.text.trim().toUpperCase(),
    );

    try {
      await ref.read(vendorRegistrationControllerProvider.notifier).submitRegistration(model);
      await _clearDraft();
    } catch (e) {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(vendorRegistrationControllerProvider);

    if (state.status == VendorStatus.pending) {
      return Scaffold(
        appBar: AppBar(title: const Text('Verification')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 24),
              Text(
                'Waiting for verification from backend...',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8),
              Text('This usually takes a few seconds.', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    if (state.status == VendorStatus.verified) {
      return Scaffold(
        appBar: AppBar(title: const Text('Verified!')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 80),
              const SizedBox(height: 24),
              const Text(
                'You are now verified as a Vendor!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  if (context.canPop()) context.pop();
                },
                child: const Text('Go to Profile'),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendor Registration'),
      ),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _currentStep,
        onStepContinue: _nextStep,
        onStepCancel: _previousStep,
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: details.onStepContinue,
                    child: Text(_currentStep == 2 ? 'Submit Registration' : 'Continue'),
                  ),
                ),
                if (_currentStep > 0) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: details.onStepCancel,
                      child: const Text('Back'),
                    ),
                  ),
                ]
              ],
            ),
          );
        },
        steps: [
          Step(
            title: const Text('Details'),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
            content: Form(
              key: _formKeys[0],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTextField(
                    controller: _nameController,
                    label: 'Business/Vendor Name',
                    icon: Icons.storefront,
                    validator: (v) => v!.isEmpty ? 'Name is required' : null,
                  ),
                  _buildTextField(
                    controller: _phoneController,
                    label: 'Phone Number',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    onChanged: (v) {
                      _saveDraft();
                      setState(() {});
                    },
                    validator: (v) {
                      if (v!.isEmpty) return 'Phone is required';
                      if (!RegExp(r'^[56789]\d{9}$').hasMatch(v)) return 'Invalid phone number';
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email Address',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (v) {
                      _saveDraft();
                      setState(() {});
                    },
                    validator: (v) {
                      if (v!.isEmpty) return 'Email is required';
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) {
                        return 'Invalid email address';
                      }
                      return null;
                    },
                  ),
                  if (_requiresOtp)
                    _buildTextField(
                      controller: _otpController,
                      label: 'OTP Verification (Use 1234)',
                      icon: Icons.security,
                      keyboardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? 'OTP is required' : null,
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Address Details', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextButton.icon(
                        icon: _isFetchingLocation ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.my_location, size: 16),
                        label: const Text('Fetch Current'),
                        onPressed: _isFetchingLocation ? null : _fetchCurrentLocation,
                      )
                    ],
                  ),
                  _buildTextField(
                    controller: _addressController,
                    label: 'Address',
                    icon: Icons.location_on,
                    maxLines: 2,
                    validator: (v) => v!.isEmpty ? 'Address is required' : null,
                  ),
                  _buildTextField(
                    controller: _pincodeController,
                    label: 'Pincode',
                    icon: Icons.pin_drop,
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v!.isEmpty) return 'Pincode is required';
                      if (!RegExp(r'^[1-9][0-9]{5}$').hasMatch(v)) return 'Invalid pincode';
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          Step(
            title: const Text('Identity'),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
            content: Form(
              key: _formKeys[1],
              child: Column(
                children: [
                  _buildTextField(
                    controller: _panController,
                    label: 'PAN Number',
                    icon: Icons.credit_card,
                    textCapitalization: TextCapitalization.characters,
                    validator: (v) {
                      if (v!.isEmpty) return 'PAN is required';
                      if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$').hasMatch(v)) return 'Invalid PAN format';
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: _gstController,
                    label: 'GST Number',
                    icon: Icons.receipt_long,
                    textCapitalization: TextCapitalization.characters,
                    validator: (v) {
                      if (v!.isEmpty) return 'GST is required';
                      if (!RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$').hasMatch(v)) {
                        return 'Invalid GST format';
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: _aadhaarController,
                    label: 'Aadhaar Number',
                    icon: Icons.badge,
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v!.isEmpty) return 'Aadhaar is required';
                      if (!RegExp(r'^[2-9]\d{11}$').hasMatch(v)) return 'Invalid Aadhaar format';
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          Step(
            title: const Text('Bank'),
            isActive: _currentStep >= 2,
            content: Form(
              key: _formKeys[2],
              child: Column(
                children: [
                  _buildTextField(
                    controller: _bankAccountController,
                    label: 'Bank Account Number',
                    icon: Icons.account_balance,
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v!.isEmpty) return 'Account number is required';
                      if (!RegExp(r'^\d{9,18}$').hasMatch(v)) return 'Invalid account number';
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: _ifscController,
                    label: 'IFSC Code',
                    icon: Icons.account_balance_wallet,
                    textCapitalization: TextCapitalization.characters,
                    validator: (v) {
                      if (v!.isEmpty) return 'IFSC is required';
                      if (!RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$').hasMatch(v)) return 'Invalid IFSC code';
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    void Function(String)? onChanged,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.none,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        onChanged: (v) {
          _saveDraft();
          if (onChanged != null) onChanged(v);
        },
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        maxLines: maxLines,
        validator: validator,
      ),
    );
  }
}
