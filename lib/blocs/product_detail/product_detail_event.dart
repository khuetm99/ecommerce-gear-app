import 'package:equatable/equatable.dart';

abstract class ProductDetailEvent extends Equatable{
  const ProductDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadProductDetailById extends ProductDetailEvent {
  final String id;
  const LoadProductDetailById({required this.id});

@override
  List<Object?> get props => [id];
}

