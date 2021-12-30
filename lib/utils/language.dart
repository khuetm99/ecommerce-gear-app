import 'package:ecommerce_app/configs/config.dart';

class UtilLanguage {
  ///Get Language Global Language Name
  static String getGlobalLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'vi':
        return 'Vietnamese';
      default:
        return 'Unknown';
    }
  }

  static bool isRTL() {
    switch (AppLanguage.defaultLanguage.languageCode) {
      case "ar":
      case "he":
      case "ckb":
        return true;
      default:
        return false;
    }
  }

  ///Singleton factory
  static final UtilLanguage _instance = UtilLanguage._internal();

  factory UtilLanguage() {
    return _instance;
  }

  UtilLanguage._internal();
}
