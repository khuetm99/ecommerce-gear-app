
import 'package:ecommerce_app/configs/config.dart';
import 'package:ecommerce_app/data/models/models.dart';
import 'package:ecommerce_app/utils/utils.dart';
import 'package:ecommerce_app/widgets/cart_item_card.dart';
import 'package:ecommerce_app/widgets/widget.dart';
import 'package:flutter/material.dart';

class OrderModelCard extends StatelessWidget {
  final OrderModel order;

  const OrderModelCard({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCardWidget(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.orderDetail,
          arguments: {"order" : order, "afterCheckout" : false},
        );
      },
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Delivery status
                Text.rich(
                  TextSpan(
                    style: Theme.of(context).textTheme.bodyText1,
                    children: [
                      TextSpan(
                        text: order.isDelivering
                            ? Translate.of(context)!.translate("be_delivering")
                            : Translate.of(context)!.translate("delivered"),
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                      if (!order.isDelivering)
                        TextSpan(
                          text:
                              " (${UtilFormatter.formatTimeStamp(order.receivedDate)})",
                        ),
                    ],
                  ),
                ),

                // Price to be paid and payment method
                TextRow(
                    title: Translate.of(context)!.translate("total"),
                    content:
                        "${order.priceToBePaid.toPrice()} (${order.paymentMethod})"),

                // Number of items
                TextRow(
                  title: Translate.of(context)!.translate("quantity"),
                  content:
                      "${order.items.length} ${Translate.of(context)!.translate("item")}",
                ),

                // Created at
                TextRow(
                  title: Translate.of(context)!.translate("created_at"),
                  content: UtilFormatter.formatTimeStamp(order.createdAt),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios),
        ],
      ),
    );
  }
}
