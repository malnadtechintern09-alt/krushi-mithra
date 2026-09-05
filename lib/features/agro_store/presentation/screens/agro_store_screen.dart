import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/config/constants.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_image.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/rating_stars.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../marketplace/presentation/providers/marketplace_provider.dart';
import '../providers/cart_provider.dart';

class AgroStoreScreen extends ConsumerStatefulWidget {
  const AgroStoreScreen({super.key});

  @override
  ConsumerState<AgroStoreScreen> createState() => _AgroStoreScreenState();
}

class _AgroStoreScreenState extends ConsumerState<AgroStoreScreen> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(agroStoreProductsProvider);
    final cart = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('🌱 Official Agro Store'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_rounded),
                tooltip: 'Shopping Cart',
                onPressed: () => context.push('/cart'),
              ),
              if (cart.totalItemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.accentGold,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                    child: Text(
                      '${cart.totalItemCount}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Agro Store Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: AppColors.primaryGreenLight.withOpacity(0.15),
            child: const Row(
              children: [
                Icon(Icons.verified_user_rounded, color: AppColors.primaryGreen, size: 28),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '100% Genuine Seeds, Fertilisers & Tools with Direct Doorstep Delivery.',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Category Chips
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: AppConstants.agroStoreCategories.length,
              itemBuilder: (ctx, i) {
                final cat = AppConstants.agroStoreCategories[i];
                final isSelected = _selectedCategory == cat;
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
                      if (val) setState(() => _selectedCategory = cat);
                    },
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),

          // Catalog Grid
          Expanded(
            child: productsAsync.when(
              data: (products) {
                final filtered = _selectedCategory == 'All'
                    ? products
                    : products.where((p) => p.category == _selectedCategory).toList();

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.68,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (ctx, i) {
                    final p = filtered[i];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: AppImage(
                                  url: p.images.first,
                                  width: double.infinity,
                                  placeholderIcon: Icons.local_florist,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              p.title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            RatingStars(rating: p.rating, showText: false),
                            const SizedBox(height: 4),
                            Text(
                              Formatters.currency(p.price),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryGreen,
                              ),
                            ),
                            const SizedBox(height: 8),
                            CustomButton(
                              text: 'Add to Cart',
                              height: 34,
                              onPressed: () {
                                ref.read(cartProvider.notifier).addToCart(p);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Added ${p.title} to cart'),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const LoadingIndicator(message: 'Loading Agro Store supplies...'),
              error: (err, _) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}
