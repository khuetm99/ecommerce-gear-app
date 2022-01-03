import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce_app/data/models/banner_model.dart';
import 'package:ecommerce_app/utils/dialog.dart';
import 'package:ecommerce_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeBanner extends StatefulWidget {
  final List<BannerModel>? banners;

  const HomeBanner({Key? key, required this.banners}) : super(key: key);

  @override
  _HomeBannerState createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  List<BannerModel>? get banners => widget.banners;

  final double aspectRatioBanner = 2 / 1;

  var currentIndex = 0;

  ///Make action
  Future<void> _makeAction(String? url, BuildContext context) async {
    if(url != null) {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        UtilDialog.showInformation(context,
            content: Translate.of(context)!.translate('cannot_make_action'));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (banners == null) {
      return Column(
        children: [
          Container(
            height: 200,
            child: Shimmer.fromColors(
              baseColor: Theme.of(context).hoverColor,
              highlightColor: Theme.of(context).highlightColor,
              enabled: true,
              child: Container(
                color: Colors.white,
              ),
            ),
          ),
          _buildIndicators(),
        ],
      );
    }

    return Container(
      child: Stack(
        children: [
          _buildSlider(),
          Positioned(
            left: 10,
            bottom: 15,
            child: _buildIndicators(),
          )
        ],
      ),
    );
  }

  _buildSlider() {
    return CarouselSlider(
      items: banners!.map((banner) {
        return CachedNetworkImage(
          imageUrl: banner.imageUrl,
          placeholder: (context, url) {
            return Container(
              height: 150,
              color: Theme.of(context).scaffoldBackgroundColor,
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
            return GestureDetector(
              onTap: () => _makeAction(banner.linkUrl, context),
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
          errorWidget: (context, url, error) {
            return Container(
              height: 150,
              color: Theme.of(context).scaffoldBackgroundColor,
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
        );
      }).toList(),
      options: CarouselOptions(
        pageViewKey: PageStorageKey("home_banner"),
        aspectRatio: 18 / 9,
        initialPage: 0,
        viewportFraction: 1.0,
        enableInfiniteScroll: true,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 4),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.linearToEaseOut,
        enlargeCenterPage: true,
        onPageChanged: (index, reason) {
          setState(() => currentIndex = index);
        },
      ),
    );
  }

  _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...List.generate(banners?.length ?? 0, (index) {
          return _buildIndicatorNormal(index == currentIndex);
        })
      ],
    );
  }

  _buildIndicatorNormal(bool isSelected) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      height: 4,
      width: isSelected ? 30 : 25,
      margin: EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        color: isSelected ? Theme.of(context).primaryColor : Color(0xffd9d5d5),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
