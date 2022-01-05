import 'package:ecommerce_app/blocs/authentication/authentication_bloc.dart';
import 'package:ecommerce_app/blocs/cart/bloc.dart';
import 'package:ecommerce_app/blocs/discount/discount_bloc.dart';
import 'package:ecommerce_app/blocs/favorites/bloc.dart';
import 'package:ecommerce_app/blocs/feedbacks/bloc.dart';
import 'package:ecommerce_app/blocs/login/bloc.dart';
import 'package:ecommerce_app/blocs/order/bloc.dart';
import 'package:ecommerce_app/blocs/profile/bloc.dart';
import 'package:ecommerce_app/blocs/register/bloc.dart';
import 'package:ecommerce_app/blocs/related_products/bloc.dart';
import 'package:ecommerce_app/blocs/search/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc.dart';

class AppBloc {
  static final applicationBloc = ApplicationBloc();
  static final authBloc = AuthenticationBloc();
  static final loginBloc = LoginBloc();
  static final registerBloc = RegisterBloc();
  static final cartBloc = CartBloc();
  static final searchBloc = SearchBloc();
  static final feedbackBloc = FeedbackBloc();
  static final favoriteBloc = FavoriteBloc();
  static final orderBloc = OrderBloc();
  static final discountBloc = DiscountBloc();
  static final profileBloc = ProfileBloc();
  static final languageBloc = LanguageBloc();
  static final themeBloc = ThemeBloc();

  static final List<BlocProvider> providers = [
    BlocProvider<ApplicationBloc>(
      create: (context) => applicationBloc,
    ),
    BlocProvider<AuthenticationBloc>(
      create: (context) => authBloc,
    ),
    BlocProvider<LoginBloc>(
      create: (context) => loginBloc,
    ),
    BlocProvider<RegisterBloc>(
      create: (context) => registerBloc,
    ),
    BlocProvider<CartBloc>(
      create: (context) => cartBloc,
    ),
    BlocProvider<OrderBloc>(
      create: (context) => orderBloc,
    ),
    BlocProvider<SearchBloc>(
      create: (context) => searchBloc,
    ),
    BlocProvider<FeedbackBloc>(
      create: (context) => feedbackBloc,
    ),
    BlocProvider<FavoriteBloc>(
      create: (context) => favoriteBloc,
    ),
    BlocProvider<ProfileBloc>(
      create: (context) => profileBloc,
    ),
    BlocProvider<DiscountBloc>(
      create: (context) => discountBloc,
    ),
    BlocProvider<LanguageBloc>(
      create: (context) => languageBloc,
    ),
    BlocProvider<ThemeBloc>(
      create: (context) => themeBloc,
    ),
  ];

  static void dispose() {
    applicationBloc.close();
    authBloc.close();
    loginBloc.close();
    registerBloc.close();
    cartBloc.close();
    orderBloc.close();
    searchBloc.close();
    feedbackBloc.close();
    favoriteBloc.close();
    profileBloc.close();
    discountBloc.close();
    languageBloc.close();
    themeBloc.close();
  }

  ///Singleton factory
  static final AppBloc _instance = AppBloc._internal();

  factory AppBloc() {
    return _instance;
  }

  AppBloc._internal();
}
