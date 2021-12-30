import 'package:ecommerce_app/bottom_navigation.dart';
import 'package:ecommerce_app/screens/splash/splash_screen.dart';
import 'package:ecommerce_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'blocs/bloc.dart';
import 'configs/config.dart';
import 'configs/size_config.dart';
import 'screens/intro_preview/intro_preview.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final route = Routes();

  @override
  void initState() {
    super.initState();
    AppBloc.applicationBloc.add(OnSetupApplication());
  }

  @override
  void dispose() {
    super.dispose();
    AppBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: AppBloc.providers,
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, lang) {
          return BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, theme) {
              return LayoutBuilder(builder: (context, constraints) {
                return OrientationBuilder(builder: (context, orientation) {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    theme: AppTheme.lightTheme,
                    darkTheme: AppTheme.darkTheme,
                    onGenerateRoute: route.generateRoute,
                    locale: AppLanguage.defaultLanguage,
                    localizationsDelegates: [
                      Translate.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    supportedLocales: AppLanguage.supportLanguage,
                    home: BlocBuilder<ApplicationBloc, ApplicationState>(
                      builder: (context, app) {
                        if (app is ApplicationSetupCompleted) {
                          SizeConfig().init(constraints, orientation);
                          return BottomNavigation();
                        }
                        if (app is ApplicationIntroView) {
                          return IntroPreview();
                        }
                        return SplashScreen();
                      },
                    ),
                  );
                });
              });
            },
          );
        },
      ),
    );
  }
}
