part of 'discount_bloc.dart';

abstract class DiscountState extends Equatable {
  const DiscountState();
  @override
  List<Object> get props => [];
}

class DiscountLoading extends DiscountState {}

class DiscountLoaded extends DiscountState {
  final List<DiscountModel> discounts;

  DiscountLoaded({required this.discounts});

  @override
  List<Object> get props => [discounts];
}

class DiscountChoosed extends DiscountState{
  final DiscountModel discountModel;

  DiscountChoosed({required this.discountModel});

  @override
  List<Object> get props => [discountModel];
}