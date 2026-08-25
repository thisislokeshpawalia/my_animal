import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/service/location/address_model.dart';
import '../../../core/service/location/location_service.dart';

// 1. Keep the service provider as is
final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

// 2. Use a Notifier to manage the "Loading", "Error", and "Success" states
final locationNotifierProvider = NotifierProvider<LocationNotifier, AsyncValue<AddressModel?>>(() {
  return LocationNotifier();
});

class LocationNotifier extends Notifier<AsyncValue<AddressModel?>> {
  @override
  AsyncValue<AddressModel?> build() => const AsyncValue.data(null);

  Future<void> fetchCurrentLocation() async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(locationServiceProvider);
      final address = await service.getCurrentLocationAddress();
      state = AsyncValue.data(address);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}