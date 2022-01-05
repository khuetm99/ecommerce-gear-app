import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/data/models/discount_model.dart';
import 'package:ecommerce_app/data/repository/discount_repository/discount_repo.dart';

class FirebaseDiscountRepo extends DiscountRepository {

  @override
  Future<List<DiscountModel>>? fetchDiscount() async{
    return await FirebaseFirestore.instance
        .collection("discounts")
        .get()
        .then((snapshot) => snapshot.docs
        .map((doc) => DiscountModel.fromMap(doc.data()!))
        .toList())
        .catchError((err) {});
  }
}