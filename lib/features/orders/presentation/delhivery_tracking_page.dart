import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'delhivery_tracking_controller.dart';

class DelhiveryTrackingPage extends ConsumerStatefulWidget {
  const DelhiveryTrackingPage({super.key});

  @override
  ConsumerState<DelhiveryTrackingPage> createState() => _DelhiveryTrackingPageState();
}

class _DelhiveryTrackingPageState extends ConsumerState<DelhiveryTrackingPage> {
  final _waybillController = TextEditingController();

  @override
  void dispose() {
    _waybillController.dispose();
    super.dispose();
  }

  void _track() {
    ref.read(delhiveryTrackingControllerProvider.notifier)
       .fetchTrackingData(_waybillController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final trackingState = ref.watch(delhiveryTrackingControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Delhivery Tracking'),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.red.shade50,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _waybillController,
                    decoration: InputDecoration(
                      hintText: 'Enter Waybill/AWB number',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _track,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Track'),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: trackingState.when(
              loading: () => const Center(child: CircularProgressIndicator(color: Colors.red)),
              error: (error, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(error.toString(), textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
                )
              ),
              data: (data) {
                if (data == null) {
                  return const Center(
                    child: Text('Enter a waybill number to track your package', style: TextStyle(color: Colors.grey)),
                  );
                }

                return ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))
                        ]
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('WAYBILL: ${data.waybill}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.flight_takeoff, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(data.origin, style: const TextStyle(color: Colors.grey)),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
                              ),
                              const Icon(Icons.flight_land, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(data.destination, style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Current Status:', style: TextStyle(color: Colors.grey)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(data.currentStatus, style: TextStyle(color: Colors.orange.shade800, fontWeight: FontWeight.bold)),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text('Tracking History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    ...data.events.map((event) => _buildTimelineTile(event)).toList(),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTimelineTile(dynamic event) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.red.shade700,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 2,
                height: 40,
                color: Colors.red.shade200,
              )
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.status, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(event.location, style: TextStyle(color: Colors.grey.shade700)),
                const SizedBox(height: 4),
                Text(
                  DateFormat('dd MMM yyyy, hh:mm a').format(event.timestamp),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
