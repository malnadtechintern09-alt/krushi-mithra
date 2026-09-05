import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/config/constants.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/app_image.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../machinery/domain/entities/machine.dart';
import '../../../../shared/providers/repository_providers.dart';
import '../providers/machinery_provider.dart';

class AddMachineScreen extends ConsumerStatefulWidget {
  const AddMachineScreen({super.key});

  @override
  ConsumerState<AddMachineScreen> createState() => _AddMachineScreenState();
}

class _AddMachineScreenState extends ConsumerState<AddMachineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  final _hpController = TextEditingController();
  String _category = AppConstants.machineCategories[1]; // Tractors
  String _location = AppConstants.sampleLocations[0]; // Shivamogga
  bool _isSubmitting = false;

  // Selected Machine & Vehicle Photos List
  final List<String> _selectedImages = [
    'assets/images/mahindra_575_di.jpg',
  ];

  // Preset Vehicle & Machine Sample Photos for quick selection
  final List<Map<String, String>> _presetMachinePhotos = [
    {
      'title': 'Red Tractor (Mahindra/Swaraj)',
      'url': 'assets/images/mahindra_575_di.jpg',
    },
    {
      'title': 'Combine Harvester (Kubota)',
      'url': 'assets/images/kubota_combine_harvester.jpg',
    },
    {
      'title': 'Borewell Rig Machine',
      'url': 'https://images.unsplash.com/photo-1541888946425-d0fbb186a5b3?w=800',
    },
    {
      'title': 'Power Tiller (VST Shakti)',
      'url': 'https://images.unsplash.com/photo-1589923188900-85dae523342b?w=800',
    },
    {
      'title': 'Heavy Duty Bush Cutter',
      'url': 'https://images.unsplash.com/photo-1617575521317-864339cd58a1?w=800',
    },
    {
      'title': 'Agricultural Sprayer Rig',
      'url': 'https://images.unsplash.com/photo-1592861956120-e524fc739696?w=800',
    },
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descController.dispose();
    _hpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).value;

    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(
        backgroundColor: AppColors.warmBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColors.warmDarkBrown),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.warmDarkBrown, size: 24),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'List Machine for Rent',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.warmDarkBrown,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Vehicle & Agricultural Machine Photo Picker Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.photo_camera_rounded, color: AppColors.primaryGreen, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Vehicle & Machine Photos',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: AppColors.warmDarkBrown,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${_selectedImages.length}/5 Added',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Upload clear photos of your tractor, harvester, tiller or borewell rig.',
                      style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 14),

                    // Horizontal Photo Thumbnail Cards + Add Button
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _selectedImages.length + 1,
                        itemBuilder: (ctx, idx) {
                          if (idx == _selectedImages.length) {
                            // Add Photo Action Card
                            return GestureDetector(
                              onTap: () => _showImagePickerModal(context),
                              child: Container(
                                width: 95,
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF7FAF4),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.primaryGreen,
                                    width: 1.2,
                                  ),
                                ),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundColor: AppColors.primaryGreen,
                                      child: Icon(Icons.add_a_photo_rounded, color: Colors.white, size: 16),
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      'Add Photo',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryGreen,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          final imgUrl = _selectedImages[idx];
                          final isMain = idx == 0;

                          return Stack(
                            children: [
                              Container(
                                width: 95,
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.warmBorder, width: 1),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: AppImage(
                                    url: imgUrl,
                                    width: 95,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),

                              // Main Photo Badge Tag
                              if (isMain)
                                Positioned(
                                  top: 6,
                                  left: 6,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryGreen,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      'Main',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 8.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),

                              // Delete Photo Button
                              Positioned(
                                top: 4,
                                right: 14,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedImages.removeAt(idx);
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.close, color: Colors.white, size: 12),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 2. Machine Details Form Fields
              CustomTextField(
                label: 'Machine Name & Model',
                hint: 'e.g. Swaraj 744 FE (48 HP) / Borewell Rig',
                controller: _nameController,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              const Text('Category', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.warmDarkBrown)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.warmBorder),
                  ),
                ),
                items: AppConstants.machineCategories
                    .where((c) => c != 'All')
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _category = val);
                },
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: 'Daily Rental Rate (₹/day)',
                hint: 'e.g. 2200',
                controller: _priceController,
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: 'Horsepower / Rig Specifications',
                hint: 'e.g. 45 HP Diesel / 1000 ft Borewell Depth',
                controller: _hpController,
              ),
              const SizedBox(height: 16),

              const Text('Location District', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.warmDarkBrown)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _location,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.warmBorder),
                  ),
                ),
                items: AppConstants.sampleLocations
                    .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _location = val);
                },
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: 'Machine Description',
                hint: 'Include attachments provided, operator availability, field suitability...',
                controller: _descController,
                maxLines: 3,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 24),

              CustomButton(
                text: 'Submit Machine Listing',
                isLoading: _isSubmitting,
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  if (_selectedImages.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please add at least 1 photo of your machine.')),
                    );
                    return;
                  }
                  setState(() => _isSubmitting = true);

                  final newMachine = Machine(
                    id: 'm_${DateTime.now().millisecondsSinceEpoch}',
                    name: _nameController.text.trim(),
                    category: _category,
                    ownerId: user?.id ?? 'user_1',
                    ownerName: user?.name ?? 'bharath poojary',
                    ownerPhone: user?.phone ?? '+91 9876543210',
                    images: _selectedImages,
                    description: _descController.text.trim(),
                    rentalPricePerDay: double.tryParse(_priceController.text.trim()) ?? 1800.0,
                    location: _location,
                    latitude: 13.9299,
                    longitude: 75.5681,
                    rating: 5.0,
                    isNew: true,
                    specs: {
                      'Power': _hpController.text.trim().isNotEmpty ? _hpController.text.trim() : 'Standard',
                      'Listed Date': 'Just Now',
                    },
                  );

                  await ref.read(machineryRepositoryProvider).addMachine(newMachine);
                  ref.invalidate(machineryListProvider);

                  if (mounted) {
                    setState(() => _isSubmitting = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('✅ Machine successfully listed for rent!'),
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

  // Vehicle & Machine Photo Picker Bottom Sheet Options Modal
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
                'Add Vehicle & Machine Photo',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.warmDarkBrown,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Select photo source for your vehicle or equipment',
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
                subtitle: const Text('Capture live photo of your tractor or machine'),
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() {
                    _selectedImages.add('assets/images/mahindra_575_di.jpg');
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('📸 Photo captured successfully!'),
                      backgroundColor: AppColors.primaryGreen,
                    ),
                  );
                },
              ),

              // Option 2: Pick from Photo Gallery
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFFFF3E0),
                  child: Icon(Icons.photo_library_rounded, color: Colors.orange),
                ),
                title: const Text('Choose from Photo Gallery', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Select existing vehicle photo from phone gallery'),
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() {
                    _selectedImages.add('assets/images/kubota_combine_harvester.jpg');
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('🖼️ Photo added from gallery!'),
                      backgroundColor: AppColors.primaryGreen,
                    ),
                  );
                },
              ),

              // Option 3: Select Preset Machine Photo
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFF3E5F5),
                  child: Icon(Icons.agriculture_rounded, color: Color(0xFF7E57C2)),
                ),
                title: const Text('Select Sample Machine Image', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Choose from high quality tractor & rig sample photos'),
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

  // Preset Machine Image Selection Dialog
  void _showPresetImagePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Select Sample Photo',
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.warmDarkBrown),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _presetMachinePhotos.length,
              itemBuilder: (context, idx) {
                final preset = _presetMachinePhotos[idx];
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
                      SnackBar(content: Text('Added ${preset['title']} photo')),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
