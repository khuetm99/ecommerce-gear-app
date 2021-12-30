import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/blocs/feedbacks/bloc.dart';
import 'package:ecommerce_app/data/models/models.dart';
import 'package:ecommerce_app/data/repository/repository.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class FeedbackBloc extends Bloc<FeedbacksEvent, FeedbackState> {
  final _authRepository = FirebaseAuthRepository();
  final _feedbackRepository = FirebaseFeedbackRepository();
  final _productRepository = FirebaseProductRepository();

  late Product _currentProduct;
  double _currAverageRating = 0.0;
  StreamSubscription? _feedbackSubscription;

  List<FeedBackModel> allFeedbacks = [];

  FeedbackBloc() : super(FeedbacksLoading());

  @override
  Stream<FeedbackState> mapEventToState(FeedbacksEvent event) async* {
    if (event is LoadFeedbacks) {
      yield* _mapLoadFeedbacksToState(event);
    } else if (event is AddFeedback) {
      yield* _mapAddFeedbackToState(event);
    } else if (event is StarChanged) {
      yield* _mapStarChangedToState(event);
    } else if (event is FeedbacksUpdated) {
      yield* _mapFeedbacksUpdatedToState(event);
    }
  }

  Stream<FeedbackState> _mapLoadFeedbacksToState(LoadFeedbacks event) async* {
    try {
      _currentProduct = event.product;
      _feedbackSubscription?.cancel();
      _feedbackSubscription = _feedbackRepository
          .fetchFeedbacks(_currentProduct.id)!
          .listen((feedback) {
        add(FeedbacksUpdated(feedback));
      });
    } catch (e) {
      yield FeedbacksLoadFailure(e.toString());
    }
  }

  Stream<FeedbackState> _mapAddFeedbackToState(AddFeedback event) async* {
    yield FeedbackSaving();
    try {
      var newFeedback = FeedBackModel(
        id: Uuid().v1(),
        content: event.content,
        rating: event.rating,
        userId: event.user.id,
        userName: event.user.name,
        userAvatar: event.user.avatar,
        timestamp: Timestamp.now(),
      );
      await _feedbackRepository.addNewFeedback(
        _currentProduct.id,
        newFeedback,
      );
      yield FeedbackSaveSuccess();
    } catch (e) {
      yield FeedbackSaveFail(code: e.toString());
    }
  }

  Stream<FeedbackState> _mapStarChangedToState(StarChanged event) async* {
    try {
      yield FeedbacksLoading();
      var feedbacks = await _feedbackRepository.getFeedbacksByStar(
        _currentProduct.id,
        event.star,
      );
      // yield FeedbacksLoaded(
      //   feedbacks,
      //   _currAverageRating,
      //   feedbacks.length,
      // );
    } catch (e) {
      print(e);
    }
  }

  Stream<FeedbackState> _mapFeedbacksUpdatedToState(
    FeedbacksUpdated event,
  ) async* {
    yield FeedbacksLoading();
    // Calculate again average product rating
    double totalRating = 0;
    List<FeedBackModel> one = [];
    List<FeedBackModel> two = [];
    List<FeedBackModel> three = [];
    List<FeedBackModel> four = [];
    List<FeedBackModel> five = [];

    var feedbacks = event.feedbacks;
    feedbacks.forEach((f) => totalRating += f.rating);

    double averageRating =
        feedbacks.length > 0 ? totalRating / feedbacks.length : 0.0;
    _currAverageRating = double.parse(averageRating.toStringAsFixed(1));

    feedbacks.forEach((item) {
      if (item.rating == 5) {
        five.add(item);
      } else if (item.rating == 4) {
        four.add(item);
      } else if (item.rating == 3) {
        three.add(item);
      } else if (item.rating == 2) {
        two.add(item);
      } else if (item.rating == 1) {
        one.add(item);
      }
    });

    double fiveStar =
        feedbacks.length != 0 ? five.length / feedbacks.length : 0;
    double fourStar =
        feedbacks.length != 0 ? four.length / feedbacks.length : 0;
    double threeStar =
        feedbacks.length != 0 ? three.length / feedbacks.length : 0;
    double twoStar = feedbacks.length != 0 ? two.length / feedbacks.length : 0;
    double oneStar = feedbacks.length != 0 ? one.length / feedbacks.length : 0;

    //Update product rating
    await _productRepository.updateProductRatingById(
      _currentProduct.id,
      _currAverageRating,
    );

    RateModel rateModel = RateModel(
      one: oneStar,
      two: twoStar,
      three: threeStar,
      four: fourStar,
      five: fiveStar,
      numberOfFeedbacks: feedbacks.length,
      avg: _currAverageRating,
    );

    yield FeedbacksLoaded(
      feedbacks: feedbacks,
      rateModel: rateModel,
    );
  }

  @override
  Future<void> close() {
    _feedbackSubscription?.cancel();
    return super.close();
  }
}

class FeedbackModelsByStar {
  final List<FeedBackModel> one;
  final List<FeedBackModel> two;
  final List<FeedBackModel> three;
  final List<FeedBackModel> four;
  final List<FeedBackModel> five;

  FeedbackModelsByStar(
      {required this.one,
      required this.two,
      required this.three,
      required this.four,
      required this.five});
}

class RateModel {
  final double one;
  final double two;
  final double three;
  final double four;
  final double five;
  final double avg;
  final int numberOfFeedbacks;

  RateModel({
    required this.one,
    required this.two,
    required this.three,
    required this.four,
    required this.five,
    required this.avg,
    required this.numberOfFeedbacks,
  });
}
