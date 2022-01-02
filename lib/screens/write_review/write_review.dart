import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/blocs/bloc.dart';
import 'package:ecommerce_app/blocs/feedbacks/bloc.dart';
import 'package:ecommerce_app/blocs/profile/bloc.dart';
import 'package:ecommerce_app/configs/config.dart';
import 'package:ecommerce_app/data/models/models.dart';
import 'package:ecommerce_app/utils/utils.dart';
import 'package:ecommerce_app/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class WriteReview extends StatefulWidget {
  final Product product;

  const WriteReview({Key? key, required this.product}) : super(key: key);

  @override
  _WriteReviewState createState() => _WriteReviewState();
}

class _WriteReviewState extends State<WriteReview> {
  Product get product => widget.product;

  final _textReview = TextEditingController();
  final _focusReview = FocusNode();

  String? _validReview;
  double _rate = 0;

  @override
  void initState() {
    _rate = double.parse(product.rating.toString());
    super.initState();
  }

  ///On send
  Future<void> _send() async {
    UtilOther.hiddenKeyboard(context);
    setState(() {
      _validReview = UtilValidator.validate(
        data: _textReview.text,
      );
    });
    if (_validReview == null && _rate != 0) {
      final state = AppBloc.profileBloc.state;
      if (state is ProfileLoaded) {
        final user = state.loggedUser;
        AppBloc.feedbackBloc.add(AddFeedback(
            content: _textReview.text,
            rating: _rate.toInt(),
            user: user
        ));
      }
    } else {
      _showMessage(Translate.of(context)!.translate('please_input_data'));
    }
  }

  ///On show message fail
  Future<void> _showMessage(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            Translate.of(context)!.translate('feedback'),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  message,
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyText1,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            AppButton(
              Translate.of(context)!.translate('close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
              type: ButtonType.text,
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<FeedbackBloc, FeedbackState>(
      listener: (context, state) {
        if (state is FeedbackSaveSuccess) {
          Navigator.pop(context);
        }
        if (state is FeedbackSaveFail) {
          _showMessage(Translate.of(context)!.translate(state.code));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            Translate.of(context)!.translate('feedback'),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                Translate.of(context)!.translate('send'),
                style: Theme.of(context)
                    .textTheme
                    .button!
                    .copyWith(color: Colors.white),
              ),
              onPressed: _send,
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: (AppBloc.profileBloc.state as ProfileLoaded).loggedUser.avatar,
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                      placeholder: (context, url) {
                        return Shimmer.fromColors(
                          baseColor: Theme.of(context).hoverColor,
                          highlightColor: Theme.of(context).highlightColor,
                          enabled: true,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      },
                      errorWidget: (context, url, error) {
                        return Shimmer.fromColors(
                          baseColor: Theme.of(context).hoverColor,
                          highlightColor: Theme.of(context).highlightColor,
                          enabled: true,
                          child: Container(
                            width: 60,
                            height: 60,
                            child: Icon(Icons.error),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: StarRating(
                    rating: _rate,
                    size: 24,
                    color: AppTheme.yellowColor,
                    borderColor: AppTheme.yellowColor,
                    allowHalfRating: false,
                    onRatingChanged: (value) {
                      setState(() {
                        _rate = value;
                      });
                    },
                  ),
                ),
                Text(
                  Translate.of(context)!.translate('tap_rate'),
                  style: Theme.of(context).textTheme.caption,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text(
                          Translate.of(context)!.translate('description'),
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      AppTextInputBlur(
                        hintText: Translate.of(context)!.translate(
                          'input_feedback',
                        ),
                        errorText:
                        Translate.of(context)!.translate(_validReview ?? ""),
                        focusNode: _focusReview,
                        maxLines: 5,
                        onTapIcon: () async {
                          _textReview.clear();
                        },
                        onSubmitted: (text) {
                          _send();
                        },
                        onChanged: (text) {
                          setState(() {
                            _validReview = UtilValidator.validate(
                              data: _textReview.text,
                            );
                          });
                        },
                        icon: Icon(Icons.clear),
                        controller: _textReview,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
