import 'package:flutter/material.dart';

enum TagType { primary, status, chip, rateSmall }

class AppTag extends StatelessWidget {
  AppTag(
    this.data, {
    Key? key,
    this.type,
    this.icon,
    this.onPressed,
  }) : super(key: key);

  final String? data;
  final TagType? type;
  final Widget? icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case TagType.primary:
        return RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          onPressed: onPressed,
          child: Text(
            data!,
            style: Theme.of(context).textTheme.caption!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),
        );

      case TagType.rateSmall:
        return InkWell(
          onTap: onPressed,
          child: Container(
            padding: EdgeInsets.only(
              left: 5,
              right: 5,
              bottom: 3,
              top: 3,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(3),
                bottomLeft: Radius.circular(3),
                bottomRight: Radius.circular(3),
              ),
            ),
            child: Text(
              data!,
              style: Theme.of(context).textTheme.caption!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        );

      case TagType.status:
        return InkWell(
          onTap: onPressed,
          child: Container(
            padding: EdgeInsets.only(
              left: 5,
              right: 5,
              top: 3,
              bottom: 3,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(3)),
            ),
            child: Text(
              data!,
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .copyWith(color: Colors.white),
            ),
          ),
        );

      case TagType.chip:
        return InkWell(
          onTap: onPressed,
          child: Container(
            padding: EdgeInsets.only(
              top: 3,
              bottom: 3,
              left: 6,
              right: 6,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              color: Theme.of(context).dividerColor,
            ),
            child: Container(
              child: Row(
                children: <Widget>[
                  icon != null
                      ? Padding(
                          padding: EdgeInsets.only(right: 3),
                          child: icon,
                        )
                      : Container(),
                  Text(
                    data!,
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(color: Theme.of(context).accentColor),
                  )
                ],
              ),
            ),
          ),
        );

      default:
        return InkWell(
          onTap: onPressed,
          child: Container(),
        );
    }
  }
}
