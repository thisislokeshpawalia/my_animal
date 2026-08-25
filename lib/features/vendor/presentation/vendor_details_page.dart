import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'vendor_registration_controller.dart';

class VendorDetailsPage extends ConsumerWidget {
  const VendorDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(vendorRegistrationControllerProvider);
    final model = state.model;

    if (model == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Vendor Details')),
        body: const Center(child: Text('No details available.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Vendor Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            tooltip: 'Logout / Reset Vendor Status',
            onPressed: () {
              // Reset the vendor status so the user can register again
              ref.read(vendorRegistrationControllerProvider.notifier).resetVendor();
              // Navigate back to the profile page
              if (context.canPop()) {
                context.pop();
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildDetailCard(
            title: 'Business Info',
            children: [
              _buildRow('Business Name', model.vendorName),
              _buildRow('Phone', model.phone),
              _buildRow('Email', model.email),
              _buildRow('Address', model.address),
              _buildRow('Pincode', model.pincode),
            ],
          ),
          const SizedBox(height: 16),
          _buildDetailCard(
            title: 'Identity & Tax',
            children: [
              _buildRow('PAN Number', model.panNumber),
              _buildRow('GST Number', model.gstNumber),
              _buildRow('Aadhaar Number', model.aadhaarNumber),
            ],
          ),
          const SizedBox(height: 16),
          _buildDetailCard(
            title: 'Bank Details',
            children: [
              _buildRow('Bank Account', model.bankAccountNumber),
              _buildRow('IFSC Code', model.ifscCode),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard({required String title, required List<Widget> children}) {
    return Card(
      elevation: 0,
      color: Colors.grey.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green, // match theme
              ),
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
