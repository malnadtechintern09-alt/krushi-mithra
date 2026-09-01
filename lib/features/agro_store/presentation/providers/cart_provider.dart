import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../marketplace/domain/entities/product.dart';
import '../../../bookings_orders/domain/entities/order_item.dart';

class CartState {
  final List<OrderItem> items;

  const CartState({this.items = const []});

  double get totalAmount {
    return items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  int get totalItemCount {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }
}

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(const CartState());

  void addToCart(Product product, {int quantity = 1}) {
    final existingIndex = state.items.indexWhere((i) => i.product.id == product.id);
    if (existingIndex != -1) {
      final updatedList = List<OrderItem>.from(state.items);
      final currentItem = updatedList[existingIndex];
      updatedList[existingIndex] = OrderItem(
        product: product,
        quantity: currentItem.quantity + quantity,
        unitPrice: product.price,
      );
      state = CartState(items: updatedList);
    } else {
      state = CartState(
        items: [
          ...state.items,
          OrderItem(
            product: product,
            quantity: quantity,
            unitPrice: product.price,
          ),
        ],
      );
    }
  }

  void removeFromCart(String productId) {
    state = CartState(
      items: state.items.where((i) => i.product.id != productId).toList(),
    );
  }

  void updateQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(productId);
      return;
    }
    final updatedList = state.items.map((item) {
      if (item.product.id == productId) {
        return OrderItem(
          product: item.product,
          quantity: newQuantity,
          unitPrice: item.unitPrice,
        );
      }
      return item;
    }).toList();
    state = CartState(items: updatedList);
  }

  void clearCart() {
    state = const CartState(items: []);
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});
