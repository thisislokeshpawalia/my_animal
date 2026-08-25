import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/service/location/address_model.dart';
import '../../../../core/service/location/address_provider.dart';
import '../presentation/add_edit_address_page.dart';

class AddressCard extends ConsumerWidget {
  final AddressModel address;

  const AddressCard({
    super.key,
    required this.address,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Header
            Row(
              children: [

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    address.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const Spacer(),

                if (address.isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "DEFAULT",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            Text(
              address.fullName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              address.phone,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              address.fullAddress,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [

                if (!address.isDefault)
                  OutlinedButton.icon(
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text("Default"),
                    onPressed: () {
                      ref
                          .read(addressProvider.notifier)
                          .makeDefault(address.id);
                    },
                  ),

                const Spacer(),

                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddEditAddressPage(
                          address: address,
                        ),
                      ),
                    );
                  },
                ),

                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () async {

                    final shouldDelete =
                        await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text(
                                "Delete Address"),
                            content: const Text(
                              "Are you sure you want to delete this address?",
                            ),
                            actions: [

                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(
                                        context, false),
                                child:
                                const Text("Cancel"),
                              ),

                              FilledButton(
                                onPressed: () =>
                                    Navigator.pop(
                                        context, true),
                                child:
                                const Text("Delete"),
                              ),
                            ],
                          ),
                        ) ??
                            false;

                    if (shouldDelete) {
                      ref
                          .read(addressProvider.notifier)
                          .deleteAddress(address.id);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}