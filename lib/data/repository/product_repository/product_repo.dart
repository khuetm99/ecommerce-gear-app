import 'package:ecommerce_app/data/models/category_model.dart';
import 'package:ecommerce_app/data/models/product_model.dart';

abstract class ProductRepository {
  /// Get all products
  Future<List<Product>> fetchProducts();

  /// Get popular products
  Future<List<Product>> fetchPopularProducts();

  /// Get discount products
  Future<List<Product>> fetchDiscountProducts();

  /// Get products by category
  /// [categoryId] is id of category
  Future<List<Product>> fetchProductsByCategory(String? categoryId);

  /// Get product by Id
  /// [pid] is product id
  Future<Product> getProductById(String pid);

  /// Update product rating
  /// [pid] is product id
  /// [rating] is updated rating
  Future<void> updateProductRatingById(String pid, double rating);

  /// Get all categories
  Future<List<CategoryModel>> getCategories();

  /// Get category by id
  Future<CategoryModel> getCategoryById(String caregoryId);
}
