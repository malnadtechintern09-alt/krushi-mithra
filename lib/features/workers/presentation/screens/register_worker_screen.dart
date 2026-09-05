import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/config/constants.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
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
              CustomTextField(
                label: 'Full Name',
                controller: _nameController..text = user?.name ?? '',
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: 'Phone Number',
                controller: _phoneController..text = user?.phone ?? '',
                keyboardType: TextInputType.phone,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              const Text('Primary Skill', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _selectedSkill,
                decoration: const InputDecoration(border: OutlineInputBorder()),
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

              const Text('Base Location', style: TextStyle(fontWeight: FontWeight.bold)),
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
                    isVerified: true,
                    profilePhoto: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
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
                        content: Text('✅ Successfully registered as a Farm Worker!'),
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
