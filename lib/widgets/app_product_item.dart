import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/configs/config.dart';
import 'package:ecommerce_app/constants/icon_constant.dart';
import 'package:ecommerce_app/data/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ecommerce_app/utils/utils.dart';
import 'app_tag.dart';
import 'widget.dart';

enum ProductViewType {
  grid,
  list,
  witchList
}

class AppProductItem extends StatelessWidget {
  final Product? product;
  final ProductViewType? type;
  final Function(Product)? onPressed;
  final PopupMenuButton? action;

  const AppProductItem({Key? key, this.product, this.type, this.onPressed, this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {

      ///Mode Grid View
      case ProductViewType.grid:
        if (product == null) {
          return Shimmer.fromColors(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                      color: Colors.white,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 4)),
                  Container(
                    height: 20,
                    width: 160,
                    color: Colors.white,
                  ),
                  Padding(padding: EdgeInsets.only(top: 2)),
                  Container(
                    height: 10,
                    width: 110,
                    color: Colors.white,
                  ),
                  Padding(padding: EdgeInsets.only(top: 4)),
                  Container(
                    height: 20,
                    width: 100,
                    color: Colors.white,
                  ),
                  Padding(padding: EdgeInsets.only(top: 4)),
                  Container(
                    height: 10,
                    width: 140,
                    color: Colors.white,
                  ),
                ],
              ),
              baseColor: Theme.of(context).hoverColor,
              highlightColor: Theme.of(context).highlightColor);
        }
        return GestureDetector(
          onTap: () {
            //print("Product id: ${product!.id}");
            onPressed!(product!);
          },
          child: Container(
            width: 170,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: CachedNetworkImage(
                        imageUrl: product!.images[0],
                        imageBuilder: (context, imageProvider) {
                          return Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                        placeholder: (context, url) {
                          return Shimmer.fromColors(
                            baseColor: Theme.of(context).hoverColor,
                            highlightColor: Theme.of(context).highlightColor,
                            enabled: true,
                            child: Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                        errorWidget: (context, url, error) {
                          return Shimmer.fromColors(
                            baseColor: Theme.of(context).hoverColor,
                            highlightColor: Theme.of(context).highlightColor,
                            enabled: true,
                            child: Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              child: Icon(Icons.error),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 4)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            color: product!.isAvailable
                                ? Color(0xFFFFE6E6)
                                : Color(0xFFF5F6F9),
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            ICON_CONST.CHECK_MARK,
                            color: product!.isAvailable
                                ? Color(0xFFFF4848)
                                : Colors.black26,
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Text(
                              product!.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 8)),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 18.0, right: 10),
                            child: Text(
                              "${product!.price.toPrice()}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w600),
                            ),
                          ),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                text: Translate.of(context)!.translate("sold"),
                                style: Theme.of(context).textTheme.caption,
                                children: [
                                  TextSpan(
                                    text: " ${product!.soldQuantity}",
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 18),
                          child: AppTag(
                            "${product!.rating}",
                            type: TagType.rateSmall,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(left: 4)),
                        StarRating(
                          rating: product!.rating.toDouble(),
                          size: 15,
                          color: AppTheme.yellowColor,
                          borderColor: AppTheme.yellowColor,
                        ),
                      ],
                    )
                  ],
                ),

                // Percent off
                if (product!.percentOff > 0)
                  Positioned(
                    top: -10,
                    right: -8,
                    child: ClipPath(
                      clipper: CustomDiscountCard(),
                      child: Container(
                        alignment: Alignment.center,
                        height: 70,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: Theme.of(context).accentColor,
                        ),
                        child: Text("-${product!.percentOff}%",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white)),
                      ),
                    ),
                  )
              ],
            ),
          ),
        );

      /// Mode List View
      case ProductViewType.list:
        if (product == null) {
          return Shimmer.fromColors(
            child: Row(
              children: <Widget>[
                Container(
                  width: 140,
                  height: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 8,
                    right: 8,
                    top: 4,
                    bottom: 4,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 20,
                        width: 220,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4),
                      ),
                      Container(
                        height: 10,
                        width: 200,
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
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                      ),
                      Container(
                        height: 10,
                        width: 180,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            baseColor: Theme.of(context).hoverColor,
            highlightColor: Theme.of(context).highlightColor,
          );
        }
        return InkWell(
          onTap: () {
            print("Product id: ${product!.id}");
            onPressed!(product!);
          },
          child: Row(
            children: [
              CachedNetworkImage(
                imageUrl: product!.images[0],
                imageBuilder: (context, imageProvider) {
                  return Container(
                    width: 140,
                    height: 130,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                  );
                },
                placeholder: (context, url) {
                  return Shimmer.fromColors(
                    baseColor: Theme.of(context).hoverColor,
                    highlightColor: Theme.of(context).highlightColor,
                    enabled: true,
                    child: Container(
                      width: 140,
                      height: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                        color: Colors.white,
                      ),
                    ),
                  );
                },
                errorWidget: (context, url, error) {
                  return Shimmer.fromColors(
                    baseColor: Theme.of(context).hoverColor,
                    highlightColor: Theme.of(context).highlightColor,
                    enabled: true,
                    child: Container(
                      width: 140,
                      height: 130,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                      ),
                      child: Icon(Icons.error),
                    ),
                  );
                },
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 4,
                    bottom: 4,
                    left: 10,
                    right: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 9,
                            child: Text(
                              product!.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 2.0),
                            child: Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                color: product!.isAvailable
                                    ? Color(0xFFFFE6E6)
                                    : Color(0xFFF5F6F9),
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                ICON_CONST.CHECK_MARK,
                                color: product!.isAvailable
                                    ? Color(0xFFFF4848)
                                    : Colors.black26,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top: 8)),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "${product!.price.toPrice()}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 15.0),
                              child: Text.rich(
                                TextSpan(
                                  text: Translate.of(context)!.translate("sold"),
                                  style: Theme.of(context).textTheme.caption,
                                  children: [
                                    TextSpan(
                                      text: " ${product!.soldQuantity}",
                                      style: Theme.of(context).textTheme.caption,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      Row(
                        children: [
                          AppTag(
                            "${product!.rating}",
                            type: TagType.rateSmall,
                          ),
                          Padding(padding: EdgeInsets.only(left: 4)),
                          StarRating(
                            rating: product!.rating.toDouble(),
                            size: 15,
                            color: AppTheme.yellowColor,
                            borderColor: AppTheme.yellowColor,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );

      case ProductViewType.witchList:
        if (product == null) {
          return Shimmer.fromColors(
            child: Row(
              children: <Widget>[
                Container(
                  width: 140,
                  height: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 8,
                    right: 8,
                    top: 4,
                    bottom: 4,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 20,
                        width: 220,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4),
                      ),
                      Container(
                        height: 10,
                        width: 200,
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
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                      ),
                      Container(
                        height: 10,
                        width: 180,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            baseColor: Theme.of(context).hoverColor,
            highlightColor: Theme.of(context).highlightColor,
          );
        }
        return InkWell(
          onTap: () {
            print("Product id: ${product!.id}");
            onPressed!(product!);
          },
          child: Row(
            children: [
              CachedNetworkImage(
                imageUrl: product!.images[0],
                imageBuilder: (context, imageProvider) {
                  return Container(
                    width: 140,
                    height: 130,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                  );
                },
                placeholder: (context, url) {
                  return Shimmer.fromColors(
                    baseColor: Theme.of(context).hoverColor,
                    highlightColor: Theme.of(context).highlightColor,
                    enabled: true,
                    child: Container(
                      width: 140,
                      height: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                        color: Colors.white,
                      ),
                    ),
                  );
                },
                errorWidget: (context, url, error) {
                  return Shimmer.fromColors(
                    baseColor: Theme.of(context).hoverColor,
                    highlightColor: Theme.of(context).highlightColor,
                    enabled: true,
                    child: Container(
                      width: 140,
                      height: 130,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                      ),
                      child: Icon(Icons.error),
                    ),
                  );
                },
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 4,
                    bottom: 4,
                    left: 10,
                    right: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 9,
                            child: Text(
                              product!.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top: 8)),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "${product!.price.toPrice()}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600),
                            ),
                          ]),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      Row(
                        children: [
                          AppTag(
                            "${product!.rating}",
                            type: TagType.rateSmall,
                          ),
                          Padding(padding: EdgeInsets.only(left: 4)),
                          StarRating(
                            rating: product!.rating.toDouble(),
                            size: 15,
                            color: AppTheme.yellowColor,
                            borderColor: AppTheme.yellowColor,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              action ?? Container()
            ],
          ),
        );


      default:
        return Container(width: 160.0);
    }
  }
}

class CustomDiscountCard extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double height = size.height;
    double width = size.width;

    path.lineTo(0, height);
    path.lineTo(width / 2, height * 0.85);
    path.lineTo(width, height);
    path.lineTo(width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
