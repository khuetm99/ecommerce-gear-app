import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class DiscountModel extends Equatable {
  final String id;
  final String content;
  final Timestamp expDate;
  final int limit;
  final int discount;

  DiscountModel({required this.content, required this.expDate,required this.limit,required this.discount, required this.id, });

  /// Json data from server turns into model data
  static DiscountModel fromMap(Map<String, dynamic> data) {
    return DiscountModel(
      id: data["id"] ?? "",
      content: data["content"] ?? "",
      expDate: data["expDate"] ?? Timestamp.now(),
      limit: data["limit"] ?? 0,
      discount: data["discount"] ?? 0,
    );
  }

  /// From model data turns into json data => server
  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "content" : this.content,
      "expDate" : this.expDate,
      "limit" : this.limit,
      "discount" : this.discount
    };
  }

  @override
  String toString() {
    return 'DiscountModel{id: $id, content: $content, expDate: $expDate}';
  }

  @override
  List<Object?> get props => [id, content, expDate];
}
