import '../entities/order.dart';

abstract class OrderRepository {
  Future<List<Order>> getOrdersForUser(String userId);
  Future<Order> createOrder(Order order);
  Future<Order> updateOrderStatus(String orderId, String status);
}
