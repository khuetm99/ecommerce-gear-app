import 'package:ecommerce_app/blocs/related_products/bloc.dart';
import 'package:ecommerce_app/configs/config.dart';
import 'package:ecommerce_app/data/models/models.dart';
import 'package:ecommerce_app/utils/utils.dart';
import 'package:ecommerce_app/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RelatedProducts extends StatefulWidget {
  final Product product;

  const RelatedProducts({Key? key, required this.product}) : super(key: key);

  @override
  State<RelatedProducts> createState() => _RelatedProductsState();
}

class _RelatedProductsState extends State<RelatedProducts> {
  ///On navigate product detail
  void onProductDetail(Product item) {
    Navigator.pushNamed(context, Routes.productDetail, arguments: item.id);
  }

  void _onSeeAll(BuildContext context) {
    BlocProvider.of<RelatedProductsBloc>(context)
        .add(OnSeeAll(widget.product.categoryId));
  }

  Widget _buildRelatedProduct(List<Product>? relatedProduct) {
    if (relatedProduct == null) {
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
            relatedProduct.length,
            (index) => Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, top: 15, right: 8, bottom: 5),
              child: AppProductItem(
                onPressed: (item) {
                  onProductDetail(item);
                },
                product: relatedProduct[index],
                type: ProductViewType.grid,
              ),
            ),
          )
        ]);
  }

  @override
  void initState() {
   
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RelatedProductsBloc>(
  create: (context) =>  RelatedProductsBloc()..add(LoadRelatedProducts(widget.product)),
  child: BlocConsumer<RelatedProductsBloc, RelatedProductsState>(
        listener: (context, state) {
          if (state is GoToCategoriesScreen) {
            Navigator.pushNamed(
              context,
              Routes.categories,
              arguments: state.category,
            );
          }
        },
        buildWhen: (preState, currState) => currState is! GoToCategoriesScreen,
        builder: (context, state) {
          List<Product>? relatedProducts;

          if (state is RelatedProductsLoaded) {
            relatedProducts = state.relatedProducts;
          }

          return Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      Translate.of(context)!.translate(
                        'related_products',
                      ),
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        _onSeeAll(context);
                      },
                      child: Text(
                        Translate.of(context)!.translate(
                          'see_all',
                        ),
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: _buildRelatedProduct(relatedProducts)),
            ],
          );
        }),
);
  }
}
