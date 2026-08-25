import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router/app_routes.dart';

class VendorDashboardPage extends StatelessWidget {
  const VendorDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendor Dashboard'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Mock Analytics Cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard('Total Earnings', '₹15,200', Icons.account_balance_wallet, Colors.green),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard('Total Orders', '24', Icons.shopping_bag, Colors.blue),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard('Active Products', '12', Icons.pets, Colors.orange),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard('Page Views', '1.2k', Icons.visibility, Colors.purple),
              ),
            ],
          ),
          const SizedBox(height: 32),
          
          // Quick Actions
          const Text(
            'Store Management',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.add, color: Colors.white),
            ),
            title: const Text('Add New Product'),
            subtitle: const Text('Upload a new animal or accessory'),
            trailing: const Icon(Icons.chevron_right),
            tileColor: Colors.grey.shade50,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onTap: () => context.push(AppRoutes.vendorAddProduct),
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade700,
              child: const Icon(Icons.inventory, color: Colors.white),
            ),
            title: const Text('Manage Products'),
            subtitle: const Text('View and edit your listings'),
            trailing: const Icon(Icons.chevron_right),
            tileColor: Colors.grey.shade50,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onTap: () => context.push(AppRoutes.vendorProducts),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(color: color.withOpacity(0.8), fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
