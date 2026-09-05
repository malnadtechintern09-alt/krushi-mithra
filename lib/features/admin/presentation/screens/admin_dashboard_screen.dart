import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_image.dart';
import '../../../machinery/presentation/providers/machinery_provider.dart';
import '../../../workers/presentation/providers/worker_provider.dart';
import '../../../marketplace/presentation/providers/marketplace_provider.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  Future<void> _openWebAdminPanel() async {
    final Uri url = Uri.parse('http://localhost:8080/admin/');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

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
            // WEB ADMIN PANEL LAUNCH BANNER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryGreenDark, AppColors.primaryGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.web, color: Colors.white, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Full Web Admin Console',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Access 20 management modules, real-time machine prices, availability controls, and mobile content manager at http://localhost:8080/admin/',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _openWebAdminPanel,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.warning,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.open_in_new, size: 16),
                    label: const Text('Open Web Admin Panel (localhost:8080)'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

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
                _buildStatCard('Active Farmers', '12,450+', Icons.people_alt, AppColors.primaryGreen),
                _buildStatCard('Listed Machines', '${machinesAsync.value?.length ?? 5}', Icons.agriculture, AppColors.warning),
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
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: AppImage(
                            url: m.images.first,
                            width: 50,
                            height: 50,
                          ),
                        ),
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
