import 'package:ecommerce_app/data/models/banner_model.dart';

abstract class BannerRepository {
// Get all cart items
  Future<List<BannerModel>> fetchBanners();
}
