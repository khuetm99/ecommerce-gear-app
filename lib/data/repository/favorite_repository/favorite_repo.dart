import 'package:ecommerce_app/data/models/favorite_item_model.dart';

abstract class FavoriteRepository {
  /// Favorite stream
  /// [uid] is user id
  Stream<List<FavoriteItemModel>> fetchFavorite(String uid);

  /// Add item
  /// [uid] is user id
  /// [newItem] is data of new cart item
  Future<void> addFavoriteItemModel(String uid, FavoriteItemModel newItem);

  /// Remove item
  /// [uid] is user id
  /// [favoriteItem] is data of cart item
  Future<void> removeFavoriteItemModel(String uid, FavoriteItemModel favoriteItem);

  /// Clear Favorites
  /// [uid] is user id
  Future<void> clearFavorites(String uid);

}
