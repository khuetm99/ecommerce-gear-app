import 'package:ecommerce_app/blocs/app_bloc.dart';
import 'package:ecommerce_app/blocs/cart/bloc.dart';
import 'package:ecommerce_app/screens/cart/checkout_bottom.dart';
import 'package:ecommerce_app/utils/dialog.dart';
import 'package:ecommerce_app/utils/utils.dart';
import 'package:ecommerce_app/widgets/widget.dart';
import 'package:flutter/material.dart';

import 'list_cart_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: ListCartItemModel(),
      bottomNavigationBar: CheckoutBottom(),
    );
  }

  _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(Translate.of(context)!.translate("cart")),
      actions: [
        IconButton(
            icon: Icon(Icons.clear_all_rounded),
            onPressed: () => _onClearCart(context))
      ],
    );
  }

  _onClearCart(BuildContext context) async {
    final response = await UtilDialog.showConfirmation(
        context,
      title: Translate.of(context)!.translate('clear_cart'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
        Translate.of(context)!
            .translate("all_cart_items_will_be_deleted_from_your_cart"),
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyText1,
            ),
          ],
        ),
      ),
      confirmButtonText: Translate.of(context)!.translate("delete"),
    ) as bool;

    if (response) {
      AppBloc.cartBloc.add(ClearCart());
    }
  }
}
