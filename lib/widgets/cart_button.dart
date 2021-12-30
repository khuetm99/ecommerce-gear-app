import 'package:ecommerce_app/blocs/app_bloc.dart';
import 'package:ecommerce_app/blocs/authentication/bloc.dart';
import 'package:ecommerce_app/blocs/cart/bloc.dart';
import 'package:ecommerce_app/configs/config.dart';
import 'package:ecommerce_app/constants/icon_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'icon_button_with_counter.dart';


class CartButton extends StatefulWidget {
  final Color? color;
  final double? size;

  const CartButton({
    Key? key,
    this.color, this.size,
  }) : super(key: key);

  @override
  State<CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {

  void onNavigateCart() async{
    final authState =AppBloc.authBloc.state;
    if(authState is Unauthenticated) {
      final result = await Navigator.pushNamed(
        context,
        Routes.signIn,
        arguments: Routes.cart,
      );
      if (result != Routes.cart) {
        return;
      }
    }
    Navigator.pushNamed(
      context,
      Routes.cart,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
        buildWhen: (prevState, currState) => currState is CartLoaded,
        builder: (context, state) {
          final authState = AppBloc.authBloc.state;

          return IconButtonWithCounter(
            icon: ICON_CONST.CART,
            onPressed: onNavigateCart,
            counter: state is CartLoaded && authState is Authenticated ? state.quantity : 0,
            size: widget.size ?? 25,
            color: widget.color ?? Theme.of(context).colorScheme.onSurface,
          );
        });
  }
}
