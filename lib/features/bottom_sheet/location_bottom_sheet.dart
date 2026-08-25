import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/service/location/address_model.dart';
import '../../../core/service/location/address_provider.dart';
import '../cart/presentation/add_edit_address_page.dart';
import '../cart/provider/location_provider.dart';

class LocationBottomSheet extends ConsumerWidget {
  const LocationBottomSheet({super.key});

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    // -------------------------------------------------
    // SAVED ADDRESSES
    // -------------------------------------------------

    final addresses = ref.watch(addressProvider);

    // -------------------------------------------------
    // CURRENT LOCATION STATE
    // -------------------------------------------------

    final locationState =
    ref.watch(locationNotifierProvider);

    // -------------------------------------------------
    // LISTEN FOR LOCATION RESULT
    // -------------------------------------------------

    ref.listen<AsyncValue>(
      locationNotifierProvider,
          (previous, next) async {

        // ---------------------------------------------
        // LOCATION SUCCESS
        // ---------------------------------------------

        next.when(
          data: (address) async {

            if (address == null) {
              return;
            }

            // Only react when the state changes
            // from loading -> success.
            if (previous is AsyncLoading) {

              // ---------------------------------------
              // CLOSE BOTTOM SHEET
              // ---------------------------------------

              Navigator.pop(context);

              // ---------------------------------------
              // OPEN ADD ADDRESS PAGE
              // ---------------------------------------

              final result =
              await Navigator.push<AddressModel?>(
                context,

                MaterialPageRoute(
                  builder: (_) =>
                      AddEditAddressPage(
                        prefilledAddress: address,
                      ),
                ),
              );

              // ---------------------------------------
              // ADDRESS SAVED
              // ---------------------------------------

              if (result != null) {
                // At this point the AddressProvider
                // has already been updated by
                // AddEditAddressPage.
                //
                // The result can be used by the
                // calling page if required.
              }
            }
          },

          // ---------------------------------------------
          // LOCATION ERROR
          // ---------------------------------------------

          error: (error, stack) {

            if (previous is AsyncLoading) {

              ScaffoldMessenger.of(context)
                  .showSnackBar(
                SnackBar(
                  content: Text(
                    "Unable to get your location: $error",
                  ),
                ),
              );
            }
          },

          // ---------------------------------------------
          // LOCATION LOADING
          // ---------------------------------------------

          loading: () {},
        );
      },
    );

    // -------------------------------------------------
    // BOTTOM SHEET
    // -------------------------------------------------

    return DraggableScrollableSheet(
      expand: false,

      initialChildSize: 0.65,

      minChildSize: 0.45,

      maxChildSize: 0.9,

      builder: (
          context,
          scrollController,
          ) {
        return Column(
          children: [

            const SizedBox(height: 10),

            // -------------------------------------------------
            // DRAG HANDLE
            // -------------------------------------------------

            Container(
              width: 45,
              height: 5,

              decoration: BoxDecoration(
                color: Colors.grey.shade400,

                borderRadius:
                BorderRadius.circular(20),
              ),
            ),

            const SizedBox(height: 20),

            // -------------------------------------------------
            // TITLE
            // -------------------------------------------------

            const Text(
              "Select Delivery Address",

              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // -------------------------------------------------
            // CURRENT LOCATION
            // -------------------------------------------------

            ListTile(
              leading: const CircleAvatar(
                child: Icon(
                  Icons.my_location,
                ),
              ),

              title: const Text(
                "Use Current Location",

                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              subtitle: locationState.isLoading
                  ? const Text(
                "Detecting address...",

                style: TextStyle(
                  color: Colors.blue,
                ),
              )
                  : const Text(
                "Automatically detect your address",
              ),

              trailing: locationState.isLoading
                  ? const SizedBox(
                width: 22,
                height: 22,

                child:
                CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
                  : null,

              onTap: locationState.isLoading
                  ? null
                  : () {

                // Start GPS location
                // detection.
                ref
                    .read(
                  locationNotifierProvider
                      .notifier,
                )
                    .fetchCurrentLocation();
              },
            ),

            const Divider(),

            // -------------------------------------------------
            // SAVED ADDRESSES
            // -------------------------------------------------

            Expanded(
              child: addresses.isEmpty

                  ? const Center(
                child: Text(
                  "No Saved Addresses",
                ),
              )

                  : ListView.builder(
                controller:
                scrollController,

                itemCount:
                addresses.length,

                itemBuilder:
                    (context, index) {

                  final address =
                  addresses[index];

                  return Card(
                    margin:
                    const EdgeInsets
                        .symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),

                    child: ListTile(

                      leading: Icon(
                        address.title ==
                            "Home"
                            ? Icons.home_outlined
                            : address.title ==
                            "Office"
                            ? Icons
                            .business_outlined
                            : Icons
                            .location_on_outlined,
                      ),

                      title: Text(
                        address.title,

                        style:
                        const TextStyle(
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      subtitle: Text(
                        address.fullAddress,
                      ),

                      trailing:
                      address.isDefault
                          ? const Icon(
                        Icons
                            .check_circle,
                        color:
                        Colors.green,
                      )
                          : null,

                      onTap: () {

                        // Return selected
                        // saved address.
                        Navigator.pop(
                          context,
                          address,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}


