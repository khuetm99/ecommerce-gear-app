import 'package:ecommerce_app/blocs/app_bloc.dart';
import 'package:ecommerce_app/blocs/discount/discount_bloc.dart';
import 'package:ecommerce_app/data/models/discount_model.dart';
import 'package:ecommerce_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class PromoWidget extends StatefulWidget {
  final bool canChoose;

  const PromoWidget({Key? key, required this.canChoose}) : super(key: key);

  @override
  State<PromoWidget> createState() => _PromoWidgetState();
}

class _PromoWidgetState extends State<PromoWidget> {
  final List<Map<String, dynamic>> coupons = [
    {
      "content": "Save 200k with orders from 2.000.000đ and up",
      "expDate": "05/04/2022"
    },
    {
      "content": "Save 500k with orders from 5.000.000đ and up",
      "expDate": "10/04/2022"
    },
    {
      "content": "Save 1000k with orders from 12.000.000đ and up",
      "expDate": "30/04/2022"
    }
  ];

  @override
  void initState() {
    AppBloc.discountBloc.add(LoadDiscount());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 8,
        ),
        child: BlocBuilder<DiscountBloc, DiscountState>(
          buildWhen: (prevState, currState) => currState is! DiscountChoosed,
          builder: (context, state) {
            List<DiscountModel>? discounts;

            if (state is DiscountLoaded) {
              discounts = state.discounts;
            }

            return _buildListDiscounts(discounts);
          },
        ),
      ),
    );
  }

  Widget _buildListDiscounts(List<DiscountModel>? discounts) {
    if (discounts == null) {
      return Row(children: List.generate(4, (index) => CouponCard()));
    }
    return Row(
      children: List.generate(
        discounts.length,
        (index) => CouponCard(
          discountModel: discounts[index],
          canChoose: widget.canChoose,
        ),
      ),
    );
  }
}

class CouponCard extends StatefulWidget {
  final DiscountModel? discountModel;
  final bool canChoose;

  const CouponCard({Key? key, this.discountModel, this.canChoose = false})
      : super(key: key);

  @override
  _CouponCardState createState() => _CouponCardState();
}

class _CouponCardState extends State<CouponCard> {
  DiscountModel? get discountModel => widget.discountModel;

  @override
  Widget build(BuildContext context) {
    if (discountModel == null) {
      return Shimmer.fromColors(
          child: Container(
            constraints: BoxConstraints(maxWidth: 220),
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              border: Border(
                left:
                    BorderSide(color: Theme.of(context).primaryColor, width: 6),
              ),
              color: Theme.of(context).backgroundColor,
              boxShadow: [
                BoxShadow(
                  blurRadius: 1,
                  spreadRadius: 1,
                  color: Color(0xFFd3d1d1).withOpacity(0.3),
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 150,
                  height: 20,
                  color: Colors.white,
                ),
                Padding(padding: EdgeInsets.only(top: 4)),
                Container(
                  height: 10,
                  width: 110,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          baseColor: Theme.of(context).hoverColor,
          highlightColor: Theme.of(context).highlightColor);
    }

    return BlocBuilder<DiscountBloc, DiscountState>(
      builder: (context, state) {
        var choosedState;
        if (state is DiscountChoosed) {
          choosedState = state;
        }
        return GestureDetector(
          onTap: () {
            if (widget.canChoose) {
              AppBloc.discountBloc
                  .add(ChooseDiscount(discount: discountModel!));
            }
          },
          child: Container(
            constraints: BoxConstraints(maxWidth: 220),
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                    color: (choosedState != null && widget.canChoose &&
                            choosedState.discountModel == discountModel)
                        ? Theme.of(context).accentColor
                        : Theme.of(context).primaryColor,
                    width: 6),
              ),
              color: Theme.of(context).backgroundColor,
              boxShadow: [
                BoxShadow(
                  blurRadius: 1,
                  spreadRadius: 1,
                  color: Color(0xFFd3d1d1).withOpacity(0.3),
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  discountModel!.content,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  textWidthBasis: TextWidthBasis.longestLine,
                ),
                const SizedBox(height: 5),
                Text("EXP: " +
                    UtilFormatter.formatTimeStampToDiscountTimestamp(
                        discountModel!.expDate)),
              ],
            ),
          ),
        );
      },
    );
  }
}
