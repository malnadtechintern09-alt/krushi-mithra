import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/url_launcher_helper.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/app_image.dart';
import '../providers/marketplace_provider.dart';

class ProductDetailScreen extends ConsumerWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productDetailProvider(productId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        title: const Text('Produce Listing Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_rounded, color: Colors.white),
            tooltip: 'Return to Home',
            onPressed: () => context.go('/'),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: productAsync.when(
        data: (p) {
          if (p == null) return const Center(child: Text('Product not found'));

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppImage(
                  url: p.images.first,
                  height: 220,
                  width: double.infinity,
                  placeholderIcon: Icons.storefront,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.chipBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          p.category,
                          style: const TextStyle(
                            color: AppColors.primaryGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        p.title,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text('📍 ${p.location}', style: const TextStyle(color: AppColors.textSecondary)),
                      const SizedBox(height: 16),
                      Text(
                        '${Formatters.currency(p.price)} / ${p.unit}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text('Stock Available: ${p.quantityAvailable.toInt()} ${p.unit}s',
                          style: const TextStyle(color: AppColors.textMuted)),

                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 12),

                      const Text('Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(p.description, style: const TextStyle(color: AppColors.textSecondary, height: 1.4)),

                      const SizedBox(height: 24),
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
                                    Text('Farmer / Seller: ${p.sellerName}',
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                    Text(p.sellerPhone, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
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
        child: productAsync.when(
          data: (p) => p == null
              ? const SizedBox()
              : CustomButton(
                  text: 'Contact Seller on WhatsApp',
                  backgroundColor: AppColors.whatsappGreen,
                  icon: Icons.chat_bubble_rounded,
                  onPressed: () {
                    UrlLauncherHelper.openWhatsApp(
                      phoneNumber: p.sellerPhone,
                      message: 'Namaste ${p.sellerName}, I want to buy ${p.title} from your Krushi Mithra listing.',
                    );
                  },
                ),
          loading: () => const SizedBox(),
          error: (_, __) => const SizedBox(),
        ),
      ),
    );
  }
}
