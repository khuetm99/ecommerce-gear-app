import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/data/models/order_model.dart';
import 'package:ecommerce_app/data/repository/order_repository/order_repo.dart';


/// cart is collection in each user
class FirebaseOrderRepository implements OrderRepository {
  var orderCollection = FirebaseFirestore.instance.collection("orders");

  /// Get all cart items
  Future<List<OrderModel>> fetchOrders(String uid) async {
    return orderCollection
        .where("uid", isEqualTo: uid)
        .get()
        .then((snapshot) => snapshot.docs.map((doc) {
              var data = doc.data()!;
              return OrderModel.fromMap(data);
            }).toList());
  }

  @override
  Future<void> addOrderModel(OrderModel newOrderModel) async {
    await orderCollection.doc(newOrderModel.id).set(newOrderModel.toMap());
  }

  @override
  Future<void> removeOrderModel(OrderModel order) async {
    await orderCollection.doc(order.id).delete();
  }
}
