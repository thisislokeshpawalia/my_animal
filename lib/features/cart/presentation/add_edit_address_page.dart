import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/service/location/address_model.dart';
import '../../../core/service/location/address_provider.dart';

class AddEditAddressPage extends ConsumerStatefulWidget {
  final AddressModel? address;

  // Address obtained from current GPS location.
  // This is used only when adding a new address.
  final AddressModel? prefilledAddress;

  const AddEditAddressPage({
    super.key,
    this.address,
    this.prefilledAddress,
  });

  @override
  ConsumerState<AddEditAddressPage> createState() =>
      _AddEditAddressPageState();
}

class _AddEditAddressPageState
    extends ConsumerState<AddEditAddressPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  final _line1Controller = TextEditingController();
  final _line2Controller = TextEditingController();

  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();

  String _title = "Home";
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();

    // -------------------------------------------------
    // EDIT EXISTING ADDRESS
    // -------------------------------------------------
    if (widget.address != null) {
      final data = widget.address!;

      _title = data.title;
      _isDefault = data.isDefault;

      _nameController.text = data.fullName;
      _phoneController.text = data.phone;

      _line1Controller.text = data.addressLine1;
      _line2Controller.text = data.addressLine2;

      _cityController.text = data.city;
      _stateController.text = data.state;
      _pincodeController.text = data.pincode;

      return;
    }

    // -------------------------------------------------
    // ADD NEW ADDRESS FROM CURRENT LOCATION
    // -------------------------------------------------
    if (widget.prefilledAddress != null) {
      final data = widget.prefilledAddress!;

      _title = data.title;
      _isDefault = data.isDefault;

      _nameController.text = data.fullName;
      _phoneController.text = data.phone;

      // IMPORTANT:
      // Address Line 1 is intentionally NOT prefilled.
      //
      // The user must enter:
      // Flat / House No / Street / Building
      //
      // Example:
      // Flat 203, ABC Apartments
      _line1Controller.text = "";

      // Address Line 2 is optional.
      //
      // If reverse geocoding returned something useful,
      // you can prefill it.
      _line2Controller.text = data.addressLine2;

      // These values come from GPS / reverse geocoding.
      _cityController.text = data.city;
      _stateController.text = data.state;
      _pincodeController.text = data.pincode;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();

    _line1Controller.dispose();
    _line2Controller.dispose();

    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();

    super.dispose();
  }

  // -------------------------------------------------
  // SAVE ADDRESS
  // -------------------------------------------------

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final address = AddressModel(
      id: widget.address?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),

      title: _title,

      fullName: _nameController.text.trim(),

      phone: _phoneController.text.trim(),

      // REQUIRED
      addressLine1: _line1Controller.text.trim(),

      // OPTIONAL
      addressLine2: _line2Controller.text.trim(),

      city: _cityController.text.trim(),

      state: _stateController.text.trim(),

      pincode: _pincodeController.text.trim(),

      isDefault: _isDefault,
    );

    // -------------------------------------------------
    // ADD NEW ADDRESS
    // -------------------------------------------------

    if (widget.address == null) {
      await ref
          .read(addressProvider.notifier)
          .addAddress(address);
    }

    // -------------------------------------------------
    // UPDATE EXISTING ADDRESS
    // -------------------------------------------------

    else {
      await ref
          .read(addressProvider.notifier)
          .updateAddress(address);
    }

    if (!mounted) return;

    Navigator.pop(context, address);
  }

  // -------------------------------------------------
  // REQUIRED FIELD
  // -------------------------------------------------

  Widget buildRequiredField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,

        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "$label is required";
          }

          return null;
        },

        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------
  // OPTIONAL FIELD
  // -------------------------------------------------

  Widget buildOptionalField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,

        // No validator.
        // User can leave this field empty.

        decoration: InputDecoration(
          labelText: label,
          hintText: "Optional",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------
  // ADDRESS TITLE CHIP
  // -------------------------------------------------

  Widget buildTitleChip(String title) {
    return ChoiceChip(
      label: Text(title),

      selected: _title == title,

      onSelected: (_) {
        setState(() {
          _title = title;
        });
      },
    );
  }

  // -------------------------------------------------
  // BUILD
  // -------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.address != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing
              ? "Edit Address"
              : "Add Address",
        ),
      ),

      body: SafeArea(
        child: Form(
          key: _formKey,

          child: ListView(
            padding: const EdgeInsets.all(20),

            children: [

              // -------------------------------------------------
              // ADDRESS TYPE
              // -------------------------------------------------

              const Text(
                "Address Type",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Wrap(
                spacing: 10,

                children: [
                  "Home",
                  "Office",
                  "Other",
                ]
                    .map(buildTitleChip)
                    .toList(),
              ),

              const SizedBox(height: 25),

              // -------------------------------------------------
              // PERSONAL DETAILS
              // -------------------------------------------------

              buildRequiredField(
                controller: _nameController,
                label: "Full Name",
              ),

              buildRequiredField(
                controller: _phoneController,
                label: "Phone Number",
                keyboard: TextInputType.phone,
              ),

              // -------------------------------------------------
              // ADDRESS LINE 1
              // REQUIRED
              // -------------------------------------------------

              buildRequiredField(
                controller: _line1Controller,
                label: "Address Line 1",
              ),

              // -------------------------------------------------
              // ADDRESS LINE 2
              // OPTIONAL
              // -------------------------------------------------

              buildOptionalField(
                controller: _line2Controller,
                label: "Address Line 2",
              ),

              // -------------------------------------------------
              // CITY
              // -------------------------------------------------

              buildRequiredField(
                controller: _cityController,
                label: "City",
              ),

              // -------------------------------------------------
              // STATE
              // -------------------------------------------------

              buildRequiredField(
                controller: _stateController,
                label: "State",
              ),

              // -------------------------------------------------
              // PINCODE
              // -------------------------------------------------

              buildRequiredField(
                controller: _pincodeController,
                label: "Pincode",
                keyboard: TextInputType.number,
              ),

              // -------------------------------------------------
              // DEFAULT ADDRESS
              // -------------------------------------------------

              SwitchListTile(
                contentPadding: EdgeInsets.zero,

                value: _isDefault,

                title: const Text(
                  "Make Default Address",
                ),

                onChanged: (value) {
                  setState(() {
                    _isDefault = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              // -------------------------------------------------
              // SAVE BUTTON
              // -------------------------------------------------

              SizedBox(
                height: 55,

                child: FilledButton(
                  onPressed: _saveAddress,

                  child: Text(
                    isEditing
                        ? "Update Address"
                        : "Save Address",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}