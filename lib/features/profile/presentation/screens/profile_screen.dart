import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/config/constants.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(authProvider);
    final user = userAsync.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Krushi Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // User Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 46,
                          backgroundImage: NetworkImage(
                            user?.profilePhoto ??
                                'https://images.unsplash.com/photo-1595273670150-bd0c3c392e46?w=400',
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: AppColors.primaryGreen,
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Camera profile upload triggered')),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      user?.name ?? 'Ramesh Gowda',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(height: 4),
                    Text(user?.phone ?? '+91 9876543210', style: const TextStyle(color: AppColors.textSecondary)),
                    const SizedBox(height: 4),
                    Text('📍 ${user?.address ?? 'Green Farm House, Thirthahalli Road, Shivamogga'}',
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 14),

                    // Role Chip & Role Switcher Dropdown
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.chipBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Active Platform Role:',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 6),
                          DropdownButton<String>(
                            value: user?.role ?? AppConstants.roleFarmer,
                            isExpanded: true,
                            underline: const SizedBox(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: AppColors.primaryGreen,
                            ),
                            items: AppConstants.allRoles.map((role) {
                              return DropdownMenuItem(
                                value: role,
                                child: Center(child: Text(role)),
                              );
                            }).toList(),
                            onChanged: (newRole) {
                              if (newRole != null) {
                                ref.read(authProvider.notifier).switchRole(newRole);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Role switched to $newRole!'),
                                    backgroundColor: AppColors.primaryGreen,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // User Specific Quick Actions
            ListTile(
              leading: const Icon(Icons.agriculture_rounded, color: AppColors.primaryGreen),
              title: const Text('List My Machine for Rent'),
              subtitle: const Text('Earn income by renting your tractor or harvester'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push('/machinery/add'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.storefront_rounded, color: AppColors.primaryGreen),
              title: const Text('Post Produce for Sale'),
              subtitle: const Text('Sell arecanut, pepper, coffee directly to buyers'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push('/marketplace/create'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.engineering_rounded, color: AppColors.primaryGreen),
              title: const Text('Register as Farm Worker / Operator'),
              subtitle: const Text('Find daily agricultural field work'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push('/workers/register'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings_rounded, color: AppColors.primaryGreen),
              title: const Text('Admin Dashboard Portal'),
              subtitle: const Text('Manage platform verification & users'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push('/admin'),
            ),
            const Divider(),

            const SizedBox(height: 20),

            CustomButton(
              text: 'Log Out',
              isOutlined: true,
              backgroundColor: AppColors.error,
              textColor: AppColors.error,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged out of Krushi Mithra')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
