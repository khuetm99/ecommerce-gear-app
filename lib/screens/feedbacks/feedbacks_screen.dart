import 'package:ecommerce_app/blocs/app_bloc.dart';
import 'package:ecommerce_app/blocs/authentication/bloc.dart';
import 'package:ecommerce_app/blocs/feedbacks/bloc.dart';
import 'package:ecommerce_app/configs/config.dart';
import 'package:ecommerce_app/data/models/models.dart';
import 'package:ecommerce_app/utils/translate.dart';
import 'package:ecommerce_app/widgets/app_button.dart';
import 'package:ecommerce_app/widgets/app_comment_item.dart';
import 'package:ecommerce_app/widgets/app_rating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedbacksScreen extends StatefulWidget {
  final Product product;

  const FeedbacksScreen({Key? key, required this.product}) : super(key: key);

  @override
  _FeedbacksScreenState createState() => _FeedbacksScreenState();
}

class _FeedbacksScreenState extends State<FeedbacksScreen> {
  Product get product => widget.product;

  @override
  void initState() {
    AppBloc.feedbackBloc.add(LoadFeedbacks(product));
    super.initState();
  }

  ///On refresh
  Future<void> _onRefresh() async {
    AppBloc.feedbackBloc.add(LoadFeedbacks(product));
  }

  ///On navigate write review
  void _onWriteReview() async {
    final authState = AppBloc.authBloc.state;
    if (authState is Unauthenticated) {
      final result = await Navigator.pushNamed(
        context,
        Routes.signIn,
        arguments: Routes.writeReview,
      );
      if (result != Routes.writeReview) {
        return;
      }
    }
    Navigator.pushNamed(context, Routes.writeReview, arguments: product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Translate.of(context)!.translate("feedback")),
        actions: <Widget>[
          TextButton(
            child: Text(
              Translate.of(context)!.translate('write'),
              style: Theme.of(context)
                  .textTheme
                  .button!
                  .copyWith(color: Colors.white),
            ),
            onPressed: _onWriteReview,
          )
        ],
      ),
      body: BlocListener<FeedbackBloc, FeedbackState>(
        listener: (context, state) {
          if (state is FeedbackSaveFail || state is FeedbackSaveSuccess) {
            AppBloc.feedbackBloc.add(LoadFeedbacks(product));
          }
        },
        child: BlocBuilder<FeedbackBloc, FeedbackState>(
          builder: (context, state) {
            RateModel? rate;

            ///Loading
            Widget listComment = ListView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
              ),
              children: List.generate(8, (index) => index).map(
                (item) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: AppCommentItem(),
                  );
                },
              ).toList(),
            );

            ///Success
            if (state is FeedbacksLoaded) {
              rate = state.rateModel;

              ///Empty
              if (state.feedbacks.isEmpty) {
                listComment = Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.sentiment_satisfied),
                      Padding(
                        padding: EdgeInsets.all(4),
                        child: Text(
                          Translate.of(context)!.translate('review_not_found'),
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                listComment = ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                  ),
                  itemCount: state.feedbacks.length,
                  itemBuilder: (context, index) {
                    final item = state.feedbacks[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: AppCommentItem(item: item),
                    );
                  },
                );
              }
            }

            return Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(16),
                  child: rate != null
                      ? AppRating(
                          one: rate.one,
                          two: rate.two,
                          three: rate.three,
                          four: rate.four,
                          five: rate.five,
                          avg: rate.avg,
                          total: rate.numberOfFeedbacks,
                        )
                      : Container(),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: listComment,
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
