import 'package:ecommerce_app/bottom_navigation.dart';
import 'package:ecommerce_app/data/models/models.dart';
import 'package:ecommerce_app/screens/cart/cart_screen.dart';
import 'package:ecommerce_app/screens/categories/categories_screen.dart';
import 'package:ecommerce_app/screens/delivery_address/delivery_address_screen.dart';
import 'package:ecommerce_app/screens/edit_profile/edit_profile.dart';
import 'package:ecommerce_app/screens/feedbacks/feedbacks_screen.dart';
import 'package:ecommerce_app/screens/message/message_screen.dart';
import 'package:ecommerce_app/screens/orders/detail_order_screen.dart';
import 'package:ecommerce_app/screens/orders/my_orders_screen.dart';
import 'package:ecommerce_app/screens/photo_preview/gallery.dart';
import 'package:ecommerce_app/screens/photo_preview/photo_preview.dart';
import 'package:ecommerce_app/screens/product_detail/product_detail.dart';
import 'package:ecommerce_app/screens/register/signup.dart';
import 'package:ecommerce_app/screens/screen.dart';
import 'package:ecommerce_app/screens/login/login.dart';
import 'package:ecommerce_app/screens/search/search_screen.dart';
import 'package:ecommerce_app/screens/splash/splash_screen.dart';
import 'package:ecommerce_app/screens/wishlist/witchlist.dart';
import 'package:ecommerce_app/screens/write_review/write_review.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String home = "/home";
  static const String signIn = "/signIn";
  static const String signUp = "/signUp";
  static const String account = "/account";
  static const String splash = "/splash";
  static const String forgotPassword = "/forgotPassword";
  static const String editProfile = "/editProfile";
  static const String changeLanguage = "/changeLanguage";
  static const String themeSetting = "/themeSetting";
  static const String setting = "/setting";
  static const String fontSetting = "/fontSetting";

  static const String notification = "/notification";
  static const String portfolio = "/portfolio";
  static const String listProduct = "/listProduct";
  static const String productDetail = "/productDetail";
  static const String bestSale = "/bestSale";
  static const String device = "/device";
  static const String about = "/about";
  static const String webView = "/webView";
  static const String invoiceCheck = "/invoiceCheck";
  static const String search = "/search";
  static const String cart = "/cart";
  static const String deliveryAddress = "/deliveryAddress";
  static const String photoPreview = "/photoPreview";
  static const String gallery = "/gallery";
  static const String myOrders = "/myOrders";
  static const String orderDetail = "/orderDetail";
  static const String categories = "/categories";
  static const String feedbacks = "/feedbacks";
  static const String writeReview = "/writeReview";
  static const String message = "/message";
  static const String wishList = "/witchList";

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case signIn:
        return MaterialPageRoute(
            builder: (_) => Login(
                  from: settings.arguments,
                ),
            fullscreenDialog: true);

      case signUp:
        return MaterialPageRoute(
          builder: (context) {
            return SignUp();
          },
        );

      case changeLanguage:
        return MaterialPageRoute(
          builder: (context) {
            return LanguageSetting();
          },
        );
      case themeSetting:
        return MaterialPageRoute(
          builder: (context) {
            return ThemeSetting();
          },
        );
      case setting:
        return MaterialPageRoute(
          builder: (context) {
            return Setting();
          },
        );
      case fontSetting:
        return MaterialPageRoute(
          builder: (context) {
            return FontSetting();
          },
        );

      case splash:
        return MaterialPageRoute(
          builder: (context) {
            return SplashScreen();
          },
        );

      case home:
        return MaterialPageRoute(
          builder: (_) => BottomNavigation(),
        );

      case productDetail:
        return MaterialPageRoute(
          builder: (_) => ProductDetail(
            id: settings.arguments as String,
          ),
        );

      case cart:
        return MaterialPageRoute(
          builder: (_) => CartScreen(),
        );

      case deliveryAddress:
        return MaterialPageRoute(
          builder: (_) => DeliveryAddressModelScreen(),
        );

      case gallery:
        final Map<String, dynamic> params =
            settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => Gallery(
            product: params['products'],
            index: params['index'],
          ),
        );

      case photoPreview:
        final Map<String, dynamic> params =
            settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => PhotoPreview(
            galleryList: params['galleries'],
            initialIndex: params['index'],
          ),
          fullscreenDialog: true,
        );

      case myOrders:
        return MaterialPageRoute(
          builder: (context) => MyOrdersScreen(),
        );

      case orderDetail:
        final Map<String, dynamic> params =
            settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => DetailOrderScreen(
            order: params["order"],
            afterCheckout: params["afterCheckout"],
          ),
        );

      case categories:
        final CategoryModel category = settings.arguments as CategoryModel;
        return MaterialPageRoute(
          builder: (context) => CategoriesScreen(category: category),
        );

      case feedbacks:
        final Product product = settings.arguments as Product;
        return MaterialPageRoute(
          builder: (context) => FeedbacksScreen(product: product),
        );

      case writeReview:
        final Product product = settings.arguments as Product;
        return MaterialPageRoute(
          builder: (context) => WriteReview(product: product),
        );

      case search:
        return MaterialPageRoute(
          builder: (context) => SearchScreen(),
        );

      case editProfile:
        final UserModel user = settings.arguments as UserModel;
        return MaterialPageRoute(
          builder: (context) => EditProfile(user: user),
        );

      case message:
        return MaterialPageRoute(
          builder: (context) => MessageScreen(),
        );


      case wishList:
        return MaterialPageRoute(
          builder: (context) => WishList(),
        );



      default:
        return MaterialPageRoute(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Not Found"),
              ),
              body: Center(
                child: Text('No path for ${settings.name}'),
              ),
            );
          },
        );
    }
  }

  ///Singleton factory
  static final Routes _instance = Routes._internal();

  factory Routes() {
    return _instance;
  }

  Routes._internal();
}
