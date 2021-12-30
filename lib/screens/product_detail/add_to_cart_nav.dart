import 'package:ecommerce_app/blocs/app_bloc.dart';
import 'package:ecommerce_app/blocs/authentication/bloc.dart';
import 'package:ecommerce_app/blocs/cart/bloc.dart';
import 'package:ecommerce_app/configs/config.dart';
import 'package:ecommerce_app/constants/icon_constant.dart';
import 'package:ecommerce_app/data/models/models.dart';
import 'package:ecommerce_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';



class AddToCartNavigation extends StatefulWidget {
  final Product? product;
  const AddToCartNavigation({Key? key, this.product})
      : super(key: key);

  @override
  _AddToCartNavigationState createState() => _AddToCartNavigationState();
}

class _AddToCartNavigationState extends State<AddToCartNavigation> {
  Product? get product => widget.product;

  // local states
  int quantity = 1;

  void onDecreaseQuantity() => setState(() => quantity -= 1);
  void onIncreaseQuantity() => setState(() => quantity += 1);

  void onAddToCart() async{
    final authState =AppBloc.authBloc.state;

    if (authState is! Unauthenticated) {
      if (product != null) {
        // Create new cart item
        CartItemModel cartItem = CartItemModel(
          id: product!.id,
          productId: product!.id,
          price: product!.price * quantity,
          quantity: quantity,
        );

        // Add event AddToCart
        AppBloc.cartBloc.add(AddCartItemModel(cartItem));

        // Show toast: add successfully
        UtilToast.showMessageForUser(context, "Add successfully");
      }
    } else {
      final result = await Navigator.pushNamed(
        context,
        Routes.signIn,
        arguments: Routes.productDetail,
      );
      if (result != Routes.productDetail) {
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if(product == null) {
      return Container(
        height: 20,
      );
    }

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        boxShadow: [BoxShadow(offset: Offset(0.15, 0.4), color: Colors.black)],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(flex: 1, child: _buildSelectQuantity()),
            Expanded(flex: 1, child: _addToCartButton()),
          ],
        ),
      ),
    );
  }

  _buildSelectQuantity() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /// Button decreases the quantity of product
        AspectRatio(
          aspectRatio: 1,
          child: AbsorbPointer(
            absorbing: quantity > 1 ? false : true,
            child: InkWell(
              onTap: onDecreaseQuantity,
              child: Icon(Icons.remove, color: Theme.of(context).primaryColor),
            ),
          ),
        ),

        /// Display the quantity of product
        Text("$quantity", style: Theme.of(context).textTheme.headline6),

        /// Button increases the quantity of product
        AspectRatio(
          aspectRatio: 1,
          child: AbsorbPointer(
            absorbing: quantity < product!.quantity ? false : true,
            child: InkWell(
              onTap: onIncreaseQuantity,
              child: Icon(Icons.add, color: Theme.of(context).primaryColor),
            ),
          ),
        ),
      ],
    );
  }

  /// Build button add to cart
  _addToCartButton() {
    return Container(
      height: 50,
      color: Theme.of(context).primaryColor,
      child: TextButton(
        onPressed: product!.quantity > 0 ? onAddToCart : null,
        child: SvgPicture.asset(
          ICON_CONST.ADD_TO_CART,
          width: 30,
          color: Colors.white,
        ),
      ),
    );
  }
}
