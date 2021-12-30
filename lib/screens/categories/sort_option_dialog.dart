import 'package:ecommerce_app/blocs/categories/bloc.dart';
import 'package:ecommerce_app/utils/dialog.dart';
import 'package:ecommerce_app/utils/utils.dart';
import 'package:ecommerce_app/widgets/app_button.dart';
import 'package:flutter/material.dart';

class SortOptionDialog extends StatefulWidget {
  final ProductSortOption currSortOption;
  const SortOptionDialog({
    Key? key,
    required this.currSortOption,
  }) : super(key: key);
  @override
  _SortOptionDialogState createState() => _SortOptionDialogState();
}

class _SortOptionDialogState extends State<SortOptionDialog> {
  late ProductSortOption sortOption;

  @override
  void initState() {
    super.initState();
    sortOption = widget.currSortOption;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        Translate.of(context)!.translate('sort_options'),
        style: Theme.of(context).textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w600),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${Translate.of(context)!.translate('sort_by')}:"),
                SizedBox(width: 8),
                RadioListTile(
                  title: Text(Translate.of(context)!.translate('price')),
                  value: PRODUCT_SORT_BY.PRICE,
                  groupValue: sortOption.productSortBy,
                  onChanged: (value) {
                    setState(() {
                      sortOption = sortOption.update(productSortBy: value);
                    });
                  },
                ),
                RadioListTile(
                  title: Text(Translate.of(context)!.translate('sold_quantity')),
                  value: PRODUCT_SORT_BY.SOLD_QUANTITY,
                  groupValue: sortOption.productSortBy,
                  onChanged: (value) {
                    setState(() {
                      sortOption = sortOption.update(productSortBy: value);
                    });
                  },
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${Translate.of(context)!.translate('sort_order')}:"),
                SizedBox(width: 8),
                RadioListTile(
                  title: Text(Translate.of(context)!.translate('descending')),
                  value: PRODUCT_SORT_ORDER.DESCENDING,
                  groupValue: sortOption.productSortOrderModel,
                  onChanged: (value) {
                    setState(() {
                      sortOption =
                          sortOption.update(productSortOrderModel: value);
                    });
                  },
                ),
                RadioListTile(
                  title: Text(Translate.of(context)!.translate('ascending')),
                  value: PRODUCT_SORT_ORDER.ASCENDING,
                  groupValue: sortOption.productSortOrderModel,
                  onChanged: (value) {
                    setState(() {
                      sortOption =
                          sortOption.update(productSortOrderModel: value);
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 8),
            AppButton(
              "Select",
              onPressed: () {
                // productSortOrderModel default is descending, so it's not null
                if (sortOption.productSortBy != null) {
                  Navigator.pop(context, sortOption);
                } else {
                  UtilDialog.showInformation(
                    context,
                    content: "Sort by isn't selected",
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
