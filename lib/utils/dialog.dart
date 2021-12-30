
import 'package:ecommerce_app/utils/utils.dart';
import 'package:ecommerce_app/widgets/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UtilDialog {
  static showInformation(
    BuildContext context, {
    String? title,
    String? content,
    Function()? onClose,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title == null
                ? Translate.of(context)!.translate("message_for_you")
                : title,
          ),
          content: Text(content!),
          actions: <Widget>[
            TextButton(
              child: Text(
                Translate.of(context)!.translate("close"),
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyText1!.copyWith(color: Theme.of(context).primaryColor),
              ),
              onPressed:
                  onClose != null ? onClose : () => Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  }

  static showWaiting(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            height: 150,
            alignment: Alignment.center,
            child: Loading(),
          ),
        );
      },
    );
  }

  static hideWaiting(BuildContext context) {
    Navigator.pop(context);
  }

  static Future<bool?> showConfirmation(
    BuildContext context, {
    String? title,
    required Widget content,
    String confirmButtonText = "Yes",
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title == null
                ? Translate.of(context)!.translate("message_for_you")
                : title,
          ),
          content: content,
          actions: <Widget>[
            TextButton(
              child: Text(
                Translate.of(context)!.translate("close"),
                style: Theme.of(context).textTheme.button!.copyWith(
                  color: Theme.of(context).primaryColor
                ),
              ),
              onPressed: () => Navigator.pop(context, false),
            ),
            TextButton(
              child: Text(
                confirmButtonText,
                style: Theme.of(context).textTheme.button!.copyWith(
                  color: Theme.of(context).backgroundColor
                ),
              ),
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor),
            ),
          ],
        );
      },
    );
  }
}
