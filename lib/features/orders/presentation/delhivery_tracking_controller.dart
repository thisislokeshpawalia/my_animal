import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/delhivery_tracking_model.dart';

final delhiveryTrackingControllerProvider =
    StateNotifierProvider<DelhiveryTrackingController, AsyncValue<DelhiveryTrackingModel?>>((ref) {
  return DelhiveryTrackingController();
});

class DelhiveryTrackingController extends StateNotifier<AsyncValue<DelhiveryTrackingModel?>> {
  DelhiveryTrackingController() : super(const AsyncValue.data(null));

  Future<void> fetchTrackingData(String waybill) async {
    state = const AsyncValue.loading();

    try {
      // Simulate network request to Delhivery API
      await Future.delayed(const Duration(seconds: 2));

      if (waybill.isEmpty) {
        throw Exception("Please enter a valid Waybill number");
      }

      // Mock Delhivery Response
      final mockData = DelhiveryTrackingModel(
        waybill: waybill,
        currentStatus: "In Transit",
        origin: "New Delhi, DL",
        destination: "Mumbai, MH",
        events: [
          DelhiveryTrackingEvent(
            status: "Manifested",
            location: "New Delhi",
            timestamp: DateTime.now().subtract(const Duration(days: 2)),
          ),
          DelhiveryTrackingEvent(
            status: "Picked Up",
            location: "New Delhi",
            timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 10)),
          ),
          DelhiveryTrackingEvent(
            status: "Dispatched to Hub",
            location: "Gurgaon Facility",
            timestamp: DateTime.now().subtract(const Duration(hours: 15)),
          ),
          DelhiveryTrackingEvent(
            status: "In Transit",
            location: "En route to Mumbai",
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          ),
        ],
      );

      state = AsyncValue.data(mockData);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
