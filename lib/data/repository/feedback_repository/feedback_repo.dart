
import 'package:ecommerce_app/data/models/feedback_model.dart';

abstract class FeedbackRepository {
  /// Stream of feedback
  /// [pid] is product id
  Stream<List<FeedBackModel>>? fetchFeedbacks(String pid);

  /// Add new doc to feedbacks collection
  /// [pid] is product id
  /// [newItem] is data of new feedback
  Future<void> addNewFeedback(String pid, FeedBackModel newItem);

  /// Get feedbacks by star
  /// [pid] is product id
  /// [star] is number of stars
  Future<List<FeedBackModel>> getFeedbacksByStar(String pid, int star);
}
