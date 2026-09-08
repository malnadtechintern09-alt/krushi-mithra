import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/config/constants.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/url_launcher_helper.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/app_image.dart';
import '../providers/marketplace_provider.dart';
import '../../../../core/localization/language_provider.dart';
import '../../../../core/localization/app_translations.dart';

class MarketplaceListScreen extends ConsumerWidget {
  const MarketplaceListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(marketplaceFilterProvider);
    final productsAsync = ref.watch(marketplaceProductsProvider);
    final selectedLang = ref.watch(languageProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(ref.tr('crop_marketplace')),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_business_rounded),
            tooltip: 'Sell Produce',
            onPressed: () => context.push('/marketplace/create'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter & Search Header
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                TextField(
                  onChanged: (val) {
                    ref.read(marketplaceFilterProvider.notifier).state =
                        filter.copyWith(searchQuery: val);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search crops (Arecanut, Pepper, Coffee, Paddy)',
                    prefixIcon: const Icon(Icons.search, color: AppColors.primaryGreen),
                    filled: true,
                    fillColor: AppColors.backgroundLight,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Category Chips List
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: AppConstants.marketplaceCategories.length,
                    itemBuilder: (ctx, i) {
                      final cat = AppConstants.marketplaceCategories[i];
                      final isSelected = filter.selectedCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(cat),
                          selected: isSelected,
                          selectedColor: AppColors.primaryGreen,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          onSelected: (val) {
                            if (val) {
                              ref.read(marketplaceFilterProvider.notifier).state =
                                  filter.copyWith(selectedCategory: cat);
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Products Grid / List Body
          Expanded(
            child: productsAsync.when(
              data: (products) {
                if (products.isEmpty) {
                  return EmptyStateWidget(
                    icon: Icons.storefront_outlined,
                    title: 'No Listings Found',
                    description: 'No produce matched your search filters.',
                    buttonText: 'Reset Filters',
                    onButtonPressed: () {
                      ref.read(marketplaceFilterProvider.notifier).state =
                          const MarketplaceFilterState();
                    },
                  );
                }

                return RefreshIndicator(
                  color: AppColors.primaryGreen,
                  onRefresh: () async {
                    ref.invalidate(marketplaceProductsProvider);
                    await ref.read(marketplaceProductsProvider.future);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: products.length,
                    itemBuilder: (ctx, i) {
                      final p = products[i];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => context.push('/marketplace/${p.id}'),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: AppImage(
                                    url: p.images.first,
                                    width: 100,
                                    height: 100,
                                    placeholderIcon: Icons.storefront,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.chipBackground,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          p.category,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: AppColors.primaryGreen,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        p.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '📍 ${p.location} • Seller: ${p.sellerName}',
                                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${Formatters.currency(p.price)} / ${p.unit}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primaryGreen,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.chat, color: AppColors.whatsappGreen),
                                            tooltip: 'WhatsApp Seller',
                                            onPressed: () {
                                              UrlLauncherHelper.showWhatsAppConfirmationBottomSheet(
                                                context: context,
                                                phoneNumber: p.sellerPhone,
                                                recipientName: p.sellerName,
                                                category: 'Produce Listing',
                                                itemTitle: p.title,
                                                itemId: p.id,
                                                itemType: 'marketplace',
                                              );
                                            },
                                          ),
                                        ],
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
              loading: () => const LoadingIndicator(message: 'Loading marketplace listings...'),
              error: (err, _) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}
