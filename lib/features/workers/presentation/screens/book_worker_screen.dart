import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../bookings_orders/domain/entities/booking.dart';
import '../../../bookings_orders/presentation/providers/bookings_orders_provider.dart';
import '../../../../shared/providers/repository_providers.dart';
import '../providers/worker_provider.dart';

class BookWorkerScreen extends ConsumerStatefulWidget {
  final String workerId;

  const BookWorkerScreen({super.key, required this.workerId});

  @override
  ConsumerState<BookWorkerScreen> createState() => _BookWorkerScreenState();
}

class _BookWorkerScreenState extends ConsumerState<BookWorkerScreen> {
  DateTime _startDate = DateTime.now().add(const Duration(days: 1));
  DateTime _endDate = DateTime.now().add(const Duration(days: 1));
  final _locationController = TextEditingController(text: 'Farm Field, Shivamogga');
  bool _isSubmitting = false;

  int get _numberOfDays {
    final diff = _endDate.difference(_startDate).inDays + 1;
    return diff <= 0 ? 1 : diff;
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final workerAsync = ref.watch(workerDetailProvider(widget.workerId));
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
        title: const Text('Book Farm Worker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_rounded, color: Colors.white),
            tooltip: 'Return to Home',
            onPressed: () => context.go('/'),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: workerAsync.when(
        data: (w) {
          if (w == null) return const Center(child: Text('Worker not found'));
          final totalCost = w.dailyRate * _numberOfDays;

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
                        CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(w.profilePhoto),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(w.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Text('Skills: ${w.skills.first}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                              Text('${Formatters.currency(w.dailyRate)} / day',
                                  style: const TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                const Text('Hiring Duration', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                              if (_endDate.isBefore(_startDate)) _endDate = _startDate;
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
                            setState(() => _endDate = picked);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                CustomTextField(
                  label: 'Work Site Location',
                  controller: _locationController,
                  prefixIcon: Icons.location_on,
                ),
                const SizedBox(height: 24),

                Card(
                  color: AppColors.chipBackground,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Daily Wages (x$_numberOfDays days)', style: const TextStyle(fontSize: 14)),
                            Text(Formatters.currency(w.dailyRate * _numberOfDays)),
                          ],
                        ),
                        const Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Estimated Wages', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(Formatters.currency(totalCost),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primaryGreen)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                CustomButton(
                  text: 'Submit Worker Hiring Request',
                  isLoading: _isSubmitting,
                  onPressed: () async {
                    setState(() => _isSubmitting = true);

                    final booking = Booking(
                      id: 'b_${DateTime.now().millisecondsSinceEpoch}',
                      bookingType: 'worker',
                      targetId: w.id,
                      targetTitle: 'Hire ${w.name} (${w.skills.first})',
                      targetImageUrl: w.profilePhoto,
                      customerId: user?.id ?? 'user_1',
                      customerName: user?.name ?? 'Ramesh Gowda',
                      customerPhone: user?.phone ?? '+91 9876543210',
                      providerId: w.id,
                      providerName: w.name,
                      providerPhone: w.phone,
                      startDate: _startDate,
                      endDate: _endDate,
                      totalAmount: totalCost,
                      paymentMethod: 'Pay after Work',
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
                          content: Text('🎉 Worker Hiring Request Sent!'),
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
