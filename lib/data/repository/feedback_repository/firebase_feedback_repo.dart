import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/data/models/feedback_model.dart';
import 'package:ecommerce_app/data/repository/feedback_repository/feedback_repo.dart';

/// Feedbacks is collection type in each product
class FirebaseFeedbackRepository implements FeedbackRepository {
  var productCollection = FirebaseFirestore.instance.collection("products");

  /// Stream of feedback
  /// [pid] is product id
  @override
  Stream<List<FeedBackModel>>? fetchFeedbacks(String pid) {
    try {
      return productCollection
          .doc(pid)
          .collection("feedbacks")
          .orderBy("timestamp", descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => FeedBackModel.fromMap(doc.data()!))
              .toList());
    } catch (e) {
      print(e);
    }
    return null;
  }

  /// Add new doc to feedbacks collection
  /// [pid] is product id
  /// [newItem] is data of new feedback
  @override
  Future<List<FeedBackModel>> getFeedbacksByStar(String pid, int star) async {
    return star != 0
        ? await productCollection
            .doc(pid)
            .collection("feedbacks")
            .where("rating", isEqualTo: star)
            .orderBy("timestamp", descending: true)
            .get()
            .then((snapshot) => snapshot.docs
                .map((doc) => FeedBackModel.fromMap(doc.data()!))
                .toList())
            .catchError((error) {})
        : await productCollection
            .doc(pid)
            .collection("feedbacks")
            .orderBy("timestamp", descending: true)
            .get()
            .then((snapshot) => snapshot.docs
                .map((doc) => FeedBackModel.fromMap(doc.data()!))
                .toList())
            .catchError((error) {});
  }

  /// Get feedbacks by star
  /// [pid] is product id
  /// [star] is number of stars
  @override
  Future<void> addNewFeedback(String pid, FeedBackModel newItem) async {
    var productRef = productCollection.doc(pid);
    await productRef
        .collection("feedbacks")
        .doc(newItem.id)
        .set(newItem.toMap())
        .catchError((error) => print(error));
  }
}
