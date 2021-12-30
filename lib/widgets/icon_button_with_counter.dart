import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class IconButtonWithCounter extends StatelessWidget {
  const IconButtonWithCounter({
    Key? key,
    required this.counter,
    required this.icon,
    this.size,
    this.onPressed,
    this.color,
  }) : super(key: key);

  final int counter;
  final String icon;
  final Function()? onPressed;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      clipBehavior: Clip.none,
      children: [
        _buildIcon(),
        if (counter > 0) _buildCounter(context),
      ],
    );
  }

  _buildIcon() {
    return InkWell(
      child: SvgPicture.asset(
        icon,
        width: size,
        height: size,
        color: color,
      ),
      onTap: onPressed,
    );
  }

  _buildCounter(BuildContext context) {
    return Positioned(
      right: -8,
      top: -5,
      child: Container(
        alignment: Alignment.center,
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: Center(
          child: Text(
            "${counter > 99 ? "99+" : counter}",
            style: Theme.of(context).textTheme.caption!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600
            )
          ),
        ),
      ),
    );
  }
}
