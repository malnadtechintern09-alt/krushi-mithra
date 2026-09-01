import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../../../../core/database/sample_data.dart';

class OrderRepositoryImpl implements OrderRepository {
  final List<Order> _orders = List.from(SampleData.initialOrders);

  @override
  Future<List<Order>> getOrdersForUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _orders.where((o) => o.customerId == userId).toList();
  }

  @override
  Future<Order> createOrder(Order order) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _orders.insert(0, order);
    return order;
  }

  @override
  Future<Order> updateOrderStatus(String orderId, String status) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index] = _orders[index].copyWith(orderStatus: status);
      return _orders[index];
    }
    throw Exception('Order not found');
  }
}
