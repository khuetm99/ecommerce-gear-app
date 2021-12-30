import 'package:ecommerce_app/data/models/models.dart';
import 'package:ecommerce_app/utils/utils.dart';
import 'package:ecommerce_app/widgets/cart_item_card.dart';
import 'package:ecommerce_app/widgets/widget.dart';
import 'package:flutter/material.dart';

class DeliveryAddressCard extends StatelessWidget {
  final DeliveryAddressModel deliveryAddress;
  final Function()? onPressed;
  final bool showDefautTick;

  const DeliveryAddressCard({
    Key? key,
    required this.deliveryAddress,
    this.onPressed,
    this.showDefautTick = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCardWidget(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  Translate.of(context)!.translate("delivery_address"),
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color:  Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600
                  ),
                ),
                Spacer(),
                _buildDefaultText(context),
              ],
            ),
            TextRow(
              title: Translate.of(context)!.translate("name"),
              content: deliveryAddress.receiverName,
            ),
            TextRow(
              title: Translate.of(context)!.translate("phone_number"),
              content: deliveryAddress.phoneNumber,
            ),
            TextRow(
              title: Translate.of(context)!.translate("detail_address"),
              content: deliveryAddress.toString(),
            ),
          ],
        ),
      ),
    );
  }

  _buildDefaultText(BuildContext context) {
    return deliveryAddress.isDefault && showDefautTick
        ? Text(
            "[" + Translate.of(context)!.translate("default") + "]",
            style: Theme.of(context).textTheme.subtitle2!.copyWith(
                color:  Theme.of(context).primaryColor,
            ),
          )
        : Container();
  }
}
