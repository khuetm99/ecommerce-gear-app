import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/data/models/discount_model.dart';
import 'package:ecommerce_app/data/repository/discount_repository/firebase_discount_repo.dart';
import 'package:equatable/equatable.dart';

part 'discount_event.dart';
part 'discount_state.dart';

class DiscountBloc extends Bloc<DiscountEvent, DiscountState> {
  final discountRepository = FirebaseDiscountRepo();
  DiscountBloc() : super(DiscountLoading());

  @override
  Stream<DiscountState> mapEventToState(DiscountEvent event) async*{
    if (event is LoadDiscount) {
      yield* _mapLoadDiscountToState(event);
    } if (event is ChooseDiscount) {
      yield* _mapChooseDiscountToState(event);
    }
  }

  Stream<DiscountState> _mapLoadDiscountToState(LoadDiscount event) async* {
    try {
      final List<DiscountModel>? discounts = await discountRepository.fetchDiscount();
      yield DiscountLoaded(discounts: discounts!);
    }  catch (e) {
      print(e.toString());
    }
  }

  Stream<DiscountState> _mapChooseDiscountToState(ChooseDiscount event) async* {
      yield DiscountChoosed(discountModel: event.discount);
  }
}
