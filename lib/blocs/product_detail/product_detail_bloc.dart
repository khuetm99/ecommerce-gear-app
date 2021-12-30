import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/blocs/product_detail/bloc.dart';
import 'package:ecommerce_app/data/models/models.dart';
import 'package:ecommerce_app/data/repository/product_repository/firebase_product_repo.dart';


class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final productRepository = FirebaseProductRepository();

  ProductDetailBloc() : super(ProductDetailLoading());

  @override
  Stream<ProductDetailState> mapEventToState(ProductDetailEvent event) async*{
    if(event is LoadProductDetailById) {
      yield* mapLoadProductDetailToState(event.id);
    }
  }

  Stream<ProductDetailState> mapLoadProductDetailToState(String id) async*{
    yield ProductDetailLoading();

    try {
      final Product product = await productRepository.getProductById(id);
       await Future.delayed(Duration(milliseconds: 500));

      yield ProductDetailLoaded(product: product);
    } catch (e){
      yield ProductDetailLoadFail(err: e.toString());
    }
  }


}
