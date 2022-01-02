import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/data/models/favorite_item_model.dart';
import 'package:ecommerce_app/data/repository/favorite_repository/favorite_repo.dart';


class FirebaseFavoriteRepository implements FavoriteRepository {
  var userCollection = FirebaseFirestore.instance.collection("users");

  /// Get all favorite items
  Stream<List<FavoriteItemModel>> fetchFavorite(String uid) {
    return userCollection
        .doc(uid)
        .collection("favorites")
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              var data = doc.data()!;
              return FavoriteItemModel.fromMap(data);
            }).toList());
  }

  /// Add Favorite Item
  @override
  Future<void> addFavoriteItemModel(String uid, FavoriteItemModel newItem) async{
    var userRef = userCollection.doc(uid);
    await userRef.collection("favorites").doc(newItem.id).get().then((doc) async {
      if (doc.exists) {

      } else {
        // add new
        await doc.reference.set(newItem.toMap());
        print("success");
      }
    }).catchError((error) {
      print(error);
    });
  }

  /// Clear Favorites
  @override
  Future<void> clearFavorites(String uid) async{
    await userCollection
        .doc(uid)
        .collection("favorites")
        .get()
        .then((snapshot) async {
      for (DocumentSnapshot doc in snapshot.docs) {
        await doc.reference.delete();
      }
    }).catchError((error) {});
  }

  /// Remove Favorite Item
  @override
  Future<void> removeFavoriteItemModel(String uid, FavoriteItemModel favoriteItem) async {
    await userCollection
        .doc(uid)
        .collection("favorites")
        .doc(favoriteItem.id)
        .delete()
        .catchError((error) => print(error));
  }
}
