import 'package:ecommerce_app/blocs/app_bloc.dart';
import 'package:ecommerce_app/blocs/authentication/bloc.dart';
import 'package:ecommerce_app/blocs/feedbacks/bloc.dart';
import 'package:ecommerce_app/blocs/home/bloc.dart';
import 'package:ecommerce_app/configs/routes.dart';
import 'package:ecommerce_app/data/models/models.dart';
import 'package:ecommerce_app/screens/home/widgets/home_banner.dart';
import 'package:ecommerce_app/screens/home/widgets/home_category_item.dart';
import 'package:ecommerce_app/utils/utils.dart';
import 'package:ecommerce_app/widgets/app_product_item.dart';
import 'package:ecommerce_app/widgets/promo_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/home_header.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ///On navigate product detail
  void onProductDetail(Product item) {
    Navigator.pushNamed(context, Routes.productDetail, arguments: item.id);
  }

  ///On navigate category screen
  void onCategory(CategoryModel category) {
    Navigator.pushNamed(context, Routes.categories, arguments: category);
  }

  ///build Categories
  Widget _buildCategory(List<CategoryModel>? categories) {
    if (categories == null) {
      return GridView.builder(
          itemCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            childAspectRatio: 931 / 485,
          ),
          itemBuilder: (context, index) {
            return HomeCategoryItem();
          });
    }

    return GridView.builder(
        itemCount: categories.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          childAspectRatio: 931 / 485,
        ),
        itemBuilder: (context, index) {
          return HomeCategoryItem(
            category: categories[index],
            onPressed: () {
              onCategory(categories[index]);
            },
          );
        });
  }

  ///build Discount Product
  Widget _buildDiscountProduct(List<Product>? discountProduct) {
    if (discountProduct == null) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...List.generate(
              8,
              (index) => Padding(
                padding: const EdgeInsets.only(
                    left: 5.0, top: 15, right: 8, bottom: 5),
                child: AppProductItem(
                  type: ProductViewType.grid,
                ),
              ),
            )
          ]);
    }

    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...List.generate(
            discountProduct.length,
            (index) => Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, top: 15, right: 8, bottom: 5),
              child: AppProductItem(
                onPressed: (item) {
                  onProductDetail(item);
                },
                product: discountProduct[index],
                type: ProductViewType.grid,
              ),
            ),
          )
        ]);
  }

  ///build Popular Product
  Widget _buildPopularProduct(List<Product>? discountProduct) {
    if (discountProduct == null) {
      return ListView.builder(
        padding: EdgeInsets.all(0),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(left: 5, bottom: 16),
            child: AppProductItem(type: ProductViewType.list),
          );
        },
        itemCount: 8,
      );
    }
    return ListView.builder(
      padding: EdgeInsets.all(0),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(left: 5, bottom: 16),
          child: AppProductItem(
              onPressed: (item) {
                onProductDetail(item);
              },
              product: discountProduct[index],
              type: ProductViewType.list),
        );
      },
      itemCount: discountProduct.length > 8 ? 8 : discountProduct.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(LoadHome()),
      child: Builder(
        builder: (context) {
          return BlocListener<FeedbackBloc, FeedbackState>(
            listener: (context, state) {
              if (state is FeedbackSaveSuccess) {
                BlocProvider.of<HomeBloc>(context).add(RefreshHome());
              }
            },
            child: Scaffold(
              body: SafeArea(
                child: CustomScrollView(
                  physics: AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  slivers: [
                    SliverPersistentHeader(
                      delegate: HomePersistentHeader(),
                      pinned: true,
                    ),
                    CupertinoSliverRefreshControl(onRefresh: () async {
                      BlocProvider.of<HomeBloc>(context).add(RefreshHome());
                    }),
                    SliverToBoxAdapter(
                      child: BlocBuilder<HomeBloc, HomeState>(
                        builder: (context, state) {
                          List<BannerModel>? banners;
                          List<CategoryModel>? categories;
                          List<Product>? discountProducts;
                          List<Product>? popularProducts;

                          if (state is HomeLoaded) {
                            banners = state.homeResponse.banners;
                            categories = state.homeResponse.categories;
                            discountProducts =
                                state.homeResponse.discountProducts;
                            popularProducts =
                                state.homeResponse.popularProducts;
                          }

                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                HomeBanner(
                                  banners: banners,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 16.0,
                                    left: 16,
                                    right: 16,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        Translate.of(context)!.translate(
                                          'product_categories',
                                        ),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .copyWith(
                                                fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 10.0,
                                    left: 16,
                                    right: 16,
                                  ),
                                  child: _buildCategory(categories),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: PromoWidget(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        Translate.of(context)!.translate(
                                          'discount_products',
                                        ),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .copyWith(
                                                fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                SingleChildScrollView(
                                    physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    child: _buildDiscountProduct(
                                        discountProducts)),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 18.0, left: 8, bottom: 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        Translate.of(context)!.translate(
                                          'popular_products',
                                        ),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .copyWith(
                                                fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                _buildPopularProduct(popularProducts)
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
