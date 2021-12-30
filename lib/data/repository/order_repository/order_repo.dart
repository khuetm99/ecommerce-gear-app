import 'package:ecommerce_app/data/models/order_model.dart';

abstract class OrderRepository {
  /// Get all orders
  /// [uid] is user id
  Future<List<OrderModel>> fetchOrders(String uid);

  /// Add item
  /// [newOrderModel] is data of new order
  Future<void> addOrderModel(OrderModel newOrderModel);

  /// Add item
  /// [newOrderModel] is data of new order
  Future<void> removeOrderModel(OrderModel order);
}
