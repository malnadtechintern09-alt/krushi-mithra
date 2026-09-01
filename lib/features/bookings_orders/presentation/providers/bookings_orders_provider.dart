import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/booking.dart';
import '../../domain/entities/order.dart';
import '../../../../shared/providers/repository_providers.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

final userBookingsProvider = FutureProvider<List<Booking>>((ref) async {
  final repo = ref.watch(bookingRepositoryProvider);
  final user = ref.watch(authProvider).value;
  if (user == null) return [];
  return repo.getBookingsForUser(user.id);
});

final userOrdersProvider = FutureProvider<List<Order>>((ref) async {
  final repo = ref.watch(orderRepositoryProvider);
  final user = ref.watch(authProvider).value;
  if (user == null) return [];
  return repo.getOrdersForUser(user.id);
});
