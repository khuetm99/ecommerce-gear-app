import 'package:ecommerce_app/blocs/categories/bloc.dart';
import 'package:ecommerce_app/configs/config.dart';
import 'package:ecommerce_app/constants/image_constant.dart';
import 'package:ecommerce_app/data/models/models.dart';
import 'package:ecommerce_app/screens/categories/toolbar.dart';
import 'package:ecommerce_app/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesScreen extends StatefulWidget {
  final CategoryModel category;

  const CategoriesScreen({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  int currentTabIndex = 0;
  ProductViewType _modeView = ProductViewType.grid;

  @override
  void initState() {
    tabController = TabController(
      length: 3,
      vsync: this,
    );

    tabController.addListener(() {
      setState(() {
        currentTabIndex = tabController.index;
      });
    });

    super.initState();
  }

  ///On navigate product detail
  void _onProductDetail(Product item) {
    Navigator.pushNamed(context, Routes.productDetail, arguments: item.id);
  }

  ///On Change View
  void _onChangeView() {
    switch (_modeView) {
      case ProductViewType.grid:
        _modeView = ProductViewType.list;
        break;
      case ProductViewType.list:
        _modeView = ProductViewType.grid;
        break;
      default:
        return;
    }
    setState(() {
      _modeView = _modeView;
    });
  }

  ///Export Icon for Mode View
  IconData _exportIconView() {
    ///Icon for ListView Mode
    switch (_modeView) {
      case ProductViewType.list:
        return Icons.view_list;
      case ProductViewType.grid:
        return Icons.view_quilt;
      default:
        return Icons.help;
    }
  }

  ///_build Item Loading
  Widget _buildItemLoading(ProductViewType type) {
    switch (type) {
      case ProductViewType.grid:
        return AppProductItem(
          type: _modeView,
        );

      case ProductViewType.list:
        return Container(
          padding: EdgeInsets.only(left: 8),
          child: AppProductItem(
            type: _modeView,
          ),
        );

      default:
        return AppProductItem(
          type: _modeView,
        );
    }
  }

  ///_build Item
  Widget _buildItem(Product item, ProductViewType type) {
    switch (type) {
      case ProductViewType.grid:
        return AppProductItem(
          onPressed: _onProductDetail,
          product: item,
          type: _modeView,
        );

      case ProductViewType.list:
        return Container(
          padding: EdgeInsets.only(left: 15),
          child: AppProductItem(
            onPressed: _onProductDetail,
            product: item,
            type: _modeView,
          ),
        );

      default:
        return AppProductItem(
          onPressed: _onProductDetail,
          product: item,
          type: _modeView,
        );
    }
  }

  Widget _buildListProduct({required List<Product> products}) {
    if (products.isEmpty) {
      return Center(
        child: Image.asset(
          IMAGE_CONST.NOT_FOUND,
          width: 180,
          height: 180,
        ),
      );
    }
    if (_modeView == ProductViewType.grid) {
      return GridView.builder(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 14 / 20,
          mainAxisSpacing: 8,
          crossAxisSpacing: 0,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildItem(
              products[index],
              _modeView,
            ),
          );
        },
      );
    }
    return ListView.builder(
      padding: EdgeInsets.all(0),
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: _buildItem(
              products[index],
              _modeView,
            ));
      },
      itemCount: products.length > 8 ? 8 : products.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CategoriesBloc>(
      create: (context) => CategoriesBloc()..add(OpenScreen(widget.category)),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              ToolBarWidget(
                currCategoryModel: widget.category,
                middleIconButton: IconButton(
                    onPressed: _onChangeView, icon: Icon(_exportIconView())),
              ),
              Expanded(
                  child: BlocBuilder<CategoriesBloc, CategoriesState>(
                buildWhen: (preState, currState) =>
                    currState is DisplayListProducts,
                builder: (context, state) {
                  if (state is DisplayListProducts) {
                    if (state.loading) {
                      return Loading();
                    }
                    if (state.msg.isNotEmpty) {
                      return Center(child: Text(state.msg));
                    }
                    if (state.priceSegment != null) {
                      var priceSegment = state.priceSegment!;
                      return Column(
                        children: <Widget>[
                          _buildTabs(),
                          SizedBox(height: 8),
                          Expanded(
                            child: TabBarView(
                              controller: tabController,
                              children: <Widget>[
                                _buildListProduct(
                                    products: priceSegment.productsInLowRange),
                                _buildListProduct(
                                    products: priceSegment.productsInMidRange),
                                _buildListProduct(
                                    products: priceSegment.productsInHighRange)
                              ],
                            ),
                          )
                        ],
                      );
                    }
                    return Center(child: Text("Something went wrong."));
                  } else {
                    return Center(child: Text("Something went wrong."));
                  }
                },
              )),
            ],
          ),
        ),
      ),
    );
  }

  _buildTabs() {
    return DefaultTabController(
      length: 3,
      child: TabBar(
        controller: tabController,
        tabs: <Widget>[
          Tab(text: '< 1 triệu đồng'),
          Tab(text: ' 1 - 4 triệu đồng'),
          Tab(text: '> 4 triệu đồng'),
        ],
        onTap: (index) {},
        labelStyle: Theme.of(context)
            .textTheme
            .subtitle1!
            .copyWith(fontWeight: FontWeight.bold),
        labelColor: Theme.of(context).colorScheme.onSurface,
        unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
        unselectedLabelStyle: Theme.of(context).textTheme.subtitle1,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: Theme.of(context).primaryColor,
        indicatorWeight: 2,
      ),
    );
  }
}
