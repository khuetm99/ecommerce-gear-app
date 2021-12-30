import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/blocs/authentication/bloc.dart';
import 'package:ecommerce_app/blocs/bloc.dart';
import 'package:ecommerce_app/blocs/cart/bloc.dart';
import 'package:ecommerce_app/blocs/profile/bloc.dart';
import 'package:ecommerce_app/configs/config.dart';
import 'package:ecommerce_app/data/models/theme_model.dart';
import 'package:ecommerce_app/utils/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ApplicationBloc extends Bloc<ApplicationEvent, ApplicationState> {
  ApplicationBloc() : super(InitialApplicationState());

  final application = Application();

  @override
  Stream<ApplicationState> mapEventToState(event) async* {
    if (event is OnSetupApplication) {
      ///Firebase init
      await Firebase.initializeApp();

      ///Ads init
      await MobileAds.instance.initialize();

      ///Setup SharedPreferences
      await application.setPreferences();


      ///Get old Theme & Font & Language
      final oldTheme = UtilPreferences.getString(Preferences.theme);
      final oldFont = UtilPreferences.getString(Preferences.font);
      final oldLanguage = UtilPreferences.getString(Preferences.language);
      final oldDarkOption = UtilPreferences.getString(Preferences.darkOption);

      DarkOption? darkOption;
      String? font;
      ThemeModel? theme;

      ///Setup Language
      if (oldLanguage != null) {
        AppBloc.languageBloc.add(
          OnChangeLanguage(Locale(oldLanguage)),
        );
      }

      ///Find font support available
      try {
        font = AppTheme.fontSupport.firstWhere((item) {
          return item == oldFont;
        });
      } catch (e) {}

      ///Find theme support available
      try {
        theme = AppTheme.themeSupport.firstWhere((item) {
          return item.name == oldTheme;
        });
      } catch (e) {}

      ///check old dark option

      if (oldDarkOption != null) {
        switch (oldDarkOption) {
          case DARK_ALWAYS_OFF:
            darkOption = DarkOption.alwaysOff;
            break;
          case DARK_ALWAYS_ON:
            darkOption = DarkOption.alwaysOn;
            break;
          default:
            darkOption = DarkOption.dynamic;
        }
      }

      ///Setup Theme & Font with dark Option
      AppBloc.themeBloc.add(
        OnChangeTheme(
          theme: theme,
          font: font,
          darkOption: darkOption,
        ),
      );

      ///Authentication begin check
      AppBloc.authBloc.add(AuthenticationStarted());

      ///profile Load
      AppBloc.profileBloc.add(LoadProfile());

      ///cart Load
      AppBloc.cartBloc.add(LoadCart());


      ///First or After upgrade version show intro preview app
      final hasReview = UtilPreferences.containsKey(
        '${Preferences.reviewIntro}.${Application.version}',
      );
      if (hasReview) {
        ///Become app
        yield ApplicationSetupCompleted();
      } else {
        ///Pending preview intro
        yield ApplicationIntroView();
      }
    }

    ///Event Completed IntroView
    if (event is OnCompletedIntro) {
      await UtilPreferences.setBool(
        '${Preferences.reviewIntro}.${Application.version}',
        true,
      );

      yield ApplicationSetupCompleted();
    }
  }
}
