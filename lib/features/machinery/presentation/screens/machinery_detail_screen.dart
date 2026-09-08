import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/url_launcher_helper.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/rating_stars.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/app_image.dart';
import '../providers/machinery_provider.dart';

class MachineryDetailScreen extends ConsumerWidget {
  final String machineId;

  const MachineryDetailScreen({super.key, required this.machineId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final machineAsync = ref.watch(machineDetailProvider(machineId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Machine Details'),
      ),
      body: machineAsync.when(
        data: (m) {
          if (m == null) {
            return const Center(child: Text('Machine not found'));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Machine Hero Image
                AppImage(
                  url: m.images.first,
                  height: 220,
                  width: double.infinity,
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.chipBackground,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              m.category,
                              style: const TextStyle(
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          RatingStars(rating: m.rating, count: m.reviewCount, iconSize: 20),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        m.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '📍 ${m.location}',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${Formatters.currency(m.rentalPricePerDay)} / day',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGreen,
                        ),
                      ),

                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 12),

                      // Description
                      const Text(
                        'Description',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        m.description,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.4),
                      ),

                      const SizedBox(height: 20),

                      // Specifications Table
                      if (m.specs.isNotEmpty) ...[
                        const Text(
                          'Machine Specifications',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.borderLight),
                          ),
                          child: Column(
                            children: m.specs.entries.map((e) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(e.key, style: const TextStyle(color: AppColors.textSecondary)),
                                    Text(e.value, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Owner Contact Card & WhatsApp
                      Card(
                        color: AppColors.chipBackground,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                backgroundColor: AppColors.primaryGreen,
                                child: Icon(Icons.person, color: Colors.white),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Owner: ${m.ownerName}',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                    Text(
                                      m.ownerPhone,
                                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.chat_bubble_rounded, color: AppColors.whatsappGreen),
                                tooltip: 'WhatsApp Owner',
                                onPressed: () {
                                  UrlLauncherHelper.showWhatsAppConfirmationBottomSheet(
                                    context: context,
                                    phoneNumber: m.ownerPhone,
                                    recipientName: m.ownerName,
                                    category: 'Machinery Rental',
                                    itemTitle: m.name,
                                    itemId: m.id,
                                    itemType: 'machines',
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 80), // Padding for bottom bar
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const LoadingIndicator(message: 'Loading machine details...'),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: CustomButton(
          text: 'Proceed to Booking',
          onPressed: () => context.push('/machinery/$machineId/book'),
        ),
      ),
    );
  }
}
