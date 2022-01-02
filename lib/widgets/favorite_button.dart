import 'package:ecommerce_app/blocs/authentication/bloc.dart';
import 'package:ecommerce_app/blocs/bloc.dart';
import 'package:ecommerce_app/blocs/favorites/bloc.dart';
import 'package:ecommerce_app/configs/config.dart';
import 'package:ecommerce_app/data/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteButton extends StatefulWidget {
  final Product product;

  const FavoriteButton({Key? key, required this.product}) : super(key: key);

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  Product get product => widget.product;

  bool checkFav(List<FavoriteItemModel> favorites) {
    for (int i = 0; i < favorites.length; i++) {
      if (favorites[i].productId == widget.product.id) {
        return true;
      }
    }
    return false;
  }

  void onNavigateFavorite() async {
    final authState = AppBloc.authBloc.state;
    if (authState is Unauthenticated) {
      final result = await Navigator.pushNamed(
        context,
        Routes.signIn,
        arguments: Routes.productDetail,
      );
      if (result != Routes.productDetail) {
        return;
      }
    }
    Navigator.popAndPushNamed(
      context,
      Routes.productDetail,
      arguments: product.id
    );
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, authState) {
        return BlocBuilder<FavoriteBloc, FavoriteState>(
            buildWhen: (prevState, currState) => currState is FavoriteLoaded,
            builder: (context, favState) {
              if (favState is FavoriteLoaded && authState is Authenticated) {
                if (checkFav(favState.favorites)) {
                  return IconButton(
                    onPressed: () {
                      AppBloc.favoriteBloc.add(
                        RemoveFavoriteItemModel(
                          FavoriteItemModel(
                            id: product.id,
                            productId: product.id,
                          ),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.favorite,
                      size: 30,
                      color: Color(0xffe5634d),
                    ),
                  );
                } else {
                  return IconButton(
                    onPressed: () {
                      AppBloc.favoriteBloc.add(
                        AddFavoriteItemModel(
                          FavoriteItemModel(
                            id: product.id,
                            productId: product.id,
                          ),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.favorite_border_outlined,
                      size: 30,
                      color: Color(0xffe5634d),
                    ),
                  );
                }
              }
              return IconButton(
                onPressed: ()=> onNavigateFavorite(),
                icon: Icon(
                  Icons.favorite_border_outlined,
                  size: 30,
                  color: Color(0xffe5634d),
                ),
              );
            });
      },
    );
  }
}
