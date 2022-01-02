import 'package:ecommerce_app/data/models/models.dart';
import 'package:equatable/equatable.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object?> get props => [];
}

/// When open favorite screen -> load favorite event
class LoadFavorite extends FavoriteEvent {}

/// When user clicks to a clear favorite => clear favorite event
class ClearFavorite extends FavoriteEvent {}

/// Favorite was cleared
class FavoriteUpdated extends FavoriteEvent {
  final List<FavoriteItemModel> updatedFavorite;

  FavoriteUpdated(this.updatedFavorite);

  @override
  List<Object> get props => [updatedFavorite];
}

/// When user clicks to add button => add Favorite item event
class AddFavoriteItemModel extends FavoriteEvent {
  final FavoriteItemModel favoriteItem;

  AddFavoriteItemModel(this.favoriteItem);

  @override
  List<Object> get props => [favoriteItem];
}

/// When user swipes to remove cart item => remove Favorite item event
class RemoveFavoriteItemModel extends FavoriteEvent {
  final FavoriteItemModel favoriteItem;

  RemoveFavoriteItemModel(this.favoriteItem);

  @override
  List<Object> get props => [favoriteItem];
}
