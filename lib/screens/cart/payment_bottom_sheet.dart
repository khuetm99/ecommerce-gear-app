import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/blocs/cart/bloc.dart';
import 'package:ecommerce_app/blocs/order/bloc.dart';
import 'package:ecommerce_app/blocs/profile/bloc.dart';
import 'package:ecommerce_app/configs/config.dart';
import 'package:ecommerce_app/data/models/models.dart';
import 'package:ecommerce_app/screens/cart/payment_fees_widget.dart';
import 'package:ecommerce_app/screens/delivery_address/delivery_address_card.dart';
import 'package:ecommerce_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:square_in_app_payments/in_app_payments.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:square_in_app_payments/models.dart';
import 'package:uuid/uuid.dart';

class PaymentBottomSheet extends StatefulWidget {
  @override
  _PaymentBottomSheetState createState() => _PaymentBottomSheetState();
}

class _PaymentBottomSheetState extends State<PaymentBottomSheet> {
  List<OrderModelItem> listOrderModelItem = [];
  int priceOfGoods = 0;
  int deliveryFee = 0;
  int coupon = 0;
  int priceToBePaid = 0;

  @override
  void initState() {
    CartState cartState = BlocProvider.of<CartBloc>(context).state;
    if (cartState is CartLoaded) {
      listOrderModelItem = cartState.cart
          .map((c) => OrderModelItem.fromCartItemModel(c))
          .toList();
      priceOfGoods = cartState.priceOfGoods;
      deliveryFee = 30000;

      if (priceOfGoods >= 12000000) {
        coupon = 1000000;
      } else if (priceOfGoods >= 5000000) {
        coupon = 500000;
      } else if (priceOfGoods >= 2000000) {
        coupon = 200000;
      }

      priceToBePaid = priceOfGoods + deliveryFee - coupon;
    }

    super.initState();
  }

  Future<void> _initSquarePayment() async {
    await InAppPayments.setSquareApplicationId(
      'sandbox-sq0idb-otEYIcGuXP406Ql-_yHO7A',
    );
    await InAppPayments.startCardEntryFlow(
      onCardEntryCancel: () {},
      onCardNonceRequestSuccess: (CardDetails result) async {
        await InAppPayments.completeCardEntry(
          onCardEntryComplete: () {
            _addNewOrder(paymentMethod: "Credit card");
          },
        );
      },
      collectPostalCode: false,
    );
  }

  void _addNewOrder({required String paymentMethod}) {
    ProfileState profileState = BlocProvider.of<ProfileBloc>(context).state;
    if (profileState is ProfileLoaded) {
      // create new order
      var newOrderModel = OrderModel(
        id: Uuid().v1(),
        uid: profileState.loggedUser.id,
        items: listOrderModelItem,
        createdAt: Timestamp.now(),
        deliveryAddress: profileState.loggedUser.defaultAddress!,
        paymentMethod: paymentMethod,
        priceToBePaid: priceToBePaid,
        priceOfGoods: priceOfGoods,
        deliveryFee: deliveryFee,
        coupon: coupon,
      );
      // Add event add order
      BlocProvider.of<OrderBloc>(context).add(AddOrder(newOrderModel));
      // Clear cart
      BlocProvider.of<CartBloc>(context).add(ClearCart());
      // Show toast: OrderModel successfully
      UtilToast.showMessageForUser(
        context,
        Translate.of(context)!.translate("order_successfully"),
      );
      // Go to detail order screen

      Navigator.popAndPushNamed(
        context,
        Routes.orderDetail,
        arguments: {"order": newOrderModel, "afterCheckout": true},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            _buildDeliveryAddressModel(),
            PaymentFeesWidget(
              priceOfGoods: priceOfGoods,
              deliveryFee: deliveryFee,
              coupon: coupon,
              priceToBePaid: priceToBePaid,
            ),
            SizedBox(height: 15),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  _buildHeader() {
    return Align(
      alignment: Alignment.center,
      child: Text(
        Translate.of(context)!.translate('payment'),
        style: Theme.of(context).textTheme.headline5!.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  _buildDeliveryAddressModel() {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          var defaultAddress = state.loggedUser.defaultAddress;
          return defaultAddress != null
              ? DeliveryAddressCard(
                  deliveryAddress: defaultAddress,
                  onPressed: () => Navigator.pushNamed(
                    context,
                    Routes.deliveryAddress,
                  ),
                )
              : Column(
                  children: [
                    Text(Translate.of(context)!.translate("no_address")),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, Routes.deliveryAddress);
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor),
                      child: Text(
                        Translate.of(context)!.translate("add_new_address"),
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                );
        }
        if (state is ProfileLoadFailure) {
          return Center(child: Text("Load failure"));
        }
        return Center(child: Text("Something went wrongs."));
      },
    );
  }

  _buildButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Expanded(
            child: _buildPaymentButton(
              onPressed: () => _addNewOrder(paymentMethod: "Cash"),
              text: "CASH",
              buttonColor: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: _buildPaymentButton(
              onPressed: _initSquarePayment,
              text: "VISA/MASTER",
              buttonColor: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  _buildPaymentButton({
    required Function() onPressed,
    required String text,
    Color? buttonColor,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: buttonColor ?? Theme.of(context).primaryColor,
        ),
        padding: EdgeInsets.all(10),
        child: Text(
          text,
          style: Theme.of(context).textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
      ),
    );
  }
}
