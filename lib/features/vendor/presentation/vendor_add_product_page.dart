import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../domain/vendor_product_model.dart';
import 'vendor_dashboard_controller.dart';

class VendorAddProductPage extends ConsumerStatefulWidget {
  const VendorAddProductPage({super.key});

  @override
  ConsumerState<VendorAddProductPage> createState() => _VendorAddProductPageState();
}

class _VendorAddProductPageState extends ConsumerState<VendorAddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedCategory = 'Animal';
  bool _imageSelected = false;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descController.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      if (!_imageSelected) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an image')),
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        final newProduct = VendorProductModel(
          id: Random().nextInt(10000).toString(),
          name: _nameController.text.trim(),
          price: double.parse(_priceController.text.trim()),
          description: _descController.text.trim(),
          category: _selectedCategory,
          imageUrl: _selectedCategory == 'Animal' 
              ? 'https://images.unsplash.com/photo-1543466835-00a7907e9de1'
              : 'https://images.unsplash.com/photo-1576201836106-db1758fd1c97',
        );

        await ref.read(vendorDashboardControllerProvider.notifier).addProduct(newProduct);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product added successfully!')),
        );

        if (context.canPop()) context.pop();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add product: $e')),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Product'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Mock Image Picker
              GestureDetector(
                onTap: () {
                  setState(() => _imageSelected = true);
                },
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                  ),
                  child: _imageSelected 
                    ? const Center(child: Icon(Icons.check_circle, color: Colors.green, size: 48))
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.add_a_photo, color: Colors.grey, size: 32),
                          SizedBox(height: 8),
                          Text('Tap to select product photo', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                ),
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (v) => v!.isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Price (₹)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v!.isEmpty) return 'Price is required';
                  if (double.tryParse(v) == null) return 'Enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: const [
                  DropdownMenuItem(value: 'Animal', child: Text('Animal (Pets for sale)')),
                  DropdownMenuItem(value: 'Accessory', child: Text('Accessory (Food, Toys)')),
                ],
                onChanged: (v) {
                  if (v != null) {
                    setState(() => _selectedCategory = v);
                  }
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                maxLines: 4,
                validator: (v) => v!.isEmpty ? 'Description is required' : null,
              ),
              
              const SizedBox(height: 32),
              FilledButton(
                onPressed: _submit,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Publish Product', style: TextStyle(fontSize: 16)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
