import 'package:ecommerce_app/blocs/app_bloc.dart';
import 'package:ecommerce_app/blocs/favorites/bloc.dart';
import 'package:ecommerce_app/configs/config.dart';
import 'package:ecommerce_app/data/models/models.dart';
import 'package:ecommerce_app/utils/utils.dart';
import 'package:ecommerce_app/widgets/app_product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share/share.dart';

class WishList extends StatefulWidget {
  const WishList({Key? key}) : super(key: key);

  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  ///On navigate product detail
  void _onProductDetail(Product item) {
    Navigator.pushNamed(context, Routes.productDetail, arguments: item.id);
  }

  ///Clear all wishlist
  void _clearWishList() {
    AppBloc.favoriteBloc.add(ClearFavorite());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteBloc, FavoriteState>(builder: (context, state) {
      ///Loading
      Widget content = ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(left: 16, top: 16),
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: AppProductItem(type: ProductViewType.witchList),
          );
        },
        itemCount: 8,
      );

      ///Success
      if (state is FavoriteLoaded) {
        content = ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(
            left: 16,
            top: 16,
          ),
          itemCount: state.favorites.length,
          itemBuilder: (context, index) {
            if (index == state.favorites.length) {
              return Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: AppProductItem(
                  type: ProductViewType.witchList,
                ),
              );
            }
            final item = state.favorites[index];
            return Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: AppProductItem(
                onPressed: _onProductDetail,
                product: item.productInfo,
                type: ProductViewType.witchList,
                action: PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert),
                  onSelected: (result) {
                    if (result == 'remove') {
                      AppBloc.favoriteBloc.add(
                        RemoveFavoriteItemModel(FavoriteItemModel(
                          id: item.id,
                          productId: item.productId,
                        )),
                      );
                    }
                    if (result == 'share' && item != null) {
                      Share.share(
                        'Check out my item ${item.productInfo}',
                        subject: 'PassionUI',
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'remove',
                        child: Text(
                          Translate.of(context)!.translate('remove'),
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'share',
                        child: Text(
                          Translate.of(context)!.translate('share'),
                        ),
                      ),
                    ];
                  },
                ),
              ),
            );
          },
        );

        ///Empty
        if (state.favorites.isEmpty) {
          content = Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.sentiment_satisfied),
                Padding(
                  padding: EdgeInsets.all(4),
                  child: Text(
                    Translate.of(context)!.translate('list_is_empty'),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ],
            ),
          );
        }
      }

      ///Icon Remove
      Widget icon = Container();
      if (state is FavoriteLoaded && state.favorites.length > 0) {
        icon = IconButton(
          icon: Icon(Icons.delete_outline),
          onPressed: _clearWishList,
        );
      }

      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(Translate.of(context)!.translate('wish_list')),
          actions: <Widget>[icon],
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async => AppBloc.favoriteBloc.add(LoadFavorite()),
            child: content,
          ),
        ),
      );
    });
  }
}
