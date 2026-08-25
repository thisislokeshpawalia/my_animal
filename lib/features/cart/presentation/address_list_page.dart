import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/service/location/address_provider.dart';
import '../widgets/address_card.dart';
import 'add_edit_address_page.dart';

class AddressListPage extends ConsumerWidget {
  const AddressListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addresses = ref.watch(addressProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Addresses"),
      ),

      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add_location_alt),
        label: const Text("Add Address"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddEditAddressPage(),
            ),
          );
        },
      ),

      body: addresses.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off_outlined,
              size: 90,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 20),
            const Text(
              "No Address Added",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Add your first delivery address.",
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 30),
            FilledButton.icon(
              icon: const Icon(Icons.add),
              label: const Text("Add Address"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    const AddEditAddressPage(),
                  ),
                );
              },
            )
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 90,
        ),
        itemCount: addresses.length,
        itemBuilder: (context, index) {
          return AddressCard(
            address: addresses[index],
          );
        },
      ),
    );
  }
}