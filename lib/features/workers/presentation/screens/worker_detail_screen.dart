import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/url_launcher_helper.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/rating_stars.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../providers/worker_provider.dart';

class WorkerDetailScreen extends ConsumerWidget {
  final String workerId;

  const WorkerDetailScreen({super.key, required this.workerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workerAsync = ref.watch(workerDetailProvider(workerId));

    return Scaffold(
      appBar: AppBar(title: const Text('Operator Profile')),
      body: workerAsync.when(
        data: (w) {
          if (w == null) return const Center(child: Text('Worker profile not found'));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Profile Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundImage: NetworkImage(w.profilePhoto),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      w.name,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                    ),
                                  ),
                                  if (w.isVerified)
                                    const Icon(Icons.verified, color: AppColors.primaryGreen, size: 20),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text('📍 ${w.location}', style: const TextStyle(color: AppColors.textSecondary)),
                              Text('${w.experienceYears} Years Experience',
                                  style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                              const SizedBox(height: 6),
                              RatingStars(rating: w.rating, count: w.reviewCount),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Rate & Contact Row
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Daily Charge Rate', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                            const SizedBox(height: 4),
                            Text(
                              '${Formatters.currency(w.dailyRate)} / day',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.chat_bubble, color: AppColors.whatsappGreen),
                      label: const Text('WhatsApp'),
                      onPressed: () {
                        UrlLauncherHelper.openWhatsApp(
                          phoneNumber: w.phone,
                          message: 'Namaste ${w.name}, I found your worker profile on Krushi Mithra.',
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Skills List
                const Text('Specialized Skills', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: w.skills.map((s) {
                    return Chip(
                      label: Text(s),
                      backgroundColor: AppColors.chipBackground,
                      labelStyle: const TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.w600),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Bio & Experience Details
                const Text('About Worker', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(
                  w.bio,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.4),
                ),
                const SizedBox(height: 80),
              ],
            ),
          );
        },
        loading: () => const LoadingIndicator(),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, -4)),
          ],
        ),
        child: CustomButton(
          text: 'Book & Hire Worker',
          onPressed: () => context.push('/workers/$workerId/book'),
        ),
      ),
    );
  }
}
