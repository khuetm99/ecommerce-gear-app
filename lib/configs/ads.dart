import 'dart:io';

class Ads {
  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-1252546194513729~9841683117";
    } else if (Platform.isIOS) {
      return "ca-app-pub-1252546194513729~5387750016";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-1252546194513729/2893448618";
    } else if (Platform.isIOS) {
      return "ca-app-pub-1252546194513729/2701876926";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-1252546194513729/6576708600";
    } else if (Platform.isIOS) {
      return "ca-app-pub-1252546194513729/7762631914";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}

// class Ads {
//   static String get appId {
//     if (Platform.isAndroid) {
//       return "ca-app-pub-8318136058462894~6986590261";
//     } else if (Platform.isIOS) {
//       return "ca-app-pub-8318136058462894~7546839370";
//     } else {
//       throw new UnsupportedError("Unsupported platform");
//     }
//   }
//
//   static String get bannerAdUnitId {
//     if (Platform.isAndroid) {
//       return "ca-app-pub-8318136058462894/5673508594";
//     } else if (Platform.isIOS) {
//       return "ca-app-pub-8318136058462894/6233757705";
//     } else {
//       throw new UnsupportedError("Unsupported platform");
//     }
//   }
//
//   static String get rewardedAdUnitId {
//     if (Platform.isAndroid) {
//       return "ca-app-pub-8318136058462894/4360426922";
//     } else if (Platform.isIOS) {
//       return "ca-app-pub-8318136058462894/5284472263";
//     } else {
//       throw new UnsupportedError("Unsupported platform");
//     }
//   }
// }