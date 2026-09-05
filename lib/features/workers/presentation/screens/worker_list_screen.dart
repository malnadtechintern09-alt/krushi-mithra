import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/url_launcher_helper.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/app_image.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../providers/worker_provider.dart';

class WorkerListScreen extends ConsumerStatefulWidget {
  const WorkerListScreen({super.key});

  @override
  ConsumerState<WorkerListScreen> createState() => _WorkerListScreenState();
}

class _WorkerListScreenState extends ConsumerState<WorkerListScreen> {
  final List<Map<String, dynamic>> _skillFilters = [
    {
      'id': 'All',
      'name': 'All',
      'icon': Icons.grid_view_rounded,
    },
    {
      'id': 'Tractor Driver',
      'name': 'Tractor\nDriver',
      'icon': Icons.agriculture_rounded,
    },
    {
      'id': 'Harvester Operator',
      'name': 'Harvester\nOperator',
      'icon': Icons.precision_manufacturing_rounded,
    },
    {
      'id': 'Paddy Worker',
      'name': 'Paddy\nWorker',
      'icon': Icons.grass_rounded,
    },
    {
      'id': 'More',
      'name': 'More',
      'icon': Icons.more_horiz_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(workerFilterProvider);
    final workersAsync = ref.watch(workerListProvider);

    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      drawer: const AppDrawer(),
      body: Column(
        children: [
          // 1. Hero Header Banner with Farm Landscape Illustration & Search Bar
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Farm Landscape Banner Container
              ClipRRect(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                child: Container(
                  height: 215,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFF7FAF4), // Soft Mint Sky Top
                        Color(0xFFEBF3E8),
                        Color(0xFFDBEAD5), // Base
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Custom Painter for Farm Landscape (Sun, Low Field Hills, Tractor, House)
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _WorkerFarmHeroPainter(),
                        ),
                      ),

                      // Header Top Actions & Welcome Title Block
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top Bar Icons Row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Builder(
                                    builder: (builderContext) => IconButton(
                                      icon: const Icon(Icons.menu_rounded, color: AppColors.warmDarkBrown, size: 26),
                                      onPressed: () => Scaffold.of(builderContext).openDrawer(),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.notifications_none_rounded, color: AppColors.warmDarkBrown, size: 24),
                                        onPressed: () {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Notifications: 2 new worker requests')),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.person_add_alt_1_rounded, color: AppColors.primaryGreen, size: 24),
                                        tooltip: 'Register as Worker',
                                        onPressed: () => context.push('/workers/register'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),

                              // Header Title & Subtitle (Clean & High Contrast)
                              const Text(
                                'Hire Farm\nWorkers & Drivers',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.warmDarkBrown,
                                  height: 1.15,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Right people for better farming.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Search Box & Filter Sliders Row
              Positioned(
                bottom: -22,
                left: 20,
                right: 20,
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
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          onChanged: (val) {
                            ref.read(workerFilterProvider.notifier).state =
                                filter.copyWith(searchQuery: val);
                          },
                          decoration: const InputDecoration(
                            hintText: 'Search skills (e.g. Tractor Driver, Areca...)',
                            hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 12.5),
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
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.tune_rounded, color: AppColors.warmDarkBrown, size: 22),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // 2. Horizontal Skill Filter Chips Row (All, Tractor Driver, Harvester Operator, Paddy Worker, More)
          SizedBox(
            height: 82,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _skillFilters.length,
              itemBuilder: (ctx, i) {
                final sf = _skillFilters[i];
                final sfName = sf['id'] as String;
                final isSelected = filter.selectedSkill == sfName ||
                    (sfName == 'All' && filter.selectedSkill == null);

                return GestureDetector(
                  onTap: () {
                    if (sfName == 'More') {
                      _showMoreSkillsBottomSheet(context);
                    } else {
                      ref.read(workerFilterProvider.notifier).state = filter.copyWith(
                        selectedSkill: sfName == 'All' ? null : sfName,
                      );
                    }
                  },
                  child: Container(
                    width: 72,
                    margin: const EdgeInsets.only(right: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Circular Icon Container
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected ? const Color(0xFF2E7D32) : Colors.white,
                            border: Border.all(
                              color: isSelected ? const Color(0xFF2E7D32) : AppColors.warmBorder,
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isSelected
                                    ? const Color(0xFF2E7D32).withValues(alpha: 0.2)
                                    : Colors.black.withValues(alpha: 0.02),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            sf['icon'] as IconData,
                            color: isSelected ? Colors.white : const Color(0xFF2E7D32),
                            size: 22,
                          ),
                        ),
                        const SizedBox(height: 5),

                        // Skill Label Text
                        Text(
                          sf['name'] as String,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            height: 1.1,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? AppColors.warmDarkBrown : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // 3. Worker Cards List View
          Expanded(
            child: workersAsync.when(
              data: (workers) {
                if (workers.isEmpty) {
                  return EmptyStateWidget(
                    icon: Icons.engineering_outlined,
                    title: 'No Workers Found',
                    description: 'No farm workers matched your skill criteria.',
                    buttonText: 'Reset Filters',
                    onButtonPressed: () {
                      ref.read(workerFilterProvider.notifier).state =
                          const WorkerFilterState();
                    },
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  itemCount: workers.length,
                  itemBuilder: (ctx, i) {
                    final w = workers[i];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
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
                        onTap: () => context.push('/workers/${w.id}'),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top Profile Header Row
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Profile Picture Avatar
                                  ClipOval(
                                    child: AppImage(
                                      url: w.profilePhoto,
                                      width: 56,
                                      height: 56,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // Name, Location, Experience, Rating Column
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Name + Verified Badge Row
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                w.name,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  color: AppColors.warmDarkBrown,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            if (w.isVerified)
                                              const Row(
                                                children: [
                                                  Icon(Icons.add_circle_rounded, color: Color(0xFF2E7D32), size: 14),
                                                  SizedBox(width: 3),
                                                  Text(
                                                    'Verified',
                                                    style: TextStyle(
                                                      color: Color(0xFF2E7D32),
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),

                                        // Location Name
                                        Text(
                                          w.location,
                                          style: const TextStyle(
                                            fontSize: 11.5,
                                            color: AppColors.textSecondary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 2),

                                        // Experience Years
                                        Text(
                                          '${w.experienceYears} Years Exp.',
                                          style: const TextStyle(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFB06010),
                                          ),
                                        ),
                                        const SizedBox(height: 4),

                                        // Rating Stars + Count Row
                                        Row(
                                          children: [
                                            const Icon(Icons.star_rounded, color: AppColors.warmAmber, size: 16),
                                            const SizedBox(width: 3),
                                            Text(
                                              w.rating.toStringAsFixed(1),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: AppColors.warmDarkBrown,
                                              ),
                                            ),
                                            const SizedBox(width: 3),
                                            Text(
                                              '(${w.reviewCount})',
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: AppColors.textMuted,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // Middle Skills Chips Wrap
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: w.skills.map((s) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF7F3EA), // Soft Cream/Yellow Chip
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: const Color(0xFFEBE2D3), width: 0.8),
                                    ),
                                    child: Text(
                                      s,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF5D4A3A),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),

                              const SizedBox(height: 14),

                              // Bottom Price & Call / View Actions Row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${Formatters.currency(w.dailyRate)} / day',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.success,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      // Circular Call Button
                                      GestureDetector(
                                        onTap: () => UrlLauncherHelper.makePhoneCall(w.phone),
                                        child: Container(
                                          width: 38,
                                          height: 38,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            border: Border.all(color: AppColors.warmBorder, width: 1.2),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(alpha: 0.03),
                                                blurRadius: 4,
                                              ),
                                            ],
                                          ),
                                          child: const Icon(Icons.call_rounded, color: AppColors.primaryGreen, size: 18),
                                        ),
                                      ),
                                      const SizedBox(width: 8),

                                      // Green Pill View Button
                                      GestureDetector(
                                        onTap: () => context.push('/workers/${w.id}'),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 9),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF1E5631),
                                            borderRadius: BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xFF1E5631).withValues(alpha: 0.25),
                                                blurRadius: 6,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: const Text(
                                            'View',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const LoadingIndicator(message: 'Searching available farm workers...'),
              error: (err, _) => Center(child: Text('Error: $err')),
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
                'Filter Workers',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.warmDarkBrown),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.star_rounded, color: AppColors.warmAmber),
                title: const Text('Top Rated (4.8+ Stars)'),
                onTap: () => Navigator.pop(ctx),
              ),
              ListTile(
                leading: const Icon(Icons.verified_user_rounded, color: AppColors.primaryGreen),
                title: const Text('Verified Workers Only'),
                onTap: () => Navigator.pop(ctx),
              ),
              ListTile(
                leading: const Icon(Icons.work_history_rounded, color: Colors.orange),
                title: const Text('10+ Years Experience'),
                onTap: () => Navigator.pop(ctx),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMoreSkillsBottomSheet(BuildContext context) {
    final skills = [
      'Arecanut Tree Climber/Harvester',
      'Bush & Grass Cutting Specialist',
      'Tractor Driver',
      'Harvester Operator',
      'Paddy Planter/Harvester',
      'Plantation Laborer',
      'Sugarcane Cutter',
      'Fertilizer & Spraying Operator',
    ];

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
                'Select Skill Category',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.warmDarkBrown),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: skills.length,
                  itemBuilder: (context, idx) {
                    final s = skills[idx];
                    return ListTile(
                      title: Text(s, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                      onTap: () {
                        ref.read(workerFilterProvider.notifier).state =
                            ref.read(workerFilterProvider).copyWith(selectedSkill: s);
                        Navigator.pop(ctx);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Custom Painter for Farm Landscape Hero Banner (Sun, Low Field Hills, Tractor, House)
class _WorkerFarmHeroPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Sun in Sky Top Right
    final sunCenter = Offset(w * 0.88, h * 0.20);
    final sunPaint = Paint()..color = const Color(0xFFF7BD38);
    canvas.drawCircle(sunCenter, 20, sunPaint);

    // 2. Rolling Yellow Crop Hill (Kept Low)
    final cropPath = Path();
    cropPath.moveTo(w * 0.40, h);
    cropPath.quadraticBezierTo(w * 0.70, h * 0.76, w, h * 0.80);
    cropPath.lineTo(w, h);
    cropPath.close();

    final cropPaint = Paint()..color = const Color(0xFFDCC865);
    canvas.drawPath(cropPath, cropPaint);

    // 3. Green Farm Ground Wave (Kept at Bottom)
    final fieldPath = Path();
    fieldPath.moveTo(0, h * 0.88);
    fieldPath.quadraticBezierTo(w * 0.50, h * 0.82, w, h * 0.90);
    fieldPath.lineTo(w, h);
    fieldPath.lineTo(0, h);
    fieldPath.close();

    final fieldPaint = Paint()..color = const Color(0xFF7FA852);
    canvas.drawPath(fieldPath, fieldPaint);

    // 4. Farm House (Far Right)
    final houseX = w * 0.88;
    final houseY = h * 0.62;

    final wallPaint = Paint()..color = const Color(0xFFEADCC9);
    canvas.drawRect(Rect.fromLTWH(houseX - 10, houseY, 20, 14), wallPaint);

    final roofPath = Path()
      ..moveTo(houseX - 14, houseY)
      ..lineTo(houseX, houseY - 10)
      ..lineTo(houseX + 14, houseY)
      ..close();
    final roofPaint = Paint()..color = const Color(0xFFC46535);
    canvas.drawPath(roofPath, roofPaint);

    // 5. Green Tractor Illustration (Mid Right)
    final tractorX = w * 0.72;
    final tractorY = h * 0.58;
    _drawTractorIllustration(canvas, tractorX, tractorY);
  }

  void _drawTractorIllustration(Canvas canvas, double x, double y) {
    final greenBody = Paint()..color = const Color(0xFF4C7B25);
    final darkBody = Paint()..color = const Color(0xFF2C3E1B);
    final yellowWheel = Paint()..color = const Color(0xFFF0BD32);
    final tirePaint = Paint()..color = const Color(0xFF1E2816);

    // Big Rear Wheel
    canvas.drawCircle(Offset(x + 16, y + 10), 14, tirePaint);
    canvas.drawCircle(Offset(x + 16, y + 10), 8, yellowWheel);

    // Small Front Wheel
    canvas.drawCircle(Offset(x - 14, y + 14), 8, tirePaint);
    canvas.drawCircle(Offset(x - 14, y + 14), 5, yellowWheel);

    // Tractor Hood & Body
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(x - 18, y - 2, 24, 14),
      const Radius.circular(4),
    );
    canvas.drawRRect(bodyRect, greenBody);

    // Cabin Top
    final cabinPath = Path()
      ..moveTo(x + 2, y - 2)
      ..lineTo(x + 6, y - 16)
      ..lineTo(x + 20, y - 16)
      ..lineTo(x + 22, y - 2)
      ..close();
    canvas.drawPath(cabinPath, darkBody);

    // Exhaust Pipe
    final pipePath = Path()..addRect(Rect.fromLTWH(x - 12, y - 12, 3, 10));
    canvas.drawPath(pipePath, darkBody);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
