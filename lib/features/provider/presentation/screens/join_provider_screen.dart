import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class JoinProviderScreen extends ConsumerStatefulWidget {
  const JoinProviderScreen({super.key});

  @override
  ConsumerState<JoinProviderScreen> createState() => _JoinProviderScreenState();
}

class _JoinProviderScreenState extends ConsumerState<JoinProviderScreen> {
  int _currentStep = 1;

  // Step 1: Personal
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _villageController;
  String _selectedState = 'Karnataka';
  String _selectedDistrict = 'Shivamogga';
  String _selectedTaluk = 'Shivamogga Taluk';

  // Step 2: Service Type
  String _serviceType = 'Rent My Machine';
  String _selectedCategory = 'Tractors';

  // Step 3: Machine / Skill Specs
  final _machineNameController = TextEditingController(text: 'Mahindra 575 DI Tractor (45 HP)');
  final _brandController = TextEditingController(text: 'Mahindra');
  final _modelController = TextEditingController(text: '575 DI');
  final _hpController = TextEditingController(text: '45 HP');
  final _yearController = TextEditingController(text: '2023');
  final _descController = TextEditingController(text: 'Heavy duty 45 HP Mahindra tractor with rotavator attachment.');

  // Step 4: Photos & Documents
  final List<String> _photos = [
    'assets/images/mahindra_575_di.jpg',
    'https://images.unsplash.com/photo-1592861956120-e524fc739696?w=800'
  ];
  bool _rcUploaded = true;
  bool _insuranceUploaded = true;

  // Step 5: Pricing & Availability
  String _rentalType = 'Per Day';
  final _priceController = TextEditingController(text: '2200');
  final _depositController = TextEditingController(text: '1000');
  bool _operatorIncluded = true;
  bool _fuelIncluded = false;
  int _serviceRadiusKm = 25;

  // Step 6: Agreements
  bool _termsAccepted = false;
  bool _rulesAccepted = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).value;
    _nameController = TextEditingController(text: user?.name ?? 'Bharath Poojary');
    _phoneController = TextEditingController(text: user?.phone ?? '+91 8904089051');
    _emailController = TextEditingController(text: user?.email ?? 'bharath.poojary@krushimithra.com');
    _villageController = TextEditingController(text: 'Thirthahalli Road');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _villageController.dispose();
    _machineNameController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _hpController.dispose();
    _yearController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _depositController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 6) {
      setState(() => _currentStep++);
    }
  }

  void _prevStep() {
    if (_currentStep > 1) {
      setState(() => _currentStep--);
    }
  }

  Future<void> _submitApplication() async {
    if (!_termsAccepted || !_rulesAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept Krushi Mithra Terms & Conditions before submitting.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    final user = ref.read(authProvider).value;

    final appData = {
      'userId': user?.id ?? 'usr_101',
      'userName': _nameController.text.trim(),
      'userPhone': _phoneController.text.trim(),
      'userEmail': _emailController.text.trim(),
      'userLocation': '$_selectedDistrict, KA',
      'village': _villageController.text.trim(),
      'taluk': _selectedTaluk,
      'district': _selectedDistrict,
      'state': _selectedState,
      'profilePhoto': user?.profilePhoto ?? 'https://images.unsplash.com/photo-1595273670150-bd0c3c392e46?w=400',
      'serviceType': _serviceType,
      'machineName': _machineNameController.text.trim(),
      'category': _selectedCategory,
      'brand': _brandController.text.trim(),
      'model': _modelController.text.trim(),
      'manufacturingYear': int.tryParse(_yearController.text) ?? 2023,
      'horsePower': _hpController.text.trim(),
      'description': _descController.text.trim(),
      'rentalType': _rentalType,
      'rentalPricePerDay': double.tryParse(_priceController.text) ?? 2200.0,
      'securityDeposit': double.tryParse(_depositController.text) ?? 1000.0,
      'operatorIncluded': _operatorIncluded,
      'fuelIncluded': _fuelIncluded,
      'serviceRadiusKm': _serviceRadiusKm,
      'images': _photos,
      'documents': [
        {'name': 'Tractor RC Copy', 'status': _rcUploaded ? 'Uploaded' : 'Not Uploaded'},
        {'name': 'Insurance Policy', 'status': _insuranceUploaded ? 'Uploaded' : 'Not Uploaded'},
      ],
      'agreementAccepted': true,
      'acceptedDate': DateTime.now().toString().split('.')[0],
    };

    final result = await ApiService().submitProviderApplication(appData);
    setState(() => _isSubmitting = false);

    if (mounted) {
      final appId = result?['applicationId'] ?? 'KM-APP-10245';
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Row(
              children: [
                Icon(Icons.check_circle_rounded, color: AppColors.success, size: 28),
                SizedBox(width: 10),
                Text('Application Submitted!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Unique Application ID: $appId', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryGreenDark)),
                const SizedBox(height: 10),
                const Text(
                  'Our verification team will review your application and documents. Your machine/service will become visible to other farmers immediately after Admin approval.',
                  style: TextStyle(fontSize: 13, height: 1.3),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  context.pushReplacement('/provider/my-applications');
                },
                child: const Text('Track Application Status'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(
        backgroundColor: AppColors.warmBackground,
        elevation: 0,
        title: const Text(
          'Join as Worker / Machine Owner',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: AppColors.warmDarkBrown),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // STEP PROGRESS INDICATOR
            Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      final stepNum = index + 1;
                      final isActive = stepNum == _currentStep;
                      final isDone = stepNum < _currentStep;

                      return Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDone
                                    ? AppColors.primaryGreen
                                    : (isActive ? AppColors.accentGold : Colors.grey.shade300),
                              ),
                              child: Center(
                                child: isDone
                                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                                    : Text(
                                        '$stepNum',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: isActive ? AppColors.warmDarkBrown : Colors.grey.shade700,
                                        ),
                                      ),
                              ),
                            ),
                            if (index < 5)
                              Expanded(
                                child: Container(
                                  height: 2,
                                  color: isDone ? AppColors.primaryGreen : Colors.grey.shade300,
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getStepTitle(_currentStep),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.warmDarkBrown),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: _buildStepContent(_currentStep),
              ),
            ),

            // NAVIGATION BUTTONS BAR
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                children: [
                  if (_currentStep > 1)
                    Expanded(
                      child: CustomButton(
                        text: 'Back',
                        isOutlined: true,
                        onPressed: _prevStep,
                      ),
                    ),
                  if (_currentStep > 1) const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      text: _currentStep == 6 ? 'Submit Application' : 'Next Step',
                      isLoading: _isSubmitting,
                      onPressed: _currentStep == 6 ? _submitApplication : _nextStep,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 1: return 'Step 1: Personal Details';
      case 2: return 'Step 2: Select Service Type';
      case 3: return 'Step 3: Machine / Service Specs';
      case 4: return 'Step 4: Photos & Documents';
      case 5: return 'Step 5: Pricing & Availability';
      case 6: return 'Step 6: Agreement & Summary';
      default: return '';
    }
  }

  Widget _buildStepContent(int step) {
    switch (step) {
      case 1: return _buildStep1Personal();
      case 2: return _buildStep2ServiceType();
      case 3: return _buildStep3Specs();
      case 4: return _buildStep4PhotosDocs();
      case 5: return _buildStep5Pricing();
      case 6: return _buildStep6AgreementSummary();
      default: return const SizedBox();
    }
  }

  // STEP 1: Personal Details
  Widget _buildStep1Personal() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Account Information', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            const Text('Pre-loaded from your existing logged-in account.', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email Address', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            const Text('Service Location Hierarchy', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedDistrict,
              decoration: const InputDecoration(labelText: 'District', border: OutlineInputBorder()),
              items: ['Shivamogga', 'Chikamagaluru', 'Hassan', 'Mandya', 'Udupi', 'Davanagere'].map((d) {
                return DropdownMenuItem(value: d, child: Text(d));
              }).toList(),
              onChanged: (val) => setState(() => _selectedDistrict = val!),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: _selectedTaluk,
              decoration: const InputDecoration(labelText: 'Taluk', border: OutlineInputBorder()),
              items: ['Shivamogga Taluk', 'Bhadravati', 'Sagara', 'Thirthahalli', 'Shikaripura', 'Koppa', 'Maddur'].map((t) {
                return DropdownMenuItem(value: t, child: Text(t));
              }).toList(),
              onChanged: (val) => setState(() => _selectedTaluk = val!),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _villageController,
              decoration: const InputDecoration(labelText: 'Village / Street Address', border: OutlineInputBorder()),
            ),
          ],
        ),
      ),
    );
  }

  // STEP 2: Service Type
  Widget _buildStep2ServiceType() {
    final serviceOptions = [
      {'title': 'Rent My Machine', 'desc': 'List tractors, harvesters, tillers or implements for rent'},
      {'title': 'Work as Driver', 'desc': 'Offer services as a skilled tractor/harvester operator'},
      {'title': 'Work as Farm Worker', 'desc': 'Offer services for Arecanut, paddy or general farm labor'},
      {'title': 'Rent Machine + Provide Operator', 'desc': 'Provide machine along with an experienced driver'},
    ];

    final machineCats = [
      'Tractors', 'Harvesters', 'Power Tillers', 'Rotavators', 'Cultivators',
      'Seeders', 'Ploughs', 'Trailers', 'Brush Cutters', 'Sprayers',
      'Water Pumps', 'Borewell Machines', 'Wical Machines', 'Threshers', 'Reapers', 'Transplanters', 'Other Agricultural Equipment'
    ];

    final workerCats = [
      'Tractor Driver', 'Harvester Operator', 'Power Tiller Operator', 'Arecanut Worker', 'Paddy Worker', 'Harvesting Team', 'General Farm Worker'
    ];

    final categories = _serviceType.contains('Machine') ? machineCats : workerCats;

    return Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('What would you like to offer?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                ...serviceOptions.map((opt) {
                  final isSelected = _serviceType == opt['title'];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFE8F5E9) : Colors.white,
                      border: Border.all(color: isSelected ? AppColors.primaryGreen : AppColors.warmBorder, width: isSelected ? 2 : 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: RadioListTile<String>(
                      value: opt['title']!,
                      groupValue: _serviceType,
                      title: Text(opt['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(opt['desc']!, style: const TextStyle(fontSize: 12)),
                      activeColor: AppColors.primaryGreen,
                      onChanged: (val) {
                        setState(() {
                          _serviceType = val!;
                          _selectedCategory = _serviceType.contains('Machine') ? 'Tractors' : 'Tractor Driver';
                        });
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Select Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: categories.contains(_selectedCategory) ? _selectedCategory : categories.first,
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                  items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (val) => setState(() => _selectedCategory = val!),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // STEP 3: Specs
  Widget _buildStep3Specs() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Machine / Service Specification', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 14),
            TextField(
              controller: _machineNameController,
              decoration: const InputDecoration(labelText: 'Title / Model Name *', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _brandController,
                    decoration: const InputDecoration(labelText: 'Brand', border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _modelController,
                    decoration: const InputDecoration(labelText: 'Model Number', border: OutlineInputBorder()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _hpController,
                    decoration: const InputDecoration(labelText: 'Horse Power (HP)', border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _yearController,
                    decoration: const InputDecoration(labelText: 'Manufacturing Year', border: OutlineInputBorder()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _descController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Description & Attachments Included', border: OutlineInputBorder()),
            ),
          ],
        ),
      ),
    );
  }

  // STEP 4: Photos & Docs
  Widget _buildStep4PhotosDocs() {
    return Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Machine Photos (Front, Side, Back)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 10),
                Row(
                  children: _photos.map((p) {
                    return Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(image: NetworkImage(p), fit: BoxFit.cover),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Camera/Gallery photo upload simulation completed')),
                    );
                  },
                  icon: const Icon(Icons.add_a_photo_rounded),
                  label: const Text('Add Machine Photo'),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Supporting Verification Documents', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 10),
                CheckboxListTile(
                  title: const Text('Tractor / Machine RC Copy'),
                  subtitle: const Text('RC Document Uploaded'),
                  value: _rcUploaded,
                  onChanged: (val) => setState(() => _rcUploaded = val!),
                ),
                CheckboxListTile(
                  title: const Text('Vehicle Insurance Document'),
                  subtitle: const Text('Insurance Uploaded'),
                  value: _insuranceUploaded,
                  onChanged: (val) => setState(() => _insuranceUploaded = val!),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // STEP 5: Pricing
  Widget _buildStep5Pricing() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Rental Pricing & Availability Options', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: _rentalType,
              decoration: const InputDecoration(labelText: 'Rental Basis', border: OutlineInputBorder()),
              items: ['Per Day', 'Per Hour', 'Per Half Day', 'Per Acre'].map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
              onChanged: (val) => setState(() => _rentalType = val!),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _priceController,
                    decoration: const InputDecoration(labelText: 'Rental Rate (₹) *', border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _depositController,
                    decoration: const InputDecoration(labelText: 'Security Deposit (₹)', border: OutlineInputBorder()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SwitchListTile(
              title: const Text('Driver / Operator Included?'),
              subtitle: const Text('Provide machine operator along with vehicle'),
              value: _operatorIncluded,
              activeColor: AppColors.primaryGreen,
              onChanged: (val) => setState(() => _operatorIncluded = val),
            ),
            const SizedBox(height: 10),
            Text('Service Distance Radius: $_serviceRadiusKm km', style: const TextStyle(fontWeight: FontWeight.bold)),
            Slider(
              value: _serviceRadiusKm.toDouble(),
              min: 5,
              max: 100,
              divisions: 19,
              label: '$_serviceRadiusKm km',
              activeColor: AppColors.primaryGreen,
              onChanged: (val) => setState(() => _serviceRadiusKm = val.toInt()),
            ),
          ],
        ),
      ),
    );
  }

  // STEP 6: Agreement & Summary
  Widget _buildStep6AgreementSummary() {
    return Column(
      children: [
        Card(
          color: const Color(0xFFFFF8E7),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.assignment_turned_in_rounded, color: AppColors.primaryGreen),
                    SizedBox(width: 8),
                    Text('APPLICATION SUMMARY', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                const Divider(),
                Text('Applicant: ${_nameController.text} (${_phoneController.text})'),
                Text('Service: $_serviceType ($_selectedCategory)'),
                Text('Machine/Skill: ${_machineNameController.text}'),
                Text('Location: ${_villageController.text}, $_selectedDistrict'),
                Text('Rental Price: ₹${_priceController.text}/$_rentalType'),
                Text('Service Radius: Within $_serviceRadiusKm km'),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Platform Agreement & Rules', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 10),
                CheckboxListTile(
                  title: const Text('I confirm that all machine ownership & service details submitted by me are true and accurate.'),
                  value: _termsAccepted,
                  activeColor: AppColors.primaryGreen,
                  onChanged: (val) => setState(() => _termsAccepted = val!),
                ),
                CheckboxListTile(
                  title: const Text('I agree to adhere to Krushi Mithra safety rules and rental policies.'),
                  value: _rulesAccepted,
                  activeColor: AppColors.primaryGreen,
                  onChanged: (val) => setState(() => _rulesAccepted = val!),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
