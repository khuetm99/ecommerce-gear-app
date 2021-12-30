import 'package:flutter/material.dart';

class TextRow extends StatelessWidget {
  final String title;
  final String content;
  final TextStyle? titleStyle;
  final TextStyle? contentStyle;
  final bool isSpaceBetween;
  final CrossAxisAlignment? contentCrossAxis;

  const TextRow({
    Key? key,
    required this.title,
    required this.content,
    this.isSpaceBetween = false,
    this.titleStyle,
    this.contentStyle, this.contentCrossAxis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: isSpaceBetween
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  content,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            )
          : Row(
              crossAxisAlignment: contentCrossAxis ?? CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 120,
                  child: Text(
                    title,
                    style: titleStyle == null
                        ? Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(fontWeight: FontWeight.bold)
                        : titleStyle,
                  ),
                ),
                Expanded(
                  child: Text(
                    content,
                    style: contentStyle == null
                        ? Theme.of(context).textTheme.subtitle2
                        : contentStyle,
                  ),
                )
              ],
            ),
    );
  }
}
