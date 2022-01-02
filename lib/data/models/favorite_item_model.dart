import 'package:ecommerce_app/data/models/product_model.dart';
import 'package:equatable/equatable.dart';

/// Favorite item model
class FavoriteItemModel extends Equatable {
  /// Favorite item id
  final String id;

  /// Product Id
  final String productId;

  final Product? productInfo;

  /// Constructor
  FavoriteItemModel({
    required this.id,
    required this.productId,
    this.productInfo
  });

  /// Json data from server turns into model data
  static FavoriteItemModel fromMap(Map<String, dynamic> data) {
    return FavoriteItemModel(
      id: data["id"] ?? "",
      productId: data["productId"] ?? "",
    );
  }

  /// From model data turns into json data => server
  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "productId": this.productId,
    };
  }

  /// Clone and update
  FavoriteItemModel cloneWith({
    id,
    productId,
    productInfo,
  }) {
    return FavoriteItemModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productInfo: productInfo ?? this.productInfo
    );
  }

  @override
  List<Object?> get props => [id, productId];
}
