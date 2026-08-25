// lib/features/cart/presentation/widgets/address_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/service/location/address_provider.dart';
import '../../../bottom_sheet/location_bottom_sheet.dart';
import '../../provider/checkout_provider.dart';

class AddressSection extends ConsumerWidget {
  const AddressSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addresses = ref.watch(addressProvider);
    final selected = ref.watch(selectedCheckoutAddressProvider);

    // Logic to determine which address to show
    final display = selected ?? (addresses.isEmpty
        ? null
        : addresses.firstWhere((e) => e.isDefault, orElse: () => addresses.first));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              Icon(Icons.location_on, color: Theme.of(context).primaryColor, size: 20),
              const SizedBox(width: 8),
              Text(
                "Delivery Address",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Address Content
          if (display == null)
            const Text("No delivery address selected")
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(display.fullName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    if (display.isDefault) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(4)),
                        child: Text("Default", style: TextStyle(color: Colors.green.shade700, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ]
                  ],
                ),
                const SizedBox(height: 4),
                Text(display.phone, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                const SizedBox(height: 4),
                Text(display.fullAddress, style: const TextStyle(fontSize: 14, height: 1.4)),
              ],
            ),

          const SizedBox(height: 16),

          // Action Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                final result = await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => const LocationBottomSheet()
                );
                if (result != null) {
                  ref.read(selectedCheckoutAddressProvider.notifier).state = result;
                }
              },
              icon: const Icon(Icons.edit_location_alt_outlined),
              label: Text(display == null ? "Add Address" : "Change Address"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
                side: BorderSide(color: Theme.of(context).primaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}