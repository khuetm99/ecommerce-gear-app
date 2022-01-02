import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/data/models/models.dart';

import 'cart_repo.dart';

/// cart is collection in each user
class FirebaseCartRepository implements CartRepository {
  var userCollection = FirebaseFirestore.instance.collection("users");

  /// Get all cart items
  Stream<List<CartItemModel>> fetchCart(String uid) {
    return userCollection
        .doc(uid)
        .collection("cart")
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      var data = doc.data()!;
      return CartItemModel.fromMap(data);
    }).toList());
  }

  /// Add item
  Future<void> addCartItemModel(String uid, CartItemModel newItem) async {
    var userRef = userCollection.doc(uid);
    await userRef.collection("cart").doc(newItem.id).get().then((doc) async {
      if (doc.exists) {
        // old data + new data
        var quantity = doc.data()!["quantity"] + newItem.quantity;
        var price = doc.data()!["price"] + newItem.price;
        // update
        await doc.reference.update({"quantity": quantity, "price": price});
      } else {
        // add new
        await doc.reference.set(newItem.toMap());
        print("success");
      }
    }).catchError((error) {
      print(error);
    });
  }

  /// Remove item
  Future<void> removeCartItemModel(String uid, CartItemModel cartItem) async {
    await userCollection
        .doc(uid)
        .collection("cart")
        .doc(cartItem.id)
        .delete()
        .catchError((error) => print(error));
  }

  /// Clear cart
  Future<void> clearCart(String uid) async {
    await userCollection
        .doc(uid)
        .collection("cart")
        .get()
        .then((snapshot) async {
      for (DocumentSnapshot doc in snapshot.docs) {
        await doc.reference.delete();
      }
    }).catchError((error) {});
  }

  /// Update quantity of cart item
  Future<void> updateCartItemModel(String uid, CartItemModel cartItem) async {
    var userRef = userCollection.doc(uid);
    await userRef.collection("cart").doc(cartItem.id).get().then((doc) async {
      if (doc.exists) {
        // update
        await doc.reference.update(cartItem.toMap());
      }
    }).catchError((error) {
      print(error);
    });
  }

  ///Singleton factory
  static final FirebaseCartRepository _instance =
  FirebaseCartRepository._internal();

  factory FirebaseCartRepository() {
    return _instance;
  }

  FirebaseCartRepository._internal();
}
