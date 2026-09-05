import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/app_image.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../providers/machinery_provider.dart';

class MachineryListScreen extends ConsumerStatefulWidget {
  const MachineryListScreen({super.key});

  @override
  ConsumerState<MachineryListScreen> createState() => _MachineryListScreenState();
}

class _MachineryListScreenState extends ConsumerState<MachineryListScreen> {
  final Set<String> _favorites = {};

  final List<Map<String, dynamic>> _categories = [
    {
      'id': 'All Machines',
      'name': 'All Machines',
      'icon': Icons.grid_view_rounded,
    },
    {
      'id': 'Tractors',
      'name': 'Tractors',
      'icon': Icons.agriculture_rounded,
    },
    {
      'id': 'Harvesters',
      'name': 'Harvesters',
      'icon': Icons.precision_manufacturing_rounded,
    },
    {
      'id': 'Power Tillers',
      'name': 'Tillers',
      'icon': Icons.hardware_rounded,
    },
    {
      'id': 'Borewell Machines',
      'name': 'Borewell\nRig',
      'icon': Icons.water_drop_rounded,
      'isNew': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(machineryFilterProvider);
    final machinesAsync = ref.watch(machineryListProvider);

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
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rent Agricultural Machines',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: AppColors.warmDarkBrown,
              ),
            ),
            SizedBox(height: 1),
            Text(
              'Trusted by farmers like you',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: AppColors.warmDarkBrown, size: 24),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications: 3 new updates')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primaryGreen, size: 24),
            tooltip: 'List Machine',
            onPressed: () => context.push('/machinery/add'),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),

          // 1. Search Box + Filter Sliders Button Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: (val) {
                        ref.read(machineryFilterProvider.notifier).state =
                            filter.copyWith(searchQuery: val);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Search tractors, harvesters, tillers...',
                        hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 13),
                        prefixIcon: Icon(Icons.search_rounded, color: AppColors.textMuted, size: 22),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Filter Sliders Button
                GestureDetector(
                  onTap: () => _showFilterBottomSheet(context),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.warmBorder, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.tune_rounded, color: AppColors.warmDarkBrown, size: 22),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 2. Horizontal Category Filters Row (All Machines, Tractors, Harvesters, Tillers, Borewell Rig)
          SizedBox(
            height: 92,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (ctx, i) {
                final cat = _categories[i];
                final catName = cat['name'] as String;
                final catId = cat['id'] as String;
                final isNewCat = cat['isNew'] == true;
                final isSelected = filter.selectedCategory == catId ||
                    (catId == 'All Machines' && filter.selectedCategory == null);

                return GestureDetector(
                  onTap: () {
                    ref.read(machineryFilterProvider.notifier).state = filter.copyWith(
                      selectedCategory: catId == 'All Machines' ? null : catId,
                    );
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 84,
                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isSelected
                                ? (isNewCat ? const Color(0xFF7E57C2) : AppColors.primaryGreen)
                                : (isNewCat ? const Color(0xFFD1C4E9) : AppColors.warmBorder),
                            width: isSelected ? 1.8 : 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected
                                  ? (isNewCat
                                      ? const Color(0xFF7E57C2).withValues(alpha: 0.12)
                                      : AppColors.primaryGreen.withValues(alpha: 0.08))
                                  : Colors.black.withValues(alpha: 0.02),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: isNewCat
                                    ? const Color(0xFFF3E5F5)
                                    : (isSelected ? const Color(0xFFE8F5E9) : const Color(0xFFFAF7F2)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                cat['icon'] as IconData,
                                color: isNewCat
                                    ? const Color(0xFF7E57C2)
                                    : (isSelected ? const Color(0xFF2E7D32) : AppColors.textSecondary),
                                size: 20,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              catName,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10,
                                height: 1.1,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isNewCat
                                    ? const Color(0xFF5E35B1)
                                    : (isSelected ? AppColors.warmDarkBrown : AppColors.textSecondary),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isNewCat)
                        Positioned(
                          top: -2,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7E57C2),
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF7E57C2).withValues(alpha: 0.3),
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                            child: const Text(
                              'NEW',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // 3. Section Header: "Top Rated Machines"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Top Rated Machines',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.warmDarkBrown,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    ref.read(machineryFilterProvider.notifier).state = const MachineryFilterState();
                  },
                  child: const Row(
                    children: [
                      Text(
                        'View all',
                        style: TextStyle(
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 2),
                      Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.primaryGreen),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // 4. Machinery List View
          Expanded(
            child: machinesAsync.when(
              data: (machines) {
                if (machines.isEmpty) {
                  return EmptyStateWidget(
                    icon: Icons.agriculture_outlined,
                    title: 'No Machines Found',
                    description: 'Try adjusting your category or search terms.',
                    buttonText: 'Reset Filters',
                    onButtonPressed: () {
                      ref.read(machineryFilterProvider.notifier).state =
                          const MachineryFilterState();
                    },
                  );
                }

                // Preset distances matching reference UI
                final distances = ['3.1 km', '2.4 km', '1.8 km', '4.3 km', '4.2 km'];

                return RefreshIndicator(
                  color: AppColors.primaryGreen,
                  onRefresh: () async {
                    ref.invalidate(machineryListProvider);
                    await ref.read(machineryListProvider.future);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    itemCount: machines.length,
                    itemBuilder: (ctx, i) {
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
                              // Machine Image with Distance Pill Overlay Tag
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: AppImage(
                                      url: m.images.first,
                                      width: 115,
                                      height: 110,
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

                              // Machine Info Column
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

                                    // Rating & Review Count
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
                                    const SizedBox(height: 4),

                                    // Owner & Location
                                    Text(
                                      '📍 ${m.ownerName} • ${m.location}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),

                                    // Price / Day
                                    Text(
                                      '${Formatters.currency(m.rentalPricePerDay)} / day',
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
                  },
                ),
              );
            },
              loading: () => const LoadingIndicator(message: 'Loading available agricultural machinery...'),
              error: (err, _) => Center(child: Text('Error loading machines: $err')),
            ),
          ),

          // 5. Bottom "Verified & Trusted" Farmer Illustration Banner
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(20, 4, 20, 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F3EA), // Soft Warm Cream
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFEBE2D3), width: 1),
            ),
            child: Row(
              children: [
                // Green Verified Shield Icon
                Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.verified_user_rounded, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 14),

                // Text Description Block
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Verified & Trusted',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.5,
                          color: AppColors.warmDarkBrown,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'All machines and owners are verified for your safety.',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Farmer Avatar Graphic
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Color(0xFFDCC865),
                  child: Icon(Icons.person_rounded, color: AppColors.warmDarkBrown, size: 24),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
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
                'Filter Machinery',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.warmDarkBrown),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.star_rounded, color: AppColors.warmAmber),
                title: const Text('Top Rated Only (4.7+ Stars)'),
                onTap: () => Navigator.pop(ctx),
              ),
              ListTile(
                leading: const Icon(Icons.near_me_rounded, color: AppColors.primaryGreen),
                title: const Text('Nearest First (< 5 km)'),
                onTap: () => Navigator.pop(ctx),
              ),
              ListTile(
                leading: const Icon(Icons.attach_money_rounded, color: Colors.green),
                title: const Text('Price: Low to High'),
                onTap: () => Navigator.pop(ctx),
              ),
            ],
          ),
        );
      },
    );
  }
}
