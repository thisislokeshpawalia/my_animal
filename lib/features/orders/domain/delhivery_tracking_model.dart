class DelhiveryTrackingEvent {
  final String status;
  final String location;
  final DateTime timestamp;

  DelhiveryTrackingEvent({
    required this.status,
    required this.location,
    required this.timestamp,
  });
}

class DelhiveryTrackingModel {
  final String waybill;
  final String currentStatus;
  final String origin;
  final String destination;
  final List<DelhiveryTrackingEvent> events;

  DelhiveryTrackingModel({
    required this.waybill,
    required this.currentStatus,
    required this.origin,
    required this.destination,
    required this.events,
  });
}
