import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/blocs/order/bloc.dart';
import 'package:ecommerce_app/configs/config.dart';
import 'package:ecommerce_app/data/models/models.dart';
import 'package:ecommerce_app/screens/cart/payment_fees_widget.dart';
import 'package:ecommerce_app/screens/delivery_address/delivery_address_card.dart';
import 'package:ecommerce_app/utils/utils.dart';
import 'package:ecommerce_app/widgets/cart_item_card.dart';
import 'package:ecommerce_app/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class DetailOrderScreen extends StatelessWidget {
  final OrderModel order;
  final bool afterCheckout;

  const DetailOrderScreen(
      {Key? key, required this.order, this.afterCheckout = false})
      : super(key: key);

  void _onCancelOrderModel(BuildContext context) {
    // Add remove order event
    BlocProvider.of<OrderBloc>(context).add(RemoveOrder(order));

    // Show toast:  Cancel successfully
    UtilToast.showMessageForUser(
      context,
      Translate.of(context)!.translate("cancel_successfully"),
    );
    // Pop this screen
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(Translate.of(context)!.translate("detail_order"))),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.only(bottom: 8),
          children: [
            _buildListOrderModelItems(context),
            PaymentFeesWidget(
              priceOfGoods: order.priceOfGoods,
              deliveryFee: order.deliveryFee,
              coupon: order.coupon,
              priceToBePaid: order.priceToBePaid,
            ),
            _buildPaymentMethod(context),
            DeliveryAddressCard(
              deliveryAddress: order.deliveryAddress,
              showDefautTick: false,
            ),
            _buildDelivering(context),
            afterCheckout == true
                ? _buildBackToHomeButton(context)
                : _buildRemoveButton(context),
          ],
        ),
      ),
    );
  }

  _buildDelivering(BuildContext context) {
    return CustomCardWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            order.isDelivering
                ? Translate.of(context)!.translate("be_delivering")
                : Translate.of(context)!.translate("delivered"),
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          TextRow(
            title: Translate.of(context)!.translate("created_at"),
            content: UtilFormatter.formatTimeStamp(order.createdAt),
          ),
        ],
      ),
    );
  }

  _buildPaymentMethod(BuildContext context) {
    return CustomCardWidget(
      child: TextRow(
        title: Translate.of(context)!.translate("payment_method"),
        content: order.paymentMethod,
        isSpaceBetween: true,
      ),
    );
  }

  _buildListOrderModelItems(BuildContext context) {
    return CustomCardWidget(
      child: Column(
        children: List.generate(order.items.length, (index) {
          return AppListTitle(
            icon: CachedNetworkImage(
              imageUrl: order.items[index].productImage,
              imageBuilder: (context, imageProvider) {
                return Container(
                  width: 100,
                  height: 100,
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
                    height: 170,
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
                    height: 170,
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
            subtitle: "x ${order.items[index].quantity}",
            title: order.items[index].productName,
            trailing: Text("${order.items[index].productPrice.toPrice()}",
                style: Theme.of(context).textTheme.subtitle1),
          );
        }),
      ),
    );
  }

  _buildRemoveButton(BuildContext context) {
    // Remove button only show when order is still in delivering time
    if (order.isDelivering) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: AppButton(
          Translate.of(context)!.translate("cancel"),
          onPressed: () => _onCancelOrderModel(context),
          color: Color(0xFFeb4d4b),
        ),
      );
    }
    return Container();
  }

  _buildBackToHomeButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: AppButton(
        Translate.of(context)!.translate("back_to_home"),
        onPressed: () => Navigator.pushReplacementNamed(context, Routes.home),
      ),
    );
  }
}
