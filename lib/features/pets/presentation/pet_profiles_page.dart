import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/pet_controller.dart';

class PetProfilesPage extends ConsumerWidget {
  const PetProfilesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petsState = ref.watch(petControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Pets')),
      body: petsState.when(
        data: (pets) {
          if (pets.isEmpty) {
            return const Center(child: Text("You haven't added any pets yet."));
          }
          return ListView.builder(
            itemCount: pets.length,
            itemBuilder: (context, index) {
              final pet = pets[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Icon(Icons.pets, color: Theme.of(context).primaryColor),
                ),
                title: Text(pet.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${pet.species} • ${pet.breed} • ${pet.age} yrs'),
                isThreeLine: true,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddPetModal(context, ref),
        icon: const Icon(Icons.add),
        label: const Text("Add Pet"),
      ),
    );
  }

  void _showAddPetModal(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final speciesController = TextEditingController();
    final breedController = TextEditingController();
    final ageController = TextEditingController();
    final notesController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 16, right: 16, top: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Add a New Pet", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextField(controller: nameController, decoration: const InputDecoration(labelText: "Pet Name")),
              const SizedBox(height: 12),
              TextField(controller: speciesController, decoration: const InputDecoration(labelText: "Species (e.g., Dog, Cat)")),
              const SizedBox(height: 12),
              TextField(controller: breedController, decoration: const InputDecoration(labelText: "Breed")),
              const SizedBox(height: 12),
              TextField(controller: ageController, decoration: const InputDecoration(labelText: "Age (Years)"), keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              TextField(controller: notesController, decoration: const InputDecoration(labelText: "Health Notes")),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    ref.read(petControllerProvider.notifier).addPet(
                      nameController.text,
                      speciesController.text,
                      breedController.text,
                      int.tryParse(ageController.text) ?? 0,
                      notesController.text,
                    );
                    Navigator.pop(ctx);
                  },
                  child: const Text("Save Pet"),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
