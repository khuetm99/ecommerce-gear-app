
import 'package:ecommerce_app/configs/size_config.dart';
import 'package:flutter/material.dart';

class SearchFieldWidget extends StatelessWidget {
  final TextEditingController? searchController;
  final bool readOnly;
  final bool autoFocus;
  final Function()? onTap;
  final String? hintText;
  final double? height;

  const SearchFieldWidget({
    Key? key,
    this.readOnly = false,
    this.autoFocus = false,
    this.onTap,
    this.searchController,
    this.hintText = "",
    this.height,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height == null ? SizeConfig.defaultSize * 4 : height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.defaultSize * 2),
        color: Color(0xFFd3d1d1).withOpacity(0.3),
      ),
      child: TextField(
        controller: searchController,
        keyboardType: TextInputType.text,
        autofocus: autoFocus,
        readOnly: readOnly,
        onTap: onTap,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          isDense: true,
          hintText: hintText,
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(Icons.search),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
