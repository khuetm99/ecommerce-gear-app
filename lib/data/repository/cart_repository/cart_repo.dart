import 'package:ecommerce_app/data/models/cart_item_model.dart';

abstract class CartRepository {
  /// Cart stream
  /// [uid] is user id
  Stream<List<CartItemModel>> fetchCart(String uid);

  /// Add item
  /// [uid] is user id
  /// [newItem] is data of new cart item
  Future<void> addCartItemModel(String uid, CartItemModel newItem);

  /// Remove item
  /// [uid] is user id
  /// [cartItem] is data of cart item
  Future<void> removeCartItemModel(String uid, CartItemModel cartItem);

  /// Clear cart
  /// [uid] is user id
  Future<void> clearCart(String uid);

  /// Update quantity
  /// [uid] is user id
  /// [cartItem] is updated data of cart item
  Future<void> updateCartItemModel(String uid, CartItemModel cartItem);
}
