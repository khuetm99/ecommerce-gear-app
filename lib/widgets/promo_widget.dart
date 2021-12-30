import 'package:flutter/material.dart';

class PromoWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 8,
        ),
        child: Row(
          children: List.generate(
              coupons.length,
              (index) => _buildCouponCard(
                    context,
                    coupons[index]["content"],
                    coupons[index]["expDate"],
                  )),
        ),
      ),
    );
  }

  _buildCouponCard(BuildContext context, String content, String expireDate) {
    return Container(
      constraints: BoxConstraints(maxWidth: 220),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: Theme.of(context).primaryColor, width: 6),
        ),
        color: Theme.of(context).backgroundColor,
        boxShadow: [
          BoxShadow(
            blurRadius: 1,
            spreadRadius: 1,
            color:  Color(0xFFd3d1d1).withOpacity(0.3),
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            content,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold),
            maxLines: 2,
            textWidthBasis: TextWidthBasis.longestLine,
          ),
          const SizedBox(height: 5),
          Text("EXP: " + expireDate),
        ],
      ),
    );
  }
}
