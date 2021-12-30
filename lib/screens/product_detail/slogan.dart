import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Slogan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.black12, width: 1),
          bottom: BorderSide(color: Colors.black12, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildSloganItem(
            iconPath: "assets/icons/return-free.svg",
            text: "Free return",
            context: context
          ),
          _buildSloganItem(
            iconPath: "assets/icons/safety.svg",
            text: "Authentic 100%",
              context: context
          ),
          _buildSloganItem(
            iconPath: "assets/icons/shipping.svg",
            text: "Fast delivery",
              context: context
          ),
        ],
      ),
    );
  }

  _buildSloganItem({required String iconPath, required String text, required BuildContext context}) {
    return Row(
      children: [
        SvgPicture.asset(
          iconPath,
          width: 20,
          height: 20,
          color: Theme.of(context).primaryColor,
        ),
        SizedBox(width: 5),
        Text(text),
      ],
    );
  }
}
