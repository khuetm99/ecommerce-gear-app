import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce_app/configs/config.dart';
import 'package:ecommerce_app/data/models/models.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Gallery extends StatefulWidget {
  final Product product;
  final int index;

  Gallery({required this.product, required this.index}) : super();

  @override
  _GalleryState createState() {
    return _GalleryState();
  }
}

class _GalleryState extends State<Gallery> {
  final _controller = CarouselController();
  final _listController = ScrollController();

  int _index = 0;

  @override
  void initState() {
    super.initState();
    _index = widget.index;
  }

  ///On preview crop_photo
  void _onPreviewPhoto(int index) {
    Navigator.pushNamed(
      context,
      Routes.photoPreview,
      arguments: {"galleries": widget.product.images, "index": index},
    );
  }

  ///On select image
  void _onSelectImage(int index) {
    _controller.animateToPage(index);
  }

  ///On Process index change
  void _onChange(int index) {
    setState(() {
      _index = index;
    });
    final currentOffset = (index + 1) * 90.0;
    final widthDevice = MediaQuery.of(context).size.width;

    ///Animate scroll to Overflow offset
    if (currentOffset > widthDevice) {
      _listController.animateTo(
        currentOffset - widthDevice,
        duration: Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    } else {
      ///Move to Start offset when index not overflow
      _listController.animateTo(
        0.0,
        duration: Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CarouselSlider(
                    carouselController: _controller,
                    items: widget.product.images.asMap().entries.map((entry) {
                      int index = entry.key;
                      String image = entry.value;

                      return GestureDetector(
                        onTap: () {
                          _onPreviewPhoto(index);
                        },
                        child: CachedNetworkImage(
                          imageUrl: widget.product.images[index],
                          imageBuilder: (context, imageProvider) {
                            return Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            );
                          },
                          placeholder: (context, url) {
                            return Shimmer.fromColors(
                              baseColor: Theme.of(context).hoverColor,
                              highlightColor: Theme.of(context).highlightColor,
                              enabled: true,
                              child: Container(),
                            );
                          },
                          errorWidget: (context, url, error) {
                            return Shimmer.fromColors(
                              baseColor: Theme.of(context).hoverColor,
                              highlightColor: Theme.of(context).highlightColor,
                              enabled: true,
                              child: Container(),
                            );
                          },
                        ),
                      );
                    }).toList(),
                    options: CarouselOptions(
                      pageViewKey: PageStorageKey("product_image"),
                      aspectRatio: 9/9,
                      initialPage: _index,
                      viewportFraction: 1.0,
                      enableInfiniteScroll: true,
                      autoPlay: false,
                      autoPlayInterval: Duration(seconds: 4),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.linearToEaseOut,
                      enlargeCenterPage: false,
                      onPageChanged: (index, reason) {
                        setState(() => _index = index);
                        _onChange(index);
                      },
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top:8)),
                  _buildIndicators(),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      widget.product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(color: Colors.white),
                    ),
                  ),
                  Text(
                    "${_index + 1}/${widget.product.images.length}",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(color: Colors.white),
                  )
                ],
              ),
            ),
            Container(
              height: 70,
              margin: EdgeInsets.only(bottom: 16),
              child: ListView.builder(
                controller: _listController,
                padding: EdgeInsets.only(right: 16),
                scrollDirection: Axis.horizontal,
                itemCount: widget.product.images.length,
                itemBuilder: (context, index) {
                  final item = widget.product.images[index];
                  return GestureDetector(
                    onTap: () {
                      _onSelectImage(index);
                    },
                    child: CachedNetworkImage(
                      imageUrl: item,
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          width: 70,
                          margin: EdgeInsets.only(left: 16),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 2.3,
                                color: index == _index
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).dividerColor),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                      placeholder: (context, url) {
                        return Shimmer.fromColors(
                          baseColor: Theme.of(context).hoverColor,
                          highlightColor: Theme.of(context).highlightColor,
                          enabled: true,
                          child: Container(
                            width: 70,
                            margin: EdgeInsets.only(left: 16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2.3,
                                  color: index == _index
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context).dividerColor),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
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
                            width: 70,
                            margin: EdgeInsets.only(left: 16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2.3,
                                  color: index == _index
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context).dividerColor),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            child: Icon(Icons.error),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
  _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...List.generate(widget.product.images.length, (index) {
          return _buildIndicatorNormal(index == _index);
        })
      ],
    );
  }

  _buildIndicatorNormal(bool isSelected) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      height: 10,
      width: isSelected ? 10 : 10,
      margin: EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        color: isSelected ? Theme.of(context).primaryColor : Color(0xffd9d5d5),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
