import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../machinery/presentation/providers/machinery_provider.dart';
import '../../../workers/presentation/providers/worker_provider.dart';
import '../../../marketplace/presentation/providers/marketplace_provider.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final machinesAsync = ref.watch(machineryListProvider);
    final workersAsync = ref.watch(workerListProvider);
    final productsAsync = ref.watch(marketplaceProductsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('🛡️ Krushi Mithra Admin Panel'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Platform Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 14),

            // Metrics Cards Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _buildStatCard('Active Farmers', '1,420+', Icons.people_alt, AppColors.primaryGreen),
                _buildStatCard('Listed Machines', '${machinesAsync.value?.length ?? 4}', Icons.agriculture, AppColors.warning),
                _buildStatCard('Verified Workers', '${workersAsync.value?.length ?? 3}', Icons.engineering, AppColors.info),
                _buildStatCard('Market Products', '${productsAsync.value?.length ?? 6}', Icons.storefront, Colors.purple),
              ],
            ),
            const SizedBox(height: 24),

            // Worker Verification Section
            const Text(
              'Worker Profile Verification Requests',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            workersAsync.when(
              data: (workers) {
                return Column(
                  children: workers.map((w) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: CircleAvatar(backgroundImage: NetworkImage(w.profilePhoto)),
                        title: Text(w.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Skill: ${w.skills.first} • Rate: ${Formatters.currency(w.dailyRate)}/day'),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: w.isVerified ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            w.isVerified ? 'VERIFIED' : 'PENDING',
                            style: TextStyle(
                              color: w.isVerified ? AppColors.success : AppColors.warning,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Text('Error: $err'),
            ),
            const SizedBox(height: 24),

            // Machinery Quality Control
            const Text(
              'Machinery Verification & Safety Checks',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            machinesAsync.when(
              data: (machines) {
                return Column(
                  children: machines.map((m) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: Image.network(m.images.first, width: 50, height: 50, fit: BoxFit.cover),
                        title: Text(m.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        subtitle: Text('Owner: ${m.ownerName} • ${m.location}'),
                        trailing: const Icon(Icons.check_circle_outline_rounded, color: AppColors.success),
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Text('Error: $err'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String count, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                Text(
                  count,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
