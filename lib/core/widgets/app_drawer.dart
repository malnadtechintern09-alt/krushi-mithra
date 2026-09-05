import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_colors.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).value;

    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF4A3525)),
            accountName: Text(
              user?.name ?? 'bharath poojary',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            accountEmail: Text(user?.email ?? 'bharath@krushimithra.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: AppColors.warmAmber,
              child: Text(
                (user?.name ?? 'B')[0].toUpperCase(),
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF3D2B1F)),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined, color: AppColors.warmDarkBrown),
            title: const Text('Home', style: TextStyle(fontWeight: FontWeight.w600)),
            onTap: () {
              Navigator.pop(context);
              context.go('/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.agriculture_outlined, color: AppColors.warmDarkBrown),
            title: const Text('Rent Machinery', style: TextStyle(fontWeight: FontWeight.w600)),
            onTap: () {
              Navigator.pop(context);
              context.go('/machinery');
            },
          ),
          ListTile(
            leading: const Icon(Icons.engineering_outlined, color: AppColors.warmDarkBrown),
            title: const Text('Hire Farm Workers', style: TextStyle(fontWeight: FontWeight.w600)),
            onTap: () {
              Navigator.pop(context);
              context.go('/workers');
            },
          ),
          ListTile(
            leading: const Icon(Icons.storefront_outlined, color: AppColors.warmDarkBrown),
            title: const Text('Produce Marketplace', style: TextStyle(fontWeight: FontWeight.w600)),
            onTap: () {
              Navigator.pop(context);
              context.push('/marketplace');
            },
          ),
          ListTile(
            leading: const Icon(Icons.local_florist_outlined, color: AppColors.warmDarkBrown),
            title: const Text('Agro Store', style: TextStyle(fontWeight: FontWeight.w600)),
            onTap: () {
              Navigator.pop(context);
              context.push('/agro-store');
            },
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long_outlined, color: AppColors.warmDarkBrown),
            title: const Text('My Bookings & Orders', style: TextStyle(fontWeight: FontWeight.w600)),
            onTap: () {
              Navigator.pop(context);
              context.push('/my-orders');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.admin_panel_settings_outlined, color: AppColors.warmDarkBrown),
            title: const Text('Admin Dashboard', style: TextStyle(fontWeight: FontWeight.w600)),
            onTap: () {
              Navigator.pop(context);
              context.push('/admin');
            },
          ),
        ],
      ),
    );
  }
}
