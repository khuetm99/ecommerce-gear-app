import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/blocs/app_bloc.dart';
import 'package:ecommerce_app/blocs/cart/bloc.dart';
import 'package:ecommerce_app/configs/config.dart';
import 'package:ecommerce_app/constants/icon_constant.dart';
import 'package:ecommerce_app/utils/utils.dart';
import 'package:ecommerce_app/data/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

class CartItemModelCard extends StatelessWidget {
  const CartItemModelCard({
    Key? key,
    required this.cartItem,
    this.allowChangeQuantity = true,
  }) : super(key: key);

  final CartItemModel cartItem;
  final bool allowChangeQuantity;

  @override
  Widget build(BuildContext context) {
    var product = cartItem.productInfo!;
    return CustomCardWidget(
      onTap: () => Navigator.pushNamed(
        context,
        Routes.productDetail,
        arguments: product.id,
      ),
      margin: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 10,
      ),
      padding: EdgeInsets.only(right: 8),
      child: Row(
        children: [
          _buildCartItemModelImage(product),
          SizedBox(width: 10),
          Expanded(child: _buildCartItemModelInfo(product, context)),
        ],
      ),
    );
  }

  _buildCartItemModelImage(Product product) {
    return Padding(
      padding: EdgeInsets.all(5),
      child:  CachedNetworkImage(
        imageUrl: product.images[0],
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
    );
  }

  _buildCartItemModelInfo(Product product, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Product Name
        Text(
          "${product.name}",
          style: Theme.of(context)
        .textTheme
        .subtitle1!
        .copyWith(fontWeight: FontWeight.w600),
          maxLines: 2,
        ),

        // Cart item price
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Text(
            "${product.price.toPrice()}",
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600),
          ),
        ),

        allowChangeQuantity
            ? _buildCartItemModelQuantity(product, context)
            : Text("x ${cartItem.quantity}")
      ],
    );
  }

  _buildCartItemModelQuantity(Product product, BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Decrease button
        CircleIconButton(
          svgIcon: ICON_CONST.SUBTRACT,
          color: Color(0xFFF5F6F9),
          size: 10,
          onPressed: cartItem.quantity > 1
              ? () => _onChangeQuantity(context, product, cartItem.quantity - 1)
              : () {},
        ),

        // Quantity
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
          child: Text("${cartItem.quantity}", style: Theme.of(context).textTheme.bodyText1!.
          copyWith(fontSize: 17)),
        ),

        // Increase button
        CircleIconButton(
          svgIcon: ICON_CONST.ADD,
          color: Color(0xFFF5F6F9),
          size: 10,
          onPressed: cartItem.quantity < product.quantity
              ? () => _onChangeQuantity(context, product, cartItem.quantity + 1)
              : () {},
        )
      ],
    );
  }

  _onChangeQuantity(BuildContext context, Product product, int newQuantity) {
    // update cart item
    AppBloc.cartBloc.add(UpdateCartItemModel(
      cartItem.cloneWith(
        quantity: newQuantity,
        price: newQuantity * product.price,
      ),
    ));
  }
}

class CustomCardWidget extends StatelessWidget {
  final Widget child;
  final BoxDecoration? decoration;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Function()? onTap;

  const CustomCardWidget({
    Key? key,
    this.decoration,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: width,
          height: height,
          margin: margin == null
              ? EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 8,
          )
              : margin,
          padding: padding == null
              ? EdgeInsets.all(8)
              : padding,
          decoration: decoration ?? _defaultDecoration(context),
          child: child,
        ),
      ),
    );
  }

  _defaultDecoration(BuildContext context) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Color(0xFFd3d1d1).withOpacity(0.3)),
      color: Theme.of(context).backgroundColor,
      boxShadow: [
        BoxShadow(
          blurRadius: 1,
          spreadRadius: 1,
          color: Color(0xFFd3d1d1).withOpacity(0.2),
          offset: Offset(0, 2),
        ),
      ],
    );
  }
}

class CircleIconButton extends StatelessWidget {
  final double size;
  final Function? onPressed;
  final String svgIcon;
  final Color? color;

  const CircleIconButton({
    Key? key,
    required this.size,
    required this.svgIcon,
    this.onPressed,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed as void Function()?,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color ?? Theme.of(context).accentColor,
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          svgIcon,
          width: size,
          height: size,
        ),
      ),
    );
  }
}
