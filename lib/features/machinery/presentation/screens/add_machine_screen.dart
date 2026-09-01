import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/config/constants.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
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
      appBar: AppBar(
        title: const Text('List Machine for Rent'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                label: 'Machine Name & Model',
                hint: 'e.g. Swaraj 744 FE (48 HP)',
                controller: _nameController,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              const Text('Category', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(border: OutlineInputBorder()),
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
                hint: 'e.g. 2000',
                controller: _priceController,
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: 'Horsepower / Power Specs',
                hint: 'e.g. 45 HP Diesel Engine',
                controller: _hpController,
              ),
              const SizedBox(height: 16),

              const Text('Location District', style: TextStyle(fontWeight: FontWeight.bold)),
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
                label: 'Machine Description',
                hint: 'Include attachments provided, operator availability, etc.',
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
                  setState(() => _isSubmitting = true);

                  final newMachine = Machine(
                    id: 'm_${DateTime.now().millisecondsSinceEpoch}',
                    name: _nameController.text.trim(),
                    category: _category,
                    ownerId: user?.id ?? 'user_1',
                    ownerName: user?.name ?? 'Ramesh Gowda',
                    ownerPhone: user?.phone ?? '+91 9876543210',
                    images: [
                      'https://images.unsplash.com/photo-1592861956120-e524fc739696?w=800',
                    ],
                    description: _descController.text.trim(),
                    rentalPricePerDay: double.tryParse(_priceController.text.trim()) ?? 1500.0,
                    location: _location,
                    latitude: 13.9299,
                    longitude: 75.5681,
                    rating: 5.0,
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
}
