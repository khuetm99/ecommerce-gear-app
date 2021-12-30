import 'package:ecommerce_app/utils/utils.dart';
import 'package:ecommerce_app/widgets/cart_item_card.dart';
import 'package:ecommerce_app/widgets/widget.dart';
import 'package:flutter/material.dart';

class PaymentFeesWidget extends StatelessWidget {
  final int priceOfGoods;
  final int deliveryFee;
  final int coupon;
  final int priceToBePaid;

  const PaymentFeesWidget({
    Key? key,
    required this.priceOfGoods,
    required this.deliveryFee,
    required this.coupon,
    required this.priceToBePaid,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CustomCardWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextRow(
            title: Translate.of(context)!.translate("total"),
            contentStyle: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 17,
                color: Theme.of(context).primaryColor,
               ),
            content: priceToBePaid.toPrice(),
            contentCrossAxis: CrossAxisAlignment.end,
          ),
          TextRow(
            title: Translate.of(context)!.translate("price_of_goods"),
            content: priceOfGoods.toPrice(),
          ),
          TextRow(
            title: Translate.of(context)!.translate("delivery_fee"),
            content: deliveryFee.toPrice(),
          ),
          TextRow(
            title: Translate.of(context)!.translate("coupon"),
            content: coupon.toPrice(),
          ),
        ],
      ),
    );
  }
}
