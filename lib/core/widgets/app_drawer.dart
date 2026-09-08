import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../utils/app_share_helper.dart';
import 'notifications_modal.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../localization/language_provider.dart';
import '../localization/app_translations.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).value;
    final currentRoute = GoRouterState.of(context).matchedLocation;

    final userName = user?.name ?? 'bharath poojary';
    final userEmail = user?.email ?? 'bharath.poojary@krushimithra.com';
    final userPhone = user?.phone ?? '+91 89040 89051';
    final userRole = user?.role ?? 'Farmer';
    final firstLetter = userName.isNotEmpty ? userName[0].toUpperCase() : 'B';

    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // 1. TOP BRANDED HEADER WITH GREEN FARM ILLUSTRATION & LEAF BADGE
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 48, 20, 20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF13381B), Color(0xFF1E5631), Color(0xFF2E7D32)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(28),
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar with Leaf Badge
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 34,
                      backgroundColor: const Color(0xFFF1F8E9),
                      child: Text(
                        firstLetter,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E5631),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.eco_rounded,
                          size: 14,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  userEmail,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          // 2. SCROLLABLE MENU ITEMS LIST
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              children: [
                // Core Modules Group
                _buildNavItem(
                  context: context,
                  icon: Icons.home_rounded,
                  iconBg: const Color(0xFFE8F5E9),
                  iconColor: const Color(0xFF1E5631),
                  title: ref.tr('home'),
                  subtitle: 'Dashboard & Overview',
                  isActive: currentRoute == '/' || currentRoute.isEmpty,
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/');
                  },
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.agriculture_rounded,
                  iconBg: const Color(0xFFEAF6EC),
                  iconColor: const Color(0xFF2E7D32),
                  title: ref.tr('rent_machinery'),
                  subtitle: 'Tractor, Harvester & more',
                  isActive: currentRoute.startsWith('/machinery'),
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/machinery');
                  },
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.engineering_rounded,
                  iconBg: const Color(0xFFF0F4C3),
                  iconColor: const Color(0xFF558B2F),
                  title: ref.tr('hire_workers'),
                  subtitle: 'Find skilled farm workers',
                  isActive: currentRoute.startsWith('/workers'),
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/workers');
                  },
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.shopping_bag_rounded,
                  iconBg: const Color(0xFFFFF3E0),
                  iconColor: const Color(0xFFE65100),
                  title: ref.tr('crop_marketplace'),
                  subtitle: 'Buy & sell farm produce',
                  isActive: currentRoute.startsWith('/marketplace'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/marketplace');
                  },
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.local_florist_rounded,
                  iconBg: const Color(0xFFE8F5E9),
                  iconColor: const Color(0xFF1E5631),
                  title: ref.tr('agro_store'),
                  subtitle: 'Seeds, Fertilizers & Pesticides',
                  isActive: currentRoute.startsWith('/agro-store'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/agro-store');
                  },
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.receipt_long_rounded,
                  iconBg: const Color(0xFFE3F2FD),
                  iconColor: const Color(0xFF1565C0),
                  title: ref.tr('my_orders'),
                  subtitle: 'Track your bookings & orders',
                  isActive: currentRoute.startsWith('/my-orders'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/my-orders');
                  },
                ),

                const SizedBox(height: 12),
                
                // Section Header
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Text(
                    'MORE',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2E7D32),
                      letterSpacing: 1.2,
                    ),
                  ),
                ),

                // More Menu Section
                _buildNavItem(
                  context: context,
                  icon: Icons.account_balance_wallet_rounded,
                  iconBg: const Color(0xFFF3E5F5),
                  iconColor: const Color(0xFF7B1FA2),
                  title: 'Payments & Wallet',
                  subtitle: 'Manage payments & wallet',
                  showChevron: true,
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/my-orders');
                  },
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.notifications_rounded,
                  iconBg: const Color(0xFFFFE0B2),
                  iconColor: const Color(0xFFE65100),
                  title: 'Notifications',
                  subtitle: 'Alerts & Updates',
                  badgeCount: '3',
                  showChevron: true,
                  onTap: () {
                    Navigator.pop(context);
                    NotificationsModalSheet.show(context);
                  },
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.star_rounded,
                  iconBg: const Color(0xFFFFF9C4),
                  iconColor: const Color(0xFFF57F17),
                  title: 'My Reviews',
                  subtitle: 'Reviews & Ratings',
                  showChevron: true,
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/my-orders');
                  },
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.headset_mic_rounded,
                  iconBg: const Color(0xFFE0F2F1),
                  iconColor: const Color(0xFF00695C),
                  title: 'Help & Support',
                  subtitle: 'FAQs & Support Center',
                  showChevron: true,
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Krushi Mithra 24x7 Support Helpline: 1800-999-000')),
                    );
                  },
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.share_rounded,
                  iconBg: const Color(0xFFE8F5E9),
                  iconColor: const Color(0xFF2E7D32),
                  title: 'Share Krushi Mithra App',
                  subtitle: 'Invite farmers & friends on WhatsApp',
                  showChevron: true,
                  onTap: () {
                    Navigator.pop(context);
                    AppShareHelper.showShareAppBottomSheet(context);
                  },
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.settings_rounded,
                  iconBg: const Color(0xFFECEFF1),
                  iconColor: const Color(0xFF455A64),
                  title: 'Settings',
                  subtitle: 'App Preferences',
                  showChevron: true,
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/profile');
                  },
                ),
              ],
            ),
          ),

          // 3. BOTTOM USER PROFILE & ACCOUNT FOOTER CARD
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFF0F4F1))),
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/profile');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF7F0),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFD4EBD9)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color(0xFF2E7D32),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'User Profile & Account',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E5631),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '$userRole • $userPhone',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF5A7561),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: Color(0xFF2E7D32),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Bottom Farm Landscape Line Art
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.nature_people_rounded, size: 14, color: Color(0xFFA5D6A7)),
                    SizedBox(width: 4),
                    Icon(Icons.agriculture_rounded, size: 14, color: Color(0xFFA5D6A7)),
                    SizedBox(width: 4),
                    Icon(Icons.grass_rounded, size: 14, color: Color(0xFFA5D6A7)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper to build consistent custom nav items matching the design ---
  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isActive = false,
    bool showChevron = false,
    String? badgeCount,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFEEF7F0) : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: isActive ? Border.all(color: const Color(0xFFC8E6C9)) : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            child: Row(
              children: [
                // Icon Box
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 12),

                // Title & Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: isActive ? FontWeight.w800 : FontWeight.bold,
                          color: isActive ? const Color(0xFF1E5631) : const Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 11,
                          color: isActive ? const Color(0xFF388E3C) : const Color(0xFF718096),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                if (badgeCount != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE53935),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      badgeCount,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                ],

                if (showChevron)
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFFA0AEC0),
                    size: 18,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
