import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/vet_controller.dart';
import '../../../app/router/app_routes.dart';

class VetListPage extends ConsumerWidget {
  const VetListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vetsAsync = ref.watch(vetsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Veterinarians'),
        centerTitle: true,
      ),
      body: vetsAsync.when(
        data: (vets) {
          if (vets.isEmpty) {
            return const Center(child: Text("No veterinarians available right now."));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: vets.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final vet = vets[index];
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: vet.imageUrl.isNotEmpty 
                            ? NetworkImage(vet.imageUrl) 
                            : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(vet.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(vet.specialty, style: TextStyle(color: Colors.grey.shade700)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Text(vet.rating.toString()),
                                const SizedBox(width: 12),
                                const Icon(Icons.work, color: Colors.blue, size: 16),
                                const SizedBox(width: 4),
                                Text('${vet.experienceYears} yrs'),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('\$${vet.consultationFee.toStringAsFixed(2)} / consultation', 
                              style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.green)),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Pass vet id to booking page
                          context.push(AppRoutes.vetBooking, extra: vet);
                        },
                        icon: const Icon(Icons.arrow_forward_ios),
                        color: Theme.of(context).primaryColor,
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
