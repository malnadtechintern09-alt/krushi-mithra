import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';

import '../../features/machinery/domain/repositories/machinery_repository.dart';
import '../../features/machinery/data/repositories/machinery_repository_impl.dart';

import '../../features/workers/domain/repositories/worker_repository.dart';
import '../../features/workers/data/repositories/worker_repository_impl.dart';

import '../../features/marketplace/domain/repositories/marketplace_repository.dart';
import '../../features/marketplace/data/repositories/marketplace_repository_impl.dart';

import '../../features/bookings_orders/domain/repositories/booking_repository.dart';
import '../../features/bookings_orders/data/repositories/booking_repository_impl.dart';

import '../../features/bookings_orders/domain/repositories/order_repository.dart';
import '../../features/bookings_orders/data/repositories/order_repository_impl.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

final machineryRepositoryProvider = Provider<MachineryRepository>((ref) {
  return MachineryRepositoryImpl();
});

final workerRepositoryProvider = Provider<WorkerRepository>((ref) {
  return WorkerRepositoryImpl();
});

final marketplaceRepositoryProvider = Provider<MarketplaceRepository>((ref) {
  return MarketplaceRepositoryImpl();
});

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  return BookingRepositoryImpl();
});

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepositoryImpl();
});
