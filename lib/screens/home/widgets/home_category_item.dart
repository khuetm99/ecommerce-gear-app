import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/data/models/models.dart';
import 'package:ecommerce_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeCategoryItem extends StatelessWidget {
  const HomeCategoryItem({
    Key? key,
    this.category,
    this.onPressed,
  }) : super(key: key);

  final CategoryModel? category;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    if (category == null) {
      return Container(
        child: Shimmer.fromColors(
          baseColor: Theme.of(context).hoverColor,
          highlightColor: Theme.of(context).highlightColor,
          enabled: true,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),

          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: category!.imageUrl,
            placeholder: (context, url) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: Shimmer.fromColors(
                  baseColor: Theme.of(context).hoverColor,
                  highlightColor: Theme.of(context).highlightColor,
                  enabled: true,
                  child: Container(
                    color: Colors.white,
                  ),
                ),
              );
            },
            imageBuilder: (context, imageProvider) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
            errorWidget: (context, url, error) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: Shimmer.fromColors(
                  baseColor: Theme.of(context).hoverColor,
                  highlightColor: Theme.of(context).highlightColor,
                  enabled: true,
                  child: Container(
                    color: Colors.white,
                    child: Icon(Icons.error),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 5,
            left: 5,
            child: Text(
              Translate.of(context)!.translate("${category!.name}"),
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
