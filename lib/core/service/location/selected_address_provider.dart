import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'address_model.dart';

class SelectedAddressNotifier extends Notifier<AddressModel?> {
  @override
  AddressModel? build() {
    return null;
  }

  void select(AddressModel address) {
    state = address;
  }

  void clear() {
    state = null;
  }
}

final selectedAddressProvider =
NotifierProvider<SelectedAddressNotifier, AddressModel?>(
  SelectedAddressNotifier.new,
);