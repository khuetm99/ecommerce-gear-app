class Images {
  static const String APP_LOGO = "assets/images/ic_launcher.png";
  static const String CART_EMPTY = "assets/images/empty_cart.png";
  static const String NOT_FOUND = "assets/images/Not Found.png";
  static const String NO_RECORD = "assets/images/no_record.png";
  static const String SUCCESS = "assets/images/success.png";
  static const String DEFAULT_AVATAR = "assets/images/default_avatar.jpg";
  static const String ADD_ADDRESS = "assets/images/add_address.jpg";

  static const String Intro1 = "assets/images/intro_1.png";
  static const String Intro2 = "assets/images/intro_2.png";
  static const String Intro3 = "assets/images/intro_3.png";
  static const String Logo = "assets/images/logo.png";
  static const String Slide = "assets/images/slide.png";

  ///Singleton factory
  static final Images _instance = Images._internal();

  factory Images() {
    return _instance;
  }

  Images._internal();
}
