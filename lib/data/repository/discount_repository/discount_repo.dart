import 'package:ecommerce_app/data/models/discount_model.dart';

abstract class DiscountRepository {
  /// Future of discount
  Future<List<DiscountModel>>? fetchDiscount();
}
