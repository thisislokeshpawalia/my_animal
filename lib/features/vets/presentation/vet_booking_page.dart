import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../pets/providers/pet_controller.dart';
import '../providers/vet_controller.dart';

class VetBookingPage extends ConsumerStatefulWidget {
  const VetBookingPage({super.key});

  @override
  ConsumerState<VetBookingPage> createState() => _VetBookingPageState();
}

class _VetBookingPageState extends ConsumerState<VetBookingPage> {
  String? selectedPetId;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  Widget build(BuildContext context) {
    final petsState = ref.watch(petControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Book Vet Consultation')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Select Pet", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            petsState.when(
              data: (pets) {
                if (pets.isEmpty) return const Text("Please add a pet in 'My Pets' first.");
                return DropdownButtonFormField<String>(
                  value: selectedPetId,
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                  hint: const Text("Choose your pet"),
                  items: pets.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name))).toList(),
                  onChanged: (val) => setState(() => selectedPetId = val),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, s) => Text('Error loading pets: $e'),
            ),
            const SizedBox(height: 24),

            const Text("Select Date & Time", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().add(const Duration(days: 1)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 30)),
                      );
                      if (date != null) setState(() => selectedDate = date);
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: Text(selectedDate == null ? "Select Date" : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) setState(() => selectedTime = time);
                    },
                    icon: const Icon(Icons.access_time),
                    label: Text(selectedTime == null ? "Select Time" : selectedTime!.format(context)),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: (selectedPetId != null && selectedDate != null && selectedTime != null)
                    ? () {
                        final dateTime = DateTime(
                          selectedDate!.year, selectedDate!.month, selectedDate!.day,
                          selectedTime!.hour, selectedTime!.minute,
                        );
                        // Using a Mock Vet ID for now since we don't have a vet selection UI yet
                        ref.read(vetControllerProvider.notifier).bookConsultation(
                          selectedPetId!, "mock_vet_123", dateTime,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Consultation Booked!")));
                        Navigator.pop(context);
                      }
                    : null,
                child: const Text("Confirm Booking", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
