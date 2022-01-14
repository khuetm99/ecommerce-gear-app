import 'package:ecommerce_app/blocs/app_bloc.dart';
import 'package:ecommerce_app/blocs/authentication/bloc.dart';
import 'package:ecommerce_app/blocs/favorites/bloc.dart';
import 'package:ecommerce_app/blocs/feedbacks/bloc.dart';
import 'package:ecommerce_app/blocs/product_detail/bloc.dart';
import 'package:ecommerce_app/configs/config.dart';
import 'package:ecommerce_app/constants/color_constant.dart';
import 'package:ecommerce_app/data/models/models.dart';
import 'package:ecommerce_app/screens/product_detail/add_to_cart_nav.dart';
import 'package:ecommerce_app/screens/product_detail/product_detail_images.dart';
import 'package:ecommerce_app/screens/product_detail/related_products.dart';
import 'package:ecommerce_app/screens/product_detail/slogan.dart';
import 'package:ecommerce_app/utils/utils.dart';
import 'package:ecommerce_app/widgets/favorite_button.dart';
import 'package:ecommerce_app/widgets/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetail extends StatefulWidget {
  final String? id;

  const ProductDetail({Key? key, this.id}) : super(key: key);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  bool seeMore = false;


  void onSeeMore() => setState(() => seeMore = !seeMore);

  void onNavigateFeedBacks(Product product) {
    Navigator.pushNamed(context, Routes.feedbacks, arguments: product);
  }


  ///Build content UI
  Widget _buildContent(Product? product) {
    final width = MediaQuery.of(context).size.width;

    ///Build UI loading
    List<Widget> action = [];

    Widget background = Shimmer.fromColors(
      baseColor: Theme.of(context).hoverColor,
      highlightColor: Theme.of(context).highlightColor,
      enabled: true,
      child: Container(
        color: Colors.white,
      ),
    );

    Widget info = Shimmer.fromColors(
      baseColor: Theme.of(context).hoverColor,
      highlightColor: Theme.of(context).highlightColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 20, color: Colors.white),
          Padding(
            padding: EdgeInsets.only(
              top: 4,
            ),
            child:
                Container(height: 20, width: width - 30, color: Colors.white),
          ),
          Padding(padding: EdgeInsets.only(top: 10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 16,
                    width: 100,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                  ),
                  Container(
                    height: 20,
                    width: 150,
                    color: Colors.white,
                  ),
                ],
              ),
              Container(
                height: 10,
                width: 100,
                color: Colors.white,
              ),
            ],
          ),
          Padding(padding: EdgeInsets.only(top: 16)),
          Row(
            children: <Widget>[
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 10,
                      width: 100,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                    ),
                    Container(
                      height: 10,
                      width: 150,
                      color: Colors.white,
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );

    Widget description = Shimmer.fromColors(
        baseColor: Theme.of(context).hoverColor,
        highlightColor: Theme.of(context).highlightColor,
        child: Column(
          children: [
            Container(height: 10, color: Colors.white),
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: Container(height: 10, color: Colors.white),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: Container(height: 10, color: Colors.white),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: Container(height: 10, color: Colors.white),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: Container(height: 10, color: Colors.white),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: Container(height: 10, color: Colors.white),
            ),
          ],
        ));

    Widget slogan = Container();
    Widget relatedProducts = Container();

    if (product != null) {
      action = [
        Padding(
          padding: EdgeInsets.only(right: 5),
          child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).dividerColor),
              child: Center(
                  child: CartButton(
                color: Theme.of(context).backgroundColor,
              ))),
        ),
      ];

      /// Product Images
      background = ProductDetailImages(
        product: product,
      );

      /// Product Info
      info = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: SelectableText(
                  product.name,
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.only(top: 10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Text(
                        product.price.toPrice(),
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
                      ),
                      if (product.percentOff > 0)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            "${product.originalPrice.toPrice()}",
                            style: TextStyle(decoration: TextDecoration.lineThrough),
                          ),
                        ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                  ),
                  InkWell(
                    onTap: () {
                      onNavigateFeedBacks(product);
                    },
                    child: Row(
                      children: [
                        AppTag(
                          "${product.rating}",
                          type: TagType.rateSmall,
                        ),
                        Padding(padding: EdgeInsets.only(left: 4)),
                        StarRating(
                          rating: product.rating.toDouble(),
                          size: 15,
                          color: AppTheme.yellowColor,
                          borderColor: AppTheme.yellowColor,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              ///Available
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: FavoriteButton(product: product),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.center,
                      height: 30,
                      decoration: BoxDecoration(
                        color: product.isAvailable
                            ? Color(0xFFFFE6E6)
                            : Color(0xFFF5F6F9),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          bottomLeft: Radius.circular(25),
                        ),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/icons/Check mark rounde.svg",
                            color: product.isAvailable
                                ? Color(0xFFFF4848)
                                : Color(0xFFDBDEE4),
                          ),
                          SizedBox(width: 5),
                          Text(
                            "${product.isAvailable ? Translate.of(context)!.translate('available') : Translate.of(context)!.translate('not_available')}",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(padding: EdgeInsets.only(top: 16)),
          Row(
            children: <Widget>[
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).dividerColor,
                ),
                child: Icon(
                  Icons.point_of_sale_sharp,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      Translate.of(context)!.translate('sold_quantity'),
                      style: Theme.of(context).textTheme.caption,
                    ),
                    Text(
                      product.soldQuantity.toString() +
                          ' ' +
                          Translate.of(context)!.translate('products'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );

      /// Description
      if (product.description.isNotEmpty) {
        description = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.description,
              maxLines: seeMore ? null : 3,
              style:
                  Theme.of(context).textTheme.bodyText1!.copyWith(height: 1.3),
            ),
            SizedBox(height: 5),
            // See more button
            GestureDetector(
              onTap: onSeeMore,
              child: Text(
                "${seeMore ? Translate.of(context)!.translate('see_less') : Translate.of(context)!.translate('see_all')}",
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
              ),
            ),
          ],
        );
      }

      ///Slogan
      slogan = Slogan();

      ///Related Product
      relatedProducts = RelatedProducts(
        product: product,
      );
    }

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 280.0,
          pinned: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).backgroundColor == Colors.white
                  ? Colors.black
                  : COLOR_CONST.cardShadowColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: action,
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.none,
            background: background,
          ),
        ),
        SliverToBoxAdapter(
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.only(top: 16, bottom: 16),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, left: 8, right: 0, bottom: 8),
                    child: info,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 16, left: 8, right: 8, bottom: 8),
                    child: description,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: slogan,
                  ),
                  relatedProducts
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductDetailBloc>(
        create: (context) => ProductDetailBloc()
          ..add(LoadProductDetailById(id: widget.id as String)),
        child: BlocListener<FeedbackBloc, FeedbackState>(
          listener: (context, state) {
            if (state is FeedbackSaveSuccess) {
              BlocProvider.of<ProductDetailBloc>(context)
                  .add(LoadProductDetailById(id: widget.id as String));
            }
          },
          child: BlocBuilder<ProductDetailBloc, ProductDetailState>(
            builder: (context, state) {
              Product? product;

              if (state is ProductDetailLoaded) {
                product = state.product;
              }
              return Scaffold(
                  body: _buildContent(product),
                  bottomNavigationBar: AddToCartNavigation(product: product));
            },
          ),
        ));
  }
}
