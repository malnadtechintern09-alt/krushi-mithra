import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../bookings_orders/domain/entities/order.dart';
import '../../../bookings_orders/presentation/providers/bookings_orders_provider.dart';
import '../../../../shared/providers/repository_providers.dart';
import '../providers/cart_provider.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _addressController = TextEditingController(text: 'Green Farm House, Thirthahalli Road, Shivamogga');
  String _paymentMethod = 'Pay on Delivery (COD)';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
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
        title: const Text('Checkout & Order Placement'),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Delivery Address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            CustomTextField(
              label: 'Full Address',
              controller: _addressController,
              prefixIcon: Icons.home_rounded,
              maxLines: 2,
            ),
            const SizedBox(height: 20),

            const Text('Payment Option', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            RadioListTile<String>(
              value: 'Pay on Delivery (COD)',
              groupValue: _paymentMethod,
              title: const Text('Cash on Delivery / Pay on Delivery'),
              subtitle: const Text('Eligible COD option available for your location'),
              activeColor: AppColors.primaryGreen,
              onChanged: (val) {
                if (val != null) setState(() => _paymentMethod = val);
              },
            ),
            RadioListTile<String>(
              value: 'UPI / Online Payment',
              groupValue: _paymentMethod,
              title: const Text('Google Pay / PhonePe / BHIM UPI'),
              subtitle: const Text('Instant secure digital payment'),
              activeColor: AppColors.primaryGreen,
              onChanged: (val) {
                if (val != null) setState(() => _paymentMethod = val);
              },
            ),
            const SizedBox(height: 20),

            // Order Summary Card
            Card(
              color: AppColors.chipBackground,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Order Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),
                    ...cart.items.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${item.product.title} (x${item.quantity})', style: const TextStyle(fontSize: 13)),
                              Text(Formatters.currency(item.totalPrice), style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        )),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Amount', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(
                          Formatters.currency(cart.totalAmount),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primaryGreen),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            CustomButton(
              text: 'Place Order (${Formatters.currency(cart.totalAmount)})',
              isLoading: _isSubmitting,
              onPressed: () async {
                setState(() => _isSubmitting = true);

                final newOrder = Order(
                  id: 'ord_${DateTime.now().millisecondsSinceEpoch}',
                  customerId: user?.id ?? 'user_1',
                  customerName: user?.name ?? 'Ramesh Gowda',
                  customerPhone: user?.phone ?? '+91 9876543210',
                  deliveryAddress: _addressController.text,
                  items: List.from(cart.items),
                  totalAmount: cart.totalAmount,
                  paymentMethod: _paymentMethod,
                  paymentStatus: 'Pending',
                  orderStatus: 'Confirmed',
                  createdAt: DateTime.now(),
                );

                await ref.read(orderRepositoryProvider).createOrder(newOrder);
                ref.read(cartProvider.notifier).clearCart();
                ref.invalidate(userOrdersProvider);

                if (mounted) {
                  setState(() => _isSubmitting = false);
                  context.go('/order-success');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
