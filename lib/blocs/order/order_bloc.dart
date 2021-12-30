import 'package:ecommerce_app/blocs/order/bloc.dart';
import 'package:ecommerce_app/data/models/models.dart';
import 'package:ecommerce_app/data/repository/auth_repository/firebase_auth_repo.dart';
import 'package:ecommerce_app/data/repository/order_repository/firebase_order_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final _orderRepository = FirebaseOrderRepository();
  final _authRepository = FirebaseAuthRepository();
  OrderBloc() : super(MyOrdersLoading());

  @override
  Stream<OrderState> mapEventToState(OrderEvent event) async* {
    if (event is LoadMyOrders) {
      yield* _mapLoadMyOrdersToState(event);
    } else if (event is AddOrder) {
      yield* _mapAddOrderToState(event);
    } else if (event is RemoveOrder) {
      yield* _mapRemoveOrderToState(event);
    }
  }

  Stream<OrderState> _mapLoadMyOrdersToState(
      LoadMyOrders event) async* {
    try {
      var loggedFirebaseUser = _authRepository.loggedFirebaseUser;
      List<OrderModel> orders =
          await _orderRepository.fetchOrders(loggedFirebaseUser.uid);

      // Classify orders
      List<OrderModel> deliveringOrders = [];
      List<OrderModel> deliveredOrders = [];

      orders.forEach((order) {
        if (order.isDelivering) {
          deliveringOrders.add(order);
        } else {
          deliveredOrders.add(order);
        }
      });
      yield MyOrdersLoaded(
        deliveringOrders: deliveringOrders,
        deliveredOrders: deliveredOrders,
      );
    } catch (e) {
      yield MyOrdersLoadFailure(e.toString());
    }
  }

  Stream<OrderState> _mapAddOrderToState(AddOrder event) async* {
    try {
      var newOrderModel = event.newOrderModel
          .cloneWith(uid: _authRepository.loggedFirebaseUser.uid);
      await _orderRepository.addOrderModel(newOrderModel);
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<OrderState> _mapRemoveOrderToState(
      RemoveOrder event) async* {
    try {
      await _orderRepository.removeOrderModel(event.order);
      add(LoadMyOrders());
    } catch (e) {
      print(e.toString());
    }
  }
}
