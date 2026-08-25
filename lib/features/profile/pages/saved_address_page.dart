import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/service/location/address_provider.dart';
import '../../cart/presentation/add_edit_address_page.dart';

class SavedAddressPage extends ConsumerWidget {
  const SavedAddressPage({super.key});

  // --------------------------------------------------
  // EDIT ADDRESS
  // --------------------------------------------------

  Future<void> _editAddress(
      BuildContext context,
      address,
      ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditAddressPage(
          address: address,
        ),
      ),
    );
  }

  // --------------------------------------------------
  // DELETE ADDRESS
  // --------------------------------------------------

  Future<void> _deleteAddress(
      BuildContext context,
      WidgetRef ref,
      String addressId,
      ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Address'),
          content: const Text(
            'Are you sure you want to delete this address?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('CANCEL'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('DELETE'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    await ref
        .read(addressProvider.notifier)
        .deleteAddress(addressId);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Address deleted successfully'),
        ),
      );
    }
  }

  // --------------------------------------------------
  // MAKE DEFAULT
  // --------------------------------------------------

  Future<void> _makeDefault(
      BuildContext context,
      WidgetRef ref,
      String addressId,
      ) async {
    await ref
        .read(addressProvider.notifier)
        .makeDefault(addressId);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Default address updated'),
        ),
      );
    }
  }

  // --------------------------------------------------
  // BUILD
  // --------------------------------------------------

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    // Watch all saved addresses
    final addresses = ref.watch(addressProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Addresses'),
      ),

      // ------------------------------------------------
      // ADD NEW ADDRESS BUTTON
      // ------------------------------------------------

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddEditAddressPage(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add New Address'),
      ),

      // ------------------------------------------------
      // ADDRESS LIST
      // ------------------------------------------------

      body: addresses.isEmpty
          ? _buildEmptyState(context)
          : ListView.builder(
        padding: const EdgeInsets.only(
          top: 12,
          left: 16,
          right: 16,
          bottom: 100,
        ),
        itemCount: addresses.length,
        itemBuilder: (context, index) {
          final address = addresses[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  // --------------------------------
                  // ADDRESS HEADER
                  // --------------------------------

                  Row(
                    children: [
                      Icon(
                        address.title == 'Home'
                            ? Icons.home_outlined
                            : address.title == 'Office'
                            ? Icons
                            .business_outlined
                            : Icons
                            .location_on_outlined,
                        color: Theme.of(context)
                            .primaryColor,
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          address.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                      ),

                      // DEFAULT BADGE
                      if (address.isDefault)
                        Container(
                          padding:
                          const EdgeInsets
                              .symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration:
                          BoxDecoration(
                            color: Colors
                                .green
                                .withValues(alpha: 0.1),
                            borderRadius:
                            BorderRadius
                                .circular(20),
                          ),
                          child: const Text(
                            'DEFAULT',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 11,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // --------------------------------
                  // PERSON DETAILS
                  // --------------------------------

                  Text(
                    address.fullName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    address.phone,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // --------------------------------
                  // FULL ADDRESS
                  // --------------------------------

                  Text(
                    address.fullAddress,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Divider(),

                  const SizedBox(height: 8),

                  // --------------------------------
                  // ACTIONS
                  // --------------------------------

                  Row(
                    children: [
                      // EDIT
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            _editAddress(
                              context,
                              address,
                            );
                          },
                          icon: const Icon(
                            Icons.edit_outlined,
                            size: 18,
                          ),
                          label: const Text('Edit'),
                        ),
                      ),

                      const SizedBox(width: 10),

                      // DELETE
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            _deleteAddress(
                              context,
                              ref,
                              address.id,
                            );
                          },
                          icon: const Icon(
                            Icons.delete_outline,
                            size: 18,
                          ),
                          label: const Text('Delete'),
                          style: OutlinedButton
                              .styleFrom(
                            foregroundColor:
                            Colors.red,
                            side:
                            const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // --------------------------------
                  // MAKE DEFAULT
                  // --------------------------------

                  if (!address.isDefault) ...[
                    const SizedBox(height: 8),

                    SizedBox(
                      width: double.infinity,
                      child: TextButton.icon(
                        onPressed: () {
                          _makeDefault(
                            context,
                            ref,
                            address.id,
                          );
                        },
                        icon: const Icon(
                          Icons
                              .check_circle_outline,
                        ),
                        label: const Text(
                          'Make Default Address',
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // --------------------------------------------------
  // EMPTY STATE
  // --------------------------------------------------

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),

            const SizedBox(height: 20),

            const Text(
              'No Addresses Saved',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Add a delivery address to make checkout faster.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 25),

            FilledButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    const AddEditAddressPage(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Address'),
            ),
          ],
        ),
      ),
    );
  }
}