import 'dart:async';


import 'package:ecommerce_app/blocs/favorites/bloc.dart';
import 'package:ecommerce_app/data/repository/auth_repository/firebase_auth_repo.dart';
import 'package:ecommerce_app/data/repository/favorite_repository/firebase_favorite_repo.dart';
import 'package:ecommerce_app/data/repository/product_repository/firebase_product_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final  _authRepository = FirebaseAuthRepository();
  final  _favoriteRepository = FirebaseFavoriteRepository();
  final  _productRepository = FirebaseProductRepository();

  late User _loggedFirebaseUser;
  StreamSubscription? _fetchFavoriteSub;

  FavoriteBloc() : super(FavoriteLoading());

  @override
  Stream<FavoriteState> mapEventToState(FavoriteEvent event) async* {
    if (event is LoadFavorite) {
      yield* _mapLoadFavoriteToState(event);
    } else if (event is AddFavoriteItemModel) {
      yield* _mapAddFavoriteItemModelToState(event);
    } else if (event is RemoveFavoriteItemModel) {
      yield* _mapRemoveFavoriteItemModelToState(event);
    } else if (event is ClearFavorite) {
      yield* _mapClearFavoriteToState();
    } else if (event is FavoriteUpdated) {
      yield* _mapFavoriteUpdatedToState(event);
    }
  }

  Stream<FavoriteState> _mapLoadFavoriteToState(LoadFavorite event) async* {
    try {
      _fetchFavoriteSub?.cancel();
      _loggedFirebaseUser = _authRepository.loggedFirebaseUser;
      _fetchFavoriteSub = _favoriteRepository
          .fetchFavorite(_loggedFirebaseUser.uid)
          .listen((fav) => add(FavoriteUpdated(fav)));
    } catch (e) {
      yield FavoriteLoadFailure(e.toString());
    }
  }

  Stream<FavoriteState> _mapAddFavoriteItemModelToState(AddFavoriteItemModel event) async* {
    try {
      await _favoriteRepository.addFavoriteItemModel(
          _loggedFirebaseUser.uid, event.favoriteItem);
    } catch (e) {
      print(e);
    }
  }

  Stream<FavoriteState> _mapRemoveFavoriteItemModelToState(
      RemoveFavoriteItemModel event) async* {
    try {
      await _favoriteRepository.removeFavoriteItemModel(
        _loggedFirebaseUser.uid,
        event.favoriteItem,
      );
    } catch (e) {
      print(e);
    }
  }

  Stream<FavoriteState> _mapClearFavoriteToState() async* {
    try {
      await _favoriteRepository.clearFavorites(_loggedFirebaseUser.uid);
    } catch (e) {
      print(e);
    }
  }

  Stream<FavoriteState> _mapFavoriteUpdatedToState(FavoriteUpdated event) async* {
    yield FavoriteLoading();

    var updatedFavorite = event.updatedFavorite;

    for (var i = 0; i < updatedFavorite.length; i++) {
      try {
        var productInfo =
            await _productRepository.getProductById(updatedFavorite[i].productId);
        updatedFavorite[i] = updatedFavorite[i].cloneWith(productInfo: productInfo);
      } catch (e) {
        yield FavoriteLoadFailure(e.toString());
      }
    }

    yield FavoriteLoaded(
      favorites: updatedFavorite,
    );
  }

  @override
  Future<void> close() {
    _fetchFavoriteSub?.cancel();
    return super.close();
  }
}
