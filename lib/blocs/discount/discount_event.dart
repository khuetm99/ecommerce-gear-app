part of 'discount_bloc.dart';

abstract class DiscountEvent extends Equatable {
  const DiscountEvent();
  @override
  List<Object?> get props => [];
}

class LoadDiscount extends DiscountEvent{}

class ChooseDiscount extends DiscountEvent{
  final DiscountModel discount;

  ChooseDiscount({required this.discount});

  @override
  List<Object?> get props => [discount];
}