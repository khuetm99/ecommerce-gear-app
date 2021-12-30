
import 'package:ecommerce_app/data/models/models.dart';
import 'package:equatable/equatable.dart';

abstract class ProductDetailState extends Equatable {
  const ProductDetailState();

  @override
  List<Object?> get props => [];
}

class ProductDetailLoading extends ProductDetailState {}

class ProductDetailLoaded extends ProductDetailState {
  final Product product;

  const ProductDetailLoaded({required this.product});

  @override
  List<Object?> get props => [product];
}

class ProductDetailLoadFail extends ProductDetailState {
  final String err;

  const ProductDetailLoadFail({required this.err});

  @override
  List<Object?> get props => [err];
}
