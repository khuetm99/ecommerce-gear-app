import 'package:ecommerce_app/blocs/feedbacks/bloc.dart';
import 'package:ecommerce_app/data/models/models.dart';
import 'package:equatable/equatable.dart';

abstract class FeedbackState extends Equatable {
  const FeedbackState();

  @override
  List<Object> get props => [];
}

/// Feedbacks loading
class FeedbacksLoading extends FeedbackState {}

/// Feedbacks was loaded
class FeedbacksLoaded extends FeedbackState {
  final List<FeedBackModel> feedbacks;
  final RateModel rateModel;

  FeedbacksLoaded(
      {required this.feedbacks,
      required this.rateModel});

  @override
  List<Object> get props => [feedbacks, rateModel];
}

/// Feedbacks wasn't loaded
class FeedbacksLoadFailure extends FeedbackState {
  final String error;

  FeedbacksLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}

class FeedbackSaving extends FeedbackState {}

class FeedbackSaveSuccess extends FeedbackState {}

class FeedbackSaveFail extends FeedbackState {
  final String code;
  FeedbackSaveFail({required this.code});
}

