import 'package:ecommerce_app/data/models/models.dart';
import 'package:equatable/equatable.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object> get props => [];
}

/// Favorite loading
class FavoriteLoading extends FavoriteState {}

/// Favorite was loaded
class FavoriteLoaded extends FavoriteState {
  final List<FavoriteItemModel> favorites;


  FavoriteLoaded({
    required this.favorites,
  });

  @override
  List<Object> get props => [favorites];
}

/// Favorite wasn't loaded
class FavoriteLoadFailure extends FavoriteState {
  final String error;

  FavoriteLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}
