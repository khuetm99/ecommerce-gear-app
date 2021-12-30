import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/data/models/banner_model.dart';
import 'package:ecommerce_app/data/repository/banner_repository/banner_repo.dart';


/// Cart is collection in each user
class FirebaseBannerRepository implements BannerRepository {
  @override
  Future<List<BannerModel>> fetchBanners() async {
    return await FirebaseFirestore.instance
        .collection("banners")
        .get()
        .then((snapshot) => snapshot.docs
            .map((doc) => BannerModel.fromMap(doc.data()!))
            .toList())
        .catchError((err) {});
  }

}
