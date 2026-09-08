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
import '../../../workers/domain/entities/worker.dart';
import '../../../../shared/providers/repository_providers.dart';
import '../providers/worker_provider.dart';

class RegisterWorkerScreen extends ConsumerStatefulWidget {
  const RegisterWorkerScreen({super.key});

  @override
  ConsumerState<RegisterWorkerScreen> createState() => _RegisterWorkerScreenState();
}

class _RegisterWorkerScreenState extends ConsumerState<RegisterWorkerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _rateController = TextEditingController();
  final _expController = TextEditingController();
  final _bioController = TextEditingController();
  String _selectedSkill = AppConstants.workerSkills[1]; // Tractor Driver
  String _location = AppConstants.sampleLocations[0];
  bool _isSubmitting = false;
  bool _isAvailable = true;
  String _availabilityStatus = 'Available';

  // Selected Profile & ID Photo
  String _profilePhoto = 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400';

  // Preset Sample Worker & Driver Profile Photos
  final List<Map<String, String>> _sampleWorkerPhotos = [
    {
      'title': 'Tractor Driver / Operator',
      'url': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
    },
    {
      'title': 'Harvester Machine Specialist',
      'url': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400',
    },
    {
      'title': 'Arecanut & Paddy Worker',
      'url': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400',
    },
    {
      'title': 'Heavy Equipment Driver',
      'url': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400',
    },
    {
      'title': 'Farm Labor Supervisor',
      'url': 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=400',
    },
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _rateController.dispose();
    _expController.dispose();
    _bioController.dispose();
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
          'Register as Worker / Operator',
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
              // ----------------------------------------------------
              // PROFILE PHOTO & PICTURE ADDING SECTION
              // ----------------------------------------------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.warmBorder, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.badge_outlined, color: AppColors.primaryGreen, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Worker Profile & ID Photo',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: AppColors.warmDarkBrown,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Upload a clear face photo to build trust with farmers.',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // Avatar Circle with Camera Badge overlay
                    GestureDetector(
                      onTap: () => _showImagePickerModal(context),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.primaryGreen, width: 2.5),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: AppImage(
                                url: _profilePhoto,
                                width: 105,
                                height: 105,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 2,
                            right: 2,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primaryGreen,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    OutlinedButton.icon(
                      onPressed: () => _showImagePickerModal(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryGreen,
                        side: const BorderSide(color: AppColors.primaryGreen, width: 1.2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      ),
                      icon: const Icon(Icons.add_a_photo_outlined, size: 18),
                      label: const Text(
                        'Add / Change Photo',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ----------------------------------------------------
              // FORM FIELDS
              // ----------------------------------------------------
              CustomTextField(
                label: 'Full Name',
                controller: _nameController..text = _nameController.text.isNotEmpty ? _nameController.text : (user?.name ?? ''),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: 'Phone Number',
                controller: _phoneController..text = _phoneController.text.isNotEmpty ? _phoneController.text : (user?.phone ?? ''),
                keyboardType: TextInputType.phone,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              const Text('Primary Skill', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.warmDarkBrown)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _selectedSkill,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.warmBorder),
                  ),
                ),
                items: AppConstants.workerSkills
                    .where((s) => s != 'All')
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedSkill = val);
                },
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'Experience (Years)',
                      hint: 'e.g. 5',
                      controller: _expController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      label: 'Daily Rate (₹)',
                      hint: 'e.g. 800',
                      controller: _rateController,
                      keyboardType: TextInputType.number,
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              const Text('Base Location', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.warmDarkBrown)),
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

              // ----------------------------------------------------
              // AVAILABILITY STATUS (AVAILABLE / BUSY OPTIONS)
              // ----------------------------------------------------
              const Text('Work Availability Status', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.warmDarkBrown)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _isAvailable = true;
                        _availabilityStatus = 'Available';
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                        decoration: BoxDecoration(
                          color: _isAvailable ? const Color(0xFFE8F5E9) : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _isAvailable ? AppColors.primaryGreen : AppColors.warmBorder,
                            width: _isAvailable ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Available',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: _isAvailable ? AppColors.primaryGreen : AppColors.warmDarkBrown,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _isAvailable = false;
                        _availabilityStatus = 'Busy';
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                        decoration: BoxDecoration(
                          color: !_isAvailable ? const Color(0xFFFFEBEE) : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: !_isAvailable ? Colors.red : AppColors.warmBorder,
                            width: !_isAvailable ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Busy / On Duty',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: !_isAvailable ? Colors.red : AppColors.warmDarkBrown,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: 'Bio / Experience Details',
                hint: 'Describe your expertise, machinery handled, team size if any...',
                controller: _bioController,
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              CustomButton(
                text: 'Complete Registration',
                isLoading: _isSubmitting,
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  setState(() => _isSubmitting = true);

                  final worker = Worker(
                    id: 'w_${DateTime.now().millisecondsSinceEpoch}',
                    name: _nameController.text.trim(),
                    phone: _phoneController.text.trim(),
                    skills: [_selectedSkill],
                    experienceYears: int.tryParse(_expController.text.trim()) ?? 3,
                    location: _location,
                    latitude: 13.9299,
                    longitude: 75.5681,
                    dailyRate: double.tryParse(_rateController.text.trim()) ?? 800.0,
                    isAvailable: _isAvailable,
                    availabilityStatus: _availabilityStatus,
                    isVerified: true,
                    profilePhoto: _profilePhoto,
                    bio: _bioController.text.trim().isNotEmpty
                        ? _bioController.text.trim()
                        : 'Skilled agricultural operator available for field assignment.',
                  );

                  await ref.read(workerRepositoryProvider).registerWorker(worker);
                  ref.invalidate(workerListProvider);

                  if (mounted) {
                    setState(() => _isSubmitting = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('✅ Worker details saved & submitted to Admin Panel for approval!'),
                        backgroundColor: AppColors.primaryGreen,
                        duration: Duration(seconds: 4),
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

  // ImagePicker Handler for Camera and Gallery
  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1000,
        maxHeight: 1000,
      );

      if (pickedFile != null) {
        setState(() {
          _profilePhoto = pickedFile.path;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(source == ImageSource.camera
                  ? '📸 Photo captured with camera!'
                  : '🖼️ Photo selected from phone gallery!'),
              backgroundColor: AppColors.primaryGreen,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('[ImagePicker Error] $e');
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

  // ----------------------------------------------------
  // PHOTO PICKER BOTTOM SHEET MODAL
  // ----------------------------------------------------
  void _showImagePickerModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Worker Profile Photo',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.warmDarkBrown,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Select photo source for worker profile & ID verification',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),

              // Option 1: Take Photo with Camera
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE8F5E9),
                  child: Icon(Icons.camera_alt_rounded, color: AppColors.primaryGreen),
                ),
                title: const Text('Take Selfie with Camera', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: const Text('Capture live photo using smartphone camera'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.camera);
                },
              ),

              // Option 2: Choose from Photo Gallery
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFFFF3E0),
                  child: Icon(Icons.photo_library_rounded, color: Colors.orange),
                ),
                title: const Text('Choose from Photo Gallery', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: const Text('Select profile photo from your phone gallery'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.gallery);
                },
              ),

              // Option 3: Pick Sample Worker Avatar
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFF3E5F5),
                  child: Icon(Icons.face_retouching_natural_rounded, color: Color(0xFF7E57C2)),
                ),
                title: const Text('Select Sample Worker Photo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: const Text('Choose from sample operator avatars'),
                onTap: () {
                  Navigator.pop(ctx);
                  _showSamplePhotoDialog(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Preset Sample Worker Photos Selection Dialog
  void _showSamplePhotoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Select Sample Worker Avatar',
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.warmDarkBrown),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _sampleWorkerPhotos.length,
              itemBuilder: (context, idx) {
                final preset = _sampleWorkerPhotos[idx];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(preset['url']!),
                    radius: 22,
                  ),
                  title: Text(preset['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  onTap: () {
                    setState(() {
                      _profilePhoto = preset['url']!;
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Updated profile photo to ${preset['title']}'),
                        backgroundColor: AppColors.primaryGreen,
                      ),
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
