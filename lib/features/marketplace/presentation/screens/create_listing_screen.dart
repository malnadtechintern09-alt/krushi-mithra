import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/config/constants.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/app_image.dart';
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
  final _customLocationController = TextEditingController();

  String _category = AppConstants.marketplaceCategories[1]; // Arecanut
  String _unit = 'kg';
  String _location = AppConstants.sampleLocations[0];
  bool _isSubmitting = false;
  bool _isDetectingGps = false;

  // Selected produce pictures list (camera, gallery, or sample images)
  final List<String> _selectedImages = [];

  // Sample Produce Photos for fast selection
  static const List<Map<String, String>> _presetProducePhotos = [
    {
      'title': 'Dry Red Arecanut (Chali / Rashi)',
      'url': 'https://images.unsplash.com/photo-1546430498-05c7b929fb30?w=800',
    },
    {
      'title': 'Raw Coffee Beans (Arabica / Robusta)',
      'url': 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=800',
    },
    {
      'title': 'Black Pepper (Malnad Spice)',
      'url': 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=800',
    },
    {
      'title': 'Paddy / Harvested Rice',
      'url': 'https://images.unsplash.com/photo-1586771107445-d3ca888129ff?w=800',
    },
    {
      'title': 'Cardamom (Green Elaichi)',
      'url': 'https://images.unsplash.com/photo-1599940824399-b87987ceb72a?w=800',
    },
    {
      'title': 'Fresh Coconut Harvest',
      'url': 'https://images.unsplash.com/photo-1543362906-acfc16c67564?w=800',
    },
    {
      'title': 'Farm Machinery & Sprayer',
      'url': 'https://images.unsplash.com/photo-1592982537447-7440770cbfc9?w=800',
    },
    {
      'title': 'Organic Farm Produce & Vegetables',
      'url': 'https://images.unsplash.com/photo-1610348725531-843dff563e2c?w=800',
    },
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _qtyController.dispose();
    _descController.dispose();
    _customLocationController.dispose();
    super.dispose();
  }

  // Camera & Gallery Image Picker Handler
  Future<void> _pickProduceImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1200,
        maxHeight: 1200,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImages.add(pickedFile.path);
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(source == ImageSource.camera
                  ? '📸 Produce photo captured with camera!'
                  : '🖼️ Produce photo added from phone gallery!'),
              backgroundColor: AppColors.primaryGreen,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('[ImagePicker Produce Error] $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Camera/Gallery response error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  // Bottom Sheet Modal for Photo Options
  void _showImagePickerModal(BuildContext context) {
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
                'Add Produce / Item Photo',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.warmDarkBrown,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Upload clear photos of your crop batch, harvest, or equipment',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),

              // Option 1: Take Photo with Camera
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE8F5E9),
                  child: Icon(Icons.camera_alt_rounded, color: AppColors.primaryGreen),
                ),
                title: const Text('Take Photo with Camera', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Capture live photo of your crop or item'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickProduceImage(ImageSource.camera);
                },
              ),

              // Option 2: Choose from Photo Gallery
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFFFF3E0),
                  child: Icon(Icons.photo_library_rounded, color: Colors.orange),
                ),
                title: const Text('Choose from Photo Gallery', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Select produce photos saved in phone gallery'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickProduceImage(ImageSource.gallery);
                },
              ),

              // Option 3: Select Sample Crop Photo
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE1F5FE),
                  child: Icon(Icons.eco_rounded, color: Color(0xFF0288D1)),
                ),
                title: const Text('Select Sample Produce Photo', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Pick from high-quality Arecanut, Coffee, Pepper sample photos'),
                onTap: () {
                  Navigator.pop(ctx);
                  _showPresetImagePicker(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Sample Produce Image Selection Dialog
  void _showPresetImagePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Select Sample Crop Photo',
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.warmDarkBrown),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _presetProducePhotos.length,
              itemBuilder: (context, idx) {
                final preset = _presetProducePhotos[idx];
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AppImage(
                      url: preset['url']!,
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(preset['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  onTap: () {
                    setState(() {
                      _selectedImages.add(preset['url']!);
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Selected sample image: ${preset['title']}'),
                        backgroundColor: AppColors.primaryGreen,
                      ),
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Detect GPS Farm Location Simulation
  Future<void> _detectGpsLocation() async {
    setState(() => _isDetectingGps = true);
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;
    setState(() {
      _isDetectingGps = false;
      _location = 'Shivamogga, KA';
      _customLocationController.text = 'Thirthahalli Road, Shivamogga (GPS Pinpoint)';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('📍 Farm Location GPS detected: Shivamogga, Karnataka'),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
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
              // --- SECTION 1: PRODUCE PICTURE / PHOTO UPLOAD ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Produce / Item Photos',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.warmDarkBrown),
                  ),
                  TextButton.icon(
                    onPressed: () => _showImagePickerModal(context),
                    icon: const Icon(Icons.add_a_photo_outlined, size: 18, color: AppColors.primaryGreen),
                    label: const Text('Add Photo', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryGreen)),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // Selected Images horizontal list view or add button banner
              if (_selectedImages.isEmpty) ...[
                GestureDetector(
                  onTap: () => _showImagePickerModal(context),
                  child: Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primaryGreen.withOpacity(0.5), width: 1.5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.camera_alt_outlined, size: 36, color: AppColors.primaryGreen),
                        SizedBox(height: 8),
                        Text(
                          'Tap to Upload Produce Photo (Camera / Gallery)',
                          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryGreen, fontSize: 13),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Add clear photos of your harvest batch to attract buyers',
                          style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                SizedBox(
                  height: 110,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectedImages.length + 1,
                    itemBuilder: (ctx, index) {
                      if (index == _selectedImages.length) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: InkWell(
                            onTap: () => _showImagePickerModal(context),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: 95,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.add_photo_alternate_rounded, color: AppColors.primaryGreen, size: 28),
                                  SizedBox(height: 4),
                                  Text('Add More', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        );
                      }

                      final imgPath = _selectedImages[index];
                      return Container(
                        margin: const EdgeInsets.only(right: 12),
                        width: 100,
                        height: 100,
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: AppImage(
                                url: imgPath,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedImages.removeAt(index);
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Color(0xB3000000),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.close_rounded, size: 14, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
              const SizedBox(height: 20),

              // --- SECTION 2: PRODUCE / ITEM NAME & CATEGORY ---
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

              // --- SECTION 3: PRICE & UNIT ---
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
                            DropdownMenuItem(value: 'ton', child: Text('per ton')),
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

              // --- SECTION 4: FARM LOCATION & GPS DETECTION ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Farm Location', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  InkWell(
                    onTap: _isDetectingGps ? null : _detectGpsLocation,
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      child: Row(
                        children: [
                          if (_isDetectingGps) ...[
                            const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryGreen),
                            ),
                          ] else ...[
                            const Icon(Icons.my_location_rounded, size: 16, color: AppColors.primaryGreen),
                          ],
                          const SizedBox(width: 4),
                          Text(
                            _isDetectingGps ? 'Detecting GPS...' : 'Detect GPS',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _location,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.location_on_rounded, color: AppColors.primaryGreen),
                  border: OutlineInputBorder(),
                ),
                items: AppConstants.sampleLocations
                    .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _location = val);
                },
              ),
              const SizedBox(height: 10),
              CustomTextField(
                label: 'Village / Taluk / Farm Address (Optional)',
                hint: 'e.g. Anandapuram Village, Sagara Taluk',
                controller: _customLocationController,
              ),
              const SizedBox(height: 16),

              // --- SECTION 5: DESCRIPTION & HARVEST QUALITY ---
              CustomTextField(
                label: 'Description & Harvest Quality',
                hint: 'Specify harvest batch date, processing method, moisture content, grade...',
                controller: _descController,
                maxLines: 3,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 24),

              // --- SUBMIT BUTTON ---
              CustomButton(
                text: 'Post Listing on Marketplace',
                isLoading: _isSubmitting,
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  setState(() => _isSubmitting = true);

                  // Combine selected location dropdown and custom village input if present
                  final finalLocation = _customLocationController.text.trim().isNotEmpty
                      ? '${_customLocationController.text.trim()}, $_location'
                      : _location;

                  // Use selected images or default produce image fallback
                  final finalImages = _selectedImages.isNotEmpty
                      ? _selectedImages
                      : ['https://images.unsplash.com/photo-1546430498-05c7b929fb30?w=800'];

                  final product = Product(
                    id: 'p_${DateTime.now().millisecondsSinceEpoch}',
                    title: _titleController.text.trim(),
                    category: _category,
                    sellerId: user?.id ?? 'user_1',
                    sellerName: user?.name ?? 'Ramesh Gowda',
                    sellerPhone: user?.phone ?? '+91 9876543210',
                    images: finalImages,
                    description: _descController.text.trim(),
                    price: double.tryParse(_priceController.text.trim()) ?? 100.0,
                    unit: _unit,
                    quantityAvailable: double.tryParse(_qtyController.text.trim()) ?? 50.0,
                    location: finalLocation,
                    isAgroStoreItem: false,
                  );

                  await ref.read(marketplaceRepositoryProvider).addProduct(product);
                  ref.invalidate(marketplaceProductsProvider);

                  if (mounted) {
                    setState(() => _isSubmitting = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('🎉 Farm Produce Listing Published Successfully!'),
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
