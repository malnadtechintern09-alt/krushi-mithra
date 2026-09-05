import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/config/constants.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../marketplace/domain/entities/product.dart';
import '../../../../shared/providers/repository_providers.dart';
import '../providers/marketplace_provider.dart';

class CreateListingScreen extends ConsumerStatefulWidget {
  const CreateListingScreen({super.key});

  @override
  ConsumerState<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends ConsumerState<CreateListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _qtyController = TextEditingController();
  final _descController = TextEditingController();
  String _category = AppConstants.marketplaceCategories[1]; // Arecanut
  String _unit = 'kg';
  String _location = AppConstants.sampleLocations[0];
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _qtyController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).value;

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
        title: const Text('Post Produce / Item for Sale'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_rounded, color: Colors.white),
            tooltip: 'Return to Home',
            onPressed: () => context.go('/'),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                label: 'Produce / Item Name',
                hint: 'e.g. Red Rashi Arecanut (Dry)',
                controller: _titleController,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              const Text('Category', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: AppConstants.marketplaceCategories
                    .where((c) => c != 'All')
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _category = val);
                },
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'Price (₹)',
                      hint: 'e.g. 480',
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Unit', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          value: _unit,
                          decoration: const InputDecoration(border: OutlineInputBorder()),
                          items: const [
                            DropdownMenuItem(value: 'kg', child: Text('per kg')),
                            DropdownMenuItem(value: 'quintal', child: Text('per quintal')),
                            DropdownMenuItem(value: 'bag', child: Text('per bag')),
                            DropdownMenuItem(value: 'item', child: Text('per item')),
                          ],
                          onChanged: (val) {
                            if (val != null) setState(() => _unit = val);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: 'Quantity Available',
                hint: 'e.g. 250',
                controller: _qtyController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              const Text('Farm Location', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _location,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: AppConstants.sampleLocations
                    .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _location = val);
                },
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: 'Description & Harvest Quality',
                hint: 'Specify harvest batch date, processing method, quality grade...',
                controller: _descController,
                maxLines: 3,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 24),

              CustomButton(
                text: 'Post Listing on Marketplace',
                isLoading: _isSubmitting,
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  setState(() => _isSubmitting = true);

                  final product = Product(
                    id: 'p_${DateTime.now().millisecondsSinceEpoch}',
                    title: _titleController.text.trim(),
                    category: _category,
                    sellerId: user?.id ?? 'user_1',
                    sellerName: user?.name ?? 'Ramesh Gowda',
                    sellerPhone: user?.phone ?? '+91 9876543210',
                    images: [
                      'https://images.unsplash.com/photo-1546430498-05c7b929fb30?w=800',
                    ],
                    description: _descController.text.trim(),
                    price: double.tryParse(_priceController.text.trim()) ?? 100.0,
                    unit: _unit,
                    quantityAvailable: double.tryParse(_qtyController.text.trim()) ?? 50.0,
                    location: _location,
                    isAgroStoreItem: false,
                  );

                  await ref.read(marketplaceRepositoryProvider).addProduct(product);
                  ref.invalidate(marketplaceProductsProvider);

                  if (mounted) {
                    setState(() => _isSubmitting = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('🎉 Farm Produce Listing Published!'),
                        backgroundColor: AppColors.primaryGreen,
                      ),
                    );
                    context.pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
