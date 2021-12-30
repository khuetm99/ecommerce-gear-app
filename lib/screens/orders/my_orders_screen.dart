import 'package:ecommerce_app/blocs/order/bloc.dart';
import 'package:ecommerce_app/constants/image_constant.dart';
import 'package:ecommerce_app/data/models/models.dart';
import 'package:ecommerce_app/utils/utils.dart';
import 'package:ecommerce_app/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'order_card.dart';

class MyOrdersScreen extends StatefulWidget {
  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  int currentTabIndex = 0;

  @override
  void initState() {
    BlocProvider.of<OrderBloc>(context).add(LoadMyOrders());

    tabController = TabController(
      length: 2,
      vsync: this,
    );

    tabController.addListener(() {
      setState(() {
        currentTabIndex = tabController.index;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            Translate.of(context)!.translate("my_orders"),
          ),
          bottom: TabBar(
            controller: tabController,
            tabs: <Widget>[
              Tab(text: Translate.of(context)!.translate("be_delivering")),
              Tab(text: Translate.of(context)!.translate("delivered")),
            ],
            onTap: (index) {},
            labelStyle: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(fontSize: 18),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            unselectedLabelStyle: Theme.of(context).textTheme.subtitle1!.copyWith(),
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Theme.of(context).primaryColor,
            indicatorWeight: 3,
          ),
        ),
        body: SafeArea(child: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            if (state is MyOrdersLoading) {
              return Loading();
            }
            if (state is MyOrdersLoaded) {
              return Column(
                children: <Widget>[

                  SizedBox(height: 10),
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: <Widget>[
                        _buildListOrders(state.deliveringOrders),
                        _buildListOrders(state.deliveredOrders),
                      ],
                    ),
                  )
                ],
              );
            }
            if (state is MyOrdersLoadFailure) {
              return Center(child: Text("Load Failure"));
            }
            return Center(child: Text("Something went wrongs."));
          },
        )),
      ),
    );
  }

  _buildTabs() {
    return DefaultTabController(
      length: 2,
      child: TabBar(
        controller: tabController,
        tabs: <Widget>[
          Tab(text: Translate.of(context)!.translate("be_delivering")),
          Tab(text: Translate.of(context)!.translate("delivered")),
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

  _buildListOrders(List<OrderModel> orders) {
    return orders.isEmpty
        ? Center(
            child: Image.asset(IMAGE_CONST.NO_RECORD),
          )
        : ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return OrderModelCard(order: orders[index]);
            },
          );
  }
}
