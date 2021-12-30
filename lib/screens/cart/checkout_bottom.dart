
import 'package:ecommerce_app/blocs/cart/bloc.dart';
import 'package:ecommerce_app/constants/icon_constant.dart';
import 'package:ecommerce_app/utils/app_extension.dart';
import 'package:ecommerce_app/utils/dialog.dart';
import 'package:ecommerce_app/utils/translate.dart';
import 'package:ecommerce_app/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'payment_bottom_sheet.dart';

class CheckoutBottom extends StatelessWidget {
  const CheckoutBottom({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, -0.5),
              color: Colors.black12,
              blurRadius: 5,
            )
          ],
        ),
        child: BlocBuilder<CartBloc, CartState>(
          buildWhen: (preState, currState) => currState is CartLoaded,
          builder: (context, state) {
            if (state is CartLoaded) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTotalPrice(context, state),
                  SizedBox(height: 10),
                  _buildCheckoutButton(context, state),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  _buildCheckoutButton(BuildContext context, CartLoaded state) {
    return AppButton(
      Translate.of(context)!.translate("check_out"),
      type: ButtonType.normal,
      onPressed: () {
        if (state.cart.length > 0) {
          _openPaymentBottomSheet(context);
        } else {
          UtilDialog.showInformation(
            context,
            content: Translate.of(context)!.translate("your_cart_is_empty"),
          );
        }
      },
    );
  }

  _buildTotalPrice(BuildContext context, CartLoaded state) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: Color(0xFFF5F6F9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: SvgPicture.asset(ICON_CONST.RECEIPT),
        ),
        SizedBox(width: 15),
        Text.rich(
          TextSpan(
          style: Theme.of(context).textTheme.headline6,
            children: [
              TextSpan(text: Translate.of(context)!.translate("total") + ":\n"),
              TextSpan(
                text: "${state.priceOfGoods.toPrice()}",
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _openPaymentBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Theme.of(context).backgroundColor == Colors.white ? Colors.white : Theme.of(context).appBarTheme.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      context: context,
      builder: (BuildContext context) => PaymentBottomSheet(),
    );
  }
}
