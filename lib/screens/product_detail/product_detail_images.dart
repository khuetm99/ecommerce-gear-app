import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/configs/config.dart';
import 'package:ecommerce_app/data/models/models.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetailImages extends StatefulWidget {
  final Product product;
  const ProductDetailImages({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailImagesState createState() => _ProductDetailImagesState();
}

class _ProductDetailImagesState extends State<ProductDetailImages> {
  Product get product => widget.product;
// Local states
  int currentPage = 0;


  void onPageChanged(index) => setState(() => currentPage = index);

  ///On preview crop_photo
  void _onPreviewPhoto(int index) {
    Navigator.pushNamed(
      context,
      Routes.photoPreview,
      arguments: {"galleries": widget.product.images, "index": index},
    );
  }

  ///On preview crop_photo
  void _onNavigateGallery(int index) {
    Navigator.pushNamed(
      context,
      Routes.gallery,
      arguments: {"products": widget.product, "index": index},
    );
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width *
        MediaQuery.of(context).devicePixelRatio;

    double screenHeight = MediaQuery.of(context).size.height *
        MediaQuery.of(context).devicePixelRatio;

    return Stack(
      children: [
        /// Product image preview
        Container(
          child: PageView.builder(
            itemCount: product.images.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: (){
                  _onNavigateGallery(index);
                },
                child: CachedNetworkImage(
                  imageUrl: product.images[index],
                  placeholder: (context, url) {
                    return Shimmer.fromColors(
                      baseColor: Theme.of(context).hoverColor,
                      highlightColor: Theme.of(context).highlightColor,
                      enabled: true,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                  errorWidget: (context, url, error) {
                    return Shimmer.fromColors(
                      baseColor: Theme.of(context).hoverColor,
                      highlightColor: Theme.of(context).highlightColor,
                      enabled: true,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Icon(Icons.error),
                      ),
                    );
                  },
                ),
              );
            },
            onPageChanged: onPageChanged,
          ),
        ),

        /// Indicators
        Positioned(
          bottom: 5,
          right: 0.0,
          left: 0.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
                product.images.length, (index) => _buildIndicator(index)),
          ),
        ),
      ],
    );
  }

  _buildIndicator(int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.only(right: 5),
      height: 3,
      width: currentPage == index
          ? 60
          : 40,
      decoration: BoxDecoration(
        color:
        currentPage == index ? Theme.of(context).primaryColor : Color(0xFFD8D8D8),
      ),
    );
  }
}
