import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AppTextInputBlur extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final VoidCallback? onTapIcon;
  final GestureTapCallback? onTap;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Icon? icon;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? errorText;
  final int? maxLines;

  AppTextInputBlur({
    Key? key,
    this.hintText,
    this.controller,
    this.focusNode,
    this.onTapIcon,
    this.onTap,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.errorText,
    this.maxLines = 1,
  }) : super(key: key);

  Widget _buildErrorLabel(BuildContext context) {
    if (errorText == null) {
      return Container();
    }

    return Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Text(
        errorText!,
        style: Theme.of(context)
            .textTheme
            .caption!
            .copyWith(color: Theme.of(context).errorColor),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).dividerColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: <Widget>[
          TextFormField(
            onTap: onTap,
            textAlignVertical: TextAlignVertical.center,
            onFieldSubmitted: onSubmitted,
            autovalidateMode: AutovalidateMode.always,
            controller: controller,
            focusNode: focusNode,
            onChanged: onChanged,
            obscureText: obscureText!,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            maxLines: maxLines,
            validator: validator,
            decoration: InputDecoration(
              hintText: hintText,
              suffixIcon: icon != null
                  ? GestureDetector(
                      dragStartBehavior: DragStartBehavior.down,
                      onTap: onTapIcon,
                      child: icon,
                    )
                  : null,
              border: InputBorder.none,
            ),
          ),
          _buildErrorLabel(context)
        ],
      ),
    );
  }
}
