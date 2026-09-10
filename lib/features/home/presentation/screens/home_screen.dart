import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/utils/app_share_helper.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_image.dart';
import '../../../../core/widgets/animated_farm_background.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/notifications_modal.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../machinery/presentation/providers/machinery_provider.dart';
import '../../../marketplace/presentation/providers/marketplace_provider.dart';
import '../../../workers/presentation/providers/worker_provider.dart';
import '../../../bookings_orders/presentation/providers/bookings_orders_provider.dart';
import '../../../../core/localization/language_provider.dart';
import '../../../../core/localization/app_translations.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final Set<String> _favorites = {};

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).value;
    final machinesAsync = ref.watch(machineryListProvider);
    final selectedLang = ref.watch(languageProvider);

    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: AppColors.warmBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: AppColors.warmDarkBrown, size: 26),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF1E5631),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/app_logo.png',
                  width: 36,
                  height: 36,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const Icon(Icons.agriculture_rounded, color: AppColors.accentGold, size: 22),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ref.tr('app_title'),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.warmDarkBrown,
                  ),
                ),
                GestureDetector(
                  onTap: () => _showLocationSelectionBottomSheet(context, ref, user),
                  child: Row(
                    children: [
                      Text(
                        user?.locationName ?? 'Shivamogga, KA',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary, size: 14),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Share App Button
          IconButton(
            icon: const Icon(Icons.share_rounded, color: AppColors.primaryGreen, size: 22),
            tooltip: 'Share App with Farmers',
            onPressed: () => AppShareHelper.showShareAppBottomSheet(context),
          ),

          // Notification Bell
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: AppColors.warmDarkBrown, size: 24),
            tooltip: 'View Notifications',
            onPressed: () => NotificationsModalSheet.show(context),
          ),

          // Message/Chat Icon with Red Badge '3'
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.warmDarkBrown, size: 22),
                onPressed: () => context.push('/my-orders'),
              ),
              Positioned(
                top: 10,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),

      body: RefreshIndicator(
        color: AppColors.primaryGreen,
        onRefresh: () async {
          ref.invalidate(machineryListProvider);
          ref.invalidate(marketplaceProductsProvider);
          ref.invalidate(workerListProvider);
          ref.invalidate(userBookingsProvider);
          await Future.wait([
            ref.read(machineryListProvider.future),
            ref.read(marketplaceProductsProvider.future),
            ref.read(workerListProvider.future),
          ]);
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // 1. Hero Landscape Banner Container with High-Contrast Pill Badges
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    height: 245,
                    width: double.infinity,
                    child: AnimatedFarmBackground(
                      height: 245,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 36),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ref.tr('greeting_namaste'),
                                  style: const TextStyle(
                                    color: Color(0xFF2D1C10),
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    shadows: [
                                      Shadow(offset: Offset(0, 1), blurRadius: 2, color: Colors.white),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      (user?.name ?? 'Bharath Poojary').split(' ').map((str) => str.isNotEmpty ? '${str[0].toUpperCase()}${str.substring(1).toLowerCase()}' : '').join(' '),
                                      style: const TextStyle(
                                        color: Color(0xFF2D1C10),
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(offset: Offset(0, 1), blurRadius: 2, color: Colors.white),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Text('👋', style: TextStyle(fontSize: 20)),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  ref.tr('tagline'),
                                  style: const TextStyle(
                                    color: Color(0xFF2D1C10),
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(offset: Offset(0, 1), blurRadius: 2, color: Colors.white),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            // Interactive Pill Badges Row
                            Row(
                              children: [
                                // 1. Amber/Orange Role Pill Badge ("Farmer")
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: () => _showRoleSelectionBottomSheet(context, ref, user),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFA000), // Vibrant Amber/Orange Fill
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFFFFA000).withValues(alpha: 0.3),
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.person, size: 14, color: AppColors.warmDarkBrown),
                                          const SizedBox(width: 6),
                                          Text(
                                            user?.role ?? 'Farmer',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.warmDarkBrown,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: AppColors.warmDarkBrown),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),

                                // 2. Crisp White Location Pill Badge ("Shivamogga, KA")
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: () => _showLocationSelectionBottomSheet(context, ref, user),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: AppColors.warmBorder, width: 1),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.05),
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.location_on, size: 14, color: Color(0xFFFF6F00)),
                                          const SizedBox(width: 6),
                                          Text(
                                            user?.locationName ?? 'Shivamogga, KA',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.warmDarkBrown,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: Color(0xFFFF6F00)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Floating Search Box & Solid Orange Filter Button
                Positioned(
                  bottom: -22,
                  left: 28,
                  right: 28,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.warmBorder, width: 1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: TextField(
                            onSubmitted: (_) => context.go('/machinery'),
                            decoration: InputDecoration(
                              hintText: ref.tr('search_placeholder'),
                              hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                              prefixIcon: Icon(Icons.search_rounded, color: AppColors.textMuted, size: 22),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Solid Orange Filter Button
                      GestureDetector(
                        onTap: () => context.go('/machinery'),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6F00), // Solid Orange
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF6F00).withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.tune_rounded, color: Colors.white, size: 22),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 38),

            // 2. 4 Horizontal Action Category Cards Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildActionCategoryCard(
                      context: context,
                      title: ref.tr('rent_machinery_short'),
                      icon: Icons.agriculture_rounded,
                      bgColor: const Color(0xFFF1F8F3), // Soft Mint Green
                      iconColor: const Color(0xFF2E7D32),
                      onTap: () => context.go('/machinery'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildActionCategoryCard(
                      context: context,
                      title: ref.tr('hire_workers_short'),
                      icon: Icons.groups_rounded,
                      bgColor: const Color(0xFFFFF6ED), // Soft Peach/Orange
                      iconColor: const Color(0xFFE65100),
                      onTap: () => context.go('/workers'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildActionCategoryCard(
                      context: context,
                      title: ref.tr('buy_sell_produce_short'),
                      icon: Icons.shopping_basket_rounded,
                      bgColor: const Color(0xFFEFF6FF), // Soft Blue
                      iconColor: const Color(0xFF1565C0),
                      onTap: () => context.push('/marketplace'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildActionCategoryCard(
                      context: context,
                      title: ref.tr('agro_store_short'),
                      icon: Icons.storefront_rounded,
                      bgColor: const Color(0xFFF5F3FF), // Soft Purple
                      iconColor: const Color(0xFF7E57C2),
                      onTap: () => context.push('/agro-store'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Provider / Worker Join Banner Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: () => context.push('/provider/join'),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.agriculture_rounded, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ref.tr('have_machine_or_skill'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              ref.tr('join_owner_worker'),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6F00),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          ref.tr('join_now'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 3. Section Header: "Top Machines Near You"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ref.tr('top_machines_near_you'),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.warmDarkBrown,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.go('/machinery'),
                    child: Row(
                      children: [
                        Text(
                          ref.tr('view_all'),
                          style: const TextStyle(
                            color: Color(0xFFFF6F00),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFFFF6F00)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 4. Vertical Machine Cards List ("Top Machines Near You")
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: machinesAsync.when(
                data: (machines) {
                  final distances = ['2.4 km', '3.1 km', '1.8 km', '4.3 km'];

                  return Column(
                    children: List.generate(machines.length, (i) {
                      final m = machines[i];
                      final dist = distances[i % distances.length];
                      final isFav = _favorites.contains(m.id);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.warmBorder, width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () => context.push('/machinery/${m.id}'),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Machine Image with Distance Overlay Pill
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: AppImage(
                                        url: m.images.first,
                                        width: 115,
                                        height: 105,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 6,
                                      left: 6,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.95),
                                          borderRadius: BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(alpha: 0.08),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.location_on, size: 10, color: AppColors.warmDarkBrown),
                                            const SizedBox(width: 3),
                                            Text(
                                              dist,
                                              style: const TextStyle(
                                                color: AppColors.warmDarkBrown,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 12),

                                // Machine Details Column
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Title & Heart Favorite Row
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (m.isNew) ...[
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                              margin: const EdgeInsets.only(right: 5, top: 1),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF7E57C2),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: const Text(
                                                'NEW',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 8.5,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                          Expanded(
                                            child: Text(
                                              m.name,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13.5,
                                                color: AppColors.warmDarkBrown,
                                                height: 1.25,
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (isFav) {
                                                  _favorites.remove(m.id);
                                                } else {
                                                  _favorites.add(m.id);
                                                }
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 4),
                                              child: Icon(
                                                isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                                color: isFav ? Colors.redAccent : AppColors.textMuted,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),

                                      // Rating Stars + Review Count
                                      Row(
                                        children: [
                                          const Icon(Icons.star_rounded, color: AppColors.warmAmber, size: 16),
                                          const SizedBox(width: 3),
                                          Text(
                                            m.rating.toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: AppColors.warmDarkBrown,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '(${m.reviewCount} Reviews)',
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: AppColors.textMuted,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),

                                      // Price / Day Text
                                      Text(
                                        '${Formatters.currency(m.rentalPricePerDay)}/day',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.success,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Text('Error: $err'),
              ),
            ),

            const SizedBox(height: 16),

            // 5. Bottom "List your machine" Warm Golden Banner
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFAF4E6), // Soft Warm Cream
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE6DAC3), width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Left Content Column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              ref.tr('rent_machinery'),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Color(0xFF1E3A24), // Dark Forest Green
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              ref.tr('safety_verified'),
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF5A4D3E),
                                height: 1.25,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () => context.push('/machinery/add'),
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(14, 6, 6, 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF163820), // Dark Forest Green Pill
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(color: const Color(0xFFC5A059), width: 1), // Gold Border
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF163820).withValues(alpha: 0.3),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      ref.tr('post_ad'),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    CircleAvatar(
                                      radius: 10,
                                      backgroundColor: Color(0xFFC5A059), // Gold Arrow Circle
                                      child: Icon(Icons.arrow_forward_rounded, color: Color(0xFF163820), size: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Right Side Clipped Tractor & Farm Artwork
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SizedBox(
                          width: 100,
                          height: 95,
                          child: Image.asset(
                            'assets/images/farm_hero_banner_illustration.jpg',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: const Color(0xFFE8F5E9),
                              child: const Icon(Icons.agriculture_rounded, color: Color(0xFF163820), size: 40),
                            ),
                          ),
                        ),
                      ),
                    ],
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

  // --- Clean Category Card Builder ---
  Widget _buildActionCategoryCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color bgColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.warmBorder, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: AppColors.warmDarkBrown,
                height: 1.15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Interactive Bottom Sheet for Role Picker ---
  void _showRoleSelectionBottomSheet(BuildContext context, WidgetRef ref, User? user) {
    final currentRole = user?.role ?? 'Farmer';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Select Your Profile Role',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.warmDarkBrown,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Switch your role to access tailored features & tools',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              _buildRoleOptionTile(
                context: ctx,
                title: 'Farmer',
                subtitle: 'Rent machines, hire skilled workers & buy/sell produce',
                icon: Icons.agriculture_rounded,
                iconColor: const Color(0xFF2E7D32),
                iconBg: const Color(0xFFE8F5E9),
                isSelected: currentRole.toLowerCase() == 'farmer',
                onSelect: () {
                  ref.read(authProvider.notifier).switchRole('Farmer');
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Switched role to Farmer')),
                  );
                },
              ),
              const SizedBox(height: 8),
              _buildRoleOptionTile(
                context: ctx,
                title: 'Equipment Owner',
                subtitle: 'List tractors, harvesters & earn rental income',
                icon: Icons.precision_manufacturing_rounded,
                iconColor: const Color(0xFFE65100),
                iconBg: const Color(0xFFFFF3E0),
                isSelected: currentRole.toLowerCase() == 'equipment owner',
                onSelect: () {
                  ref.read(authProvider.notifier).switchRole('Equipment Owner');
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Switched role to Equipment Owner')),
                  );
                },
              ),
              const SizedBox(height: 8),
              _buildRoleOptionTile(
                context: ctx,
                title: 'Farm Worker / Driver',
                subtitle: 'Offer daily wage labor & driver services nearby',
                icon: Icons.groups_rounded,
                iconColor: const Color(0xFF1565C0),
                iconBg: const Color(0xFFE3F2FD),
                isSelected: currentRole.toLowerCase() == 'farm worker / driver',
                onSelect: () {
                  ref.read(authProvider.notifier).switchRole('Farm Worker / Driver');
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Switched role to Farm Worker / Driver')),
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRoleOptionTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required bool isSelected,
    required VoidCallback onSelect,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFFF8E1) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppColors.warmAmber : AppColors.warmBorder,
          width: isSelected ? 2.0 : 1.0,
        ),
      ),
      child: ListTile(
        onTap: onSelect,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconBg,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.warmDarkBrown),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
        trailing: isSelected
            ? const Icon(Icons.check_circle_rounded, color: AppColors.warmAmber, size: 22)
            : const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
      ),
    );
  }

  // --- Interactive Bottom Sheet for Location Picker ---
  void _showLocationSelectionBottomSheet(BuildContext context, WidgetRef ref, User? user) {
    final currentLocation = user?.locationName ?? 'Shivamogga, KA';

    final locations = [
      'Shivamogga, KA',
      'Davanagere, KA',
      'Chikkamagaluru, KA',
      'Hassan, KA',
      'Tumakuru, KA',
      'Mandya, KA',
      'Mysuru, KA',
      'Hubballi-Dharwad, KA',
      'Belagavi, KA',
      'Udupi, KA',
      'Mangaluru, KA',
      'Bengaluru Rural, KA',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.85,
          expand: false,
          builder: (_, scrollController) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Select Location',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.warmDarkBrown,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Choose your area to discover nearby machines & workers',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),

                  // GPS Location Button
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ListTile(
                      onTap: () {
                        if (user != null) {
                          ref.read(authProvider.notifier).updateProfile(
                                user.copyWith(locationName: 'Shivamogga, KA'),
                              );
                        }
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Updated location to Current Location (Shivamogga, KA)')),
                        );
                      },
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xFF2E7D32),
                        radius: 16,
                        child: Icon(Icons.my_location_rounded, color: Colors.white, size: 16),
                      ),
                      title: const Text(
                        'Use Current Location (GPS)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF2E7D32)),
                      ),
                      subtitle: const Text('Auto-detect your location', style: TextStyle(fontSize: 11)),
                    ),
                  ),
                  const SizedBox(height: 14),

                  const Text(
                    'Popular Districts & Areas',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.warmDarkBrown),
                  ),
                  const SizedBox(height: 8),

                  Expanded(
                    child: ListView.separated(
                      controller: scrollController,
                      itemCount: locations.length,
                      separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.warmBorder),
                      itemBuilder: (context, idx) {
                        final loc = locations[idx];
                        final isSelected = loc == currentLocation;

                        return ListTile(
                          onTap: () {
                            if (user != null) {
                              ref.read(authProvider.notifier).updateProfile(
                                    user.copyWith(locationName: loc),
                                  );
                            }
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Location updated to $loc')),
                            );
                          },
                          leading: Icon(
                            Icons.location_city_rounded,
                            color: isSelected ? AppColors.primaryGreen : AppColors.textMuted,
                            size: 20,
                          ),
                          title: Text(
                            loc,
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isSelected ? AppColors.warmDarkBrown : AppColors.textSecondary,
                            ),
                          ),
                          trailing: isSelected
                              ? const Icon(Icons.check_circle_rounded, color: AppColors.primaryGreen, size: 20)
                              : null,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
