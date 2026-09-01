import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

class MainNavigationShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainNavigationShell({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        selectedItemColor: AppColors.primaryGreen,
        unselectedItemColor: AppColors.textMuted,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        onTap: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            activeIcon: Icon(Icons.home_rounded, color: AppColors.primaryGreen),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.agriculture_rounded),
            activeIcon: Icon(Icons.agriculture_rounded, color: AppColors.primaryGreen),
            label: 'Machinery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.engineering_rounded),
            activeIcon: Icon(Icons.engineering_rounded, color: AppColors.primaryGreen),
            label: 'Workers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront_rounded),
            activeIcon: Icon(Icons.storefront_rounded, color: AppColors.primaryGreen),
            label: 'Marketplace',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_florist_rounded),
            activeIcon: Icon(Icons.local_florist_rounded, color: AppColors.primaryGreen),
            label: 'Agro Store',
          ),
        ],
      ),
    );
  }
}
