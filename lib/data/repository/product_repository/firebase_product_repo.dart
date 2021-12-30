import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/data/models/category_model.dart';
import 'package:ecommerce_app/data/models/product_model.dart';
import 'package:ecommerce_app/data/repository/product_repository/product_repo.dart';

class FirebaseProductRepository implements ProductRepository {
  final CollectionReference productCollection =
      FirebaseFirestore.instance.collection("products");

  /// Get all products
  @override
  Future<List<Product>> fetchProducts() async {
    return await productCollection
        .get()
        .then((snapshot) => snapshot.docs
            .map((doc) => Product.fromMap(doc.id, doc.data()!))
            .toList())
        .catchError((error) {});
  }

  /// Get popular product by soldQuantity
  @override
  Future<List<Product>> fetchPopularProducts() async {
    return await productCollection
        .orderBy("soldQuantity", descending: true)
        .get()
        .then((snapshot) => snapshot.docs
            .map((doc) => Product.fromMap(doc.id, doc.data()!))
            .toList())
        .catchError((error) {});
  }

  /// Get discount product by percentOff
  @override
  Future<List<Product>> fetchDiscountProducts() async {
    return await productCollection
        .orderBy("percentOff", descending: true)
        .where("percentOff", isGreaterThan: 0)
        .get()
        .then((snapshot) => snapshot.docs
            .map((doc) => Product.fromMap(doc.id, doc.data()!))
            .toList())
        .catchError((error) {});
  }

  /// Get products by category
  /// [categoryId] is id of category
  @override
  Future<List<Product>> fetchProductsByCategory(String? categoryId) async {
    return await productCollection
        .where("categoryId", isEqualTo: categoryId)
        .get()
        .then((snapshot) => snapshot.docs
            .map((doc) => Product.fromMap(doc.id, doc.data()!))
            .toList())
        .catchError((error) {});
  }

  /// Get product by Id
  /// [pid] is product id
  @override
  Future<Product> getProductById(String? pid) async {
    return await productCollection
        .doc(pid)
        .get()
        .then((doc) => Product.fromMap(doc.id, doc.data()!))
        .catchError((error) {});
  }

  @override

  /// Update product rating
  /// [pid] is product id
  /// [rating] is updated rating
  Future<void> updateProductRatingById(String pid, double rating) async {
    return await productCollection
        .doc(pid)
        .update({"rating": rating}).catchError((error) {});
  }

  /// Get all categories
  @override
  Future<List<CategoryModel>> getCategories() async {
    return await FirebaseFirestore.instance
        .collection("categories")
        .get()
        .then((snapshot) => snapshot.docs
            .map((doc) => CategoryModel.fromMap(doc.id, doc.data()!))
            .toList())
        .catchError((err) {});
  }

  /// Get category by id
  @override
  Future<CategoryModel> getCategoryById(String categoryId) async {
    return await FirebaseFirestore.instance
        .collection("categories")
        .doc(categoryId)
        .get()
        .then((doc) => CategoryModel.fromMap(doc.id, doc.data()!))
        .catchError((err) {});
  }
}
