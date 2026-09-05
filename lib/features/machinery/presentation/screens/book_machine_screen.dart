import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/app_image.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../bookings_orders/domain/entities/booking.dart';
import '../../../bookings_orders/presentation/providers/bookings_orders_provider.dart';
import '../../../../shared/providers/repository_providers.dart';
import '../providers/machinery_provider.dart';

class BookMachineScreen extends ConsumerStatefulWidget {
  final String machineId;

  const BookMachineScreen({super.key, required this.machineId});

  @override
  ConsumerState<BookMachineScreen> createState() => _BookMachineScreenState();
}

class _BookMachineScreenState extends ConsumerState<BookMachineScreen> {
  DateTime _startDate = DateTime.now().add(const Duration(days: 1));
  DateTime _endDate = DateTime.now().add(const Duration(days: 2));
  final _locationController = TextEditingController(text: 'Shivamogga Farm Land, KA');
  String _paymentMethod = 'Pay on Delivery / Cash';
  bool _isSubmitting = false;

  int get _numberOfDays {
    final diff = _endDate.difference(_startDate).inDays;
    return diff <= 0 ? 1 : diff;
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final machineAsync = ref.watch(machineDetailProvider(widget.machineId));
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
        title: const Text('Confirm Machine Rental'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_rounded, color: Colors.white),
            tooltip: 'Return to Home',
            onPressed: () => context.go('/'),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: machineAsync.when(
        data: (m) {
          if (m == null) return const Center(child: Text('Machine not found'));
          final totalCost = m.rentalPricePerDay * _numberOfDays;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: AppImage(
                            url: m.images.first,
                            width: 70,
                            height: 70,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(m.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 4),
                              Text('${Formatters.currency(m.rentalPricePerDay)} / day',
                                  style: const TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
                              Text('Owner: ${m.ownerName}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Select Rental Duration
                const Text('Rental Duration', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.calendar_today, size: 18),
                        label: Text('From: ${Formatters.date(_startDate)}'),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _startDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 90)),
                          );
                          if (picked != null) {
                            setState(() {
                              _startDate = picked;
                              if (_endDate.isBefore(_startDate)) {
                                _endDate = _startDate.add(const Duration(days: 1));
                              }
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.calendar_today, size: 18),
                        label: Text('To: ${Formatters.date(_endDate)}'),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _endDate,
                            firstDate: _startDate,
                            lastDate: DateTime.now().add(const Duration(days: 90)),
                          );
                          if (picked != null) {
                            setState(() {
                              _endDate = picked;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Delivery Location
                CustomTextField(
                  label: 'Service Location Address',
                  controller: _locationController,
                  prefixIcon: Icons.location_on,
                ),
                const SizedBox(height: 20),

                // Payment Method
                const Text('Payment Method', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _paymentMethod,
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                  items: const [
                    DropdownMenuItem(value: 'Pay on Delivery / Cash', child: Text('Pay on Delivery / Cash')),
                    DropdownMenuItem(value: 'UPI / Online Payment', child: Text('UPI / Online Payment')),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _paymentMethod = val);
                  },
                ),
                const SizedBox(height: 24),

                // Cost Breakdown Card
                Card(
                  color: AppColors.chipBackground,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Daily Rate (x$_numberOfDays days)', style: const TextStyle(fontSize: 14)),
                            Text(Formatters.currency(m.rentalPricePerDay * _numberOfDays)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Delivery / Operator Charges', style: TextStyle(fontSize: 14)),
                            Text('FREE'),
                          ],
                        ),
                        const Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Payable', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(Formatters.currency(totalCost),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primaryGreen)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Confirm Button
                CustomButton(
                  text: 'Confirm Booking (${Formatters.currency(totalCost)})',
                  isLoading: _isSubmitting,
                  onPressed: () async {
                    setState(() => _isSubmitting = true);

                    final booking = Booking(
                      id: 'b_${DateTime.now().millisecondsSinceEpoch}',
                      bookingType: 'machine',
                      targetId: m.id,
                      targetTitle: m.name,
                      targetImageUrl: m.images.first,
                      customerId: user?.id ?? 'user_1',
                      customerName: user?.name ?? 'Ramesh Gowda',
                      customerPhone: user?.phone ?? '+91 9876543210',
                      providerId: m.ownerId,
                      providerName: m.ownerName,
                      providerPhone: m.ownerPhone,
                      startDate: _startDate,
                      endDate: _endDate,
                      totalAmount: totalCost,
                      paymentMethod: _paymentMethod,
                      paymentStatus: 'Pending',
                      bookingStatus: 'Confirmed',
                      createdAt: DateTime.now(),
                      serviceLocation: _locationController.text,
                    );

                    await ref.read(bookingRepositoryProvider).createBooking(booking);
                    ref.invalidate(userBookingsProvider);

                    if (mounted) {
                      setState(() => _isSubmitting = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('🎉 Machine Booking Confirmed! Track under My Orders.'),
                          backgroundColor: AppColors.primaryGreen,
                        ),
                      );
                      context.go('/my-orders');
                    }
                  },
                ),
              ],
            ),
          );
        },
        loading: () => const LoadingIndicator(),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
