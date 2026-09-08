import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/localization/language_provider.dart';
import '../theme/app_colors.dart';

class MainNavigationShell extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const MainNavigationShell({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = navigationShell.currentIndex;

    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          margin: const EdgeInsets.fromLTRB(14, 0, 14, 12),
          height: 74,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              // 1. Curved Emerald & Gold Floating Navigation Bar Base Container
              Container(
                height: 68,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF163820), // Dark Emerald Forest Green
                      Color(0xFF0F2B17),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(36),
                  border: Border.all(color: const Color(0xFFC5A059), width: 1.5), // Gold Stroke Border
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      // Left Decorative Leaf Flourish Icon
                      const Padding(
                        padding: EdgeInsets.only(left: 4, right: 2),
                        child: Icon(Icons.eco_rounded, color: Color(0x66C5A059), size: 16),
                      ),

                      // Tab 0: Home
                      Expanded(
                        child: _buildNavItem(
                          context: context,
                          index: 0,
                          currentIndex: currentIndex,
                          icon: Icons.home_outlined,
                          activeIcon: Icons.home_rounded,
                          label: ref.tr('home'),
                        ),
                      ),

                      // Tab 1: Machines
                      Expanded(
                        child: _buildNavItem(
                          context: context,
                          index: 1,
                          currentIndex: currentIndex,
                          icon: Icons.agriculture_outlined,
                          activeIcon: Icons.agriculture_rounded,
                          label: ref.tr('machines'),
                        ),
                      ),

                      // Spacer for Center Floating + Gold Button
                      const SizedBox(width: 58),

                      // Tab 3: Workers
                      Expanded(
                        child: _buildNavItem(
                          context: context,
                          index: 3,
                          currentIndex: currentIndex,
                          icon: Icons.groups_outlined,
                          activeIcon: Icons.groups_rounded,
                          label: ref.tr('workers'),
                        ),
                      ),

                      // Tab 4: History
                      Expanded(
                        child: _buildNavItem(
                          context: context,
                          index: 4,
                          currentIndex: currentIndex,
                          icon: Icons.receipt_long_outlined,
                          activeIcon: Icons.receipt_long_rounded,
                          label: ref.tr('my_orders'),
                        ),
                      ),

                      // Right Decorative Leaf Flourish Icon
                      const Padding(
                        padding: EdgeInsets.only(left: 2, right: 4),
                        child: Icon(Icons.eco_rounded, color: Color(0x66C5A059), size: 16),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Center Floating Gold Action Button (+)
              Positioned(
                top: -16,
                child: GestureDetector(
                  onTap: () => _showPostAdOptions(context),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF14361E),
                      border: Border.all(color: const Color(0xFFC5A059), width: 2), // Double Gold Ring
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFC5A059).withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFFF5DA88), // Glowing Gold Top
                              Color(0xFFC5A059), // Rich Gold Base
                            ],
                          ),
                        ),
                        child: const Icon(Icons.add, color: Colors.white, size: 28),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required int currentIndex,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isSelected = index == currentIndex;

    return GestureDetector(
      onTap: () {
        navigationShell.goBranch(
          index,
          initialLocation: index == currentIndex,
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF234B2C) : const Color(0xFF13321C),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFFC5A059) : Colors.transparent,
            width: 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFC5A059).withValues(alpha: 0.2),
                    blurRadius: 6,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? const Color(0xFFF3D577) : const Color(0xFFD5E0D8),
              size: 20,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? const Color(0xFFF3D577) : const Color(0xFFD5E0D8),
              ),
            ),
            if (isSelected) ...[
              const SizedBox(height: 2),
              Container(
                width: 14,
                height: 2.5,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3D577),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showPostAdOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'What would you like to post?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.warmDarkBrown),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFFFF3E0),
                  child: Icon(Icons.agriculture, color: Color(0xFF4A3525)),
                ),
                title: const Text('List Machine for Rent', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Add tractor, harvester or equipment for rental'),
                onTap: () {
                  Navigator.pop(ctx);
                  context.push('/machinery/add');
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFFFF3E0),
                  child: Icon(Icons.engineering, color: AppColors.accentGold),
                ),
                title: const Text('Register as Farm Worker / Driver', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Offer your agricultural skills and daily wage services'),
                onTap: () {
                  Navigator.pop(ctx);
                  context.push('/workers/register');
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE3F2FD),
                  child: Icon(Icons.storefront, color: Colors.blue),
                ),
                title: const Text('Sell Farm Produce / Items', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Post Arecanut, Pepper, Coffee, Paddy or supplies'),
                onTap: () {
                  Navigator.pop(ctx);
                  context.push('/marketplace/create');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
