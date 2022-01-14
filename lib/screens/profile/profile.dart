import 'package:ecommerce_app/blocs/authentication/authentication_bloc.dart';
import 'package:ecommerce_app/blocs/authentication/bloc.dart';
import 'package:ecommerce_app/blocs/bloc.dart';
import 'package:ecommerce_app/blocs/login/bloc.dart';
import 'package:ecommerce_app/blocs/profile/bloc.dart';
import 'package:ecommerce_app/configs/ads.dart';
import 'package:ecommerce_app/configs/routes.dart';
import 'package:ecommerce_app/constants/icon_constant.dart';
import 'package:ecommerce_app/data/models/models.dart';
import 'package:ecommerce_app/utils/logger_ads.dart';
import 'package:ecommerce_app/utils/translate.dart';
import 'package:ecommerce_app/utils/utils.dart';
import 'package:ecommerce_app/widgets/app_button.dart';
import 'package:ecommerce_app/widgets/app_list_title.dart';
import 'package:ecommerce_app/widgets/app_user_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() {
    return _ProfileState();
  }
}

class _ProfileState extends State<Profile> {
  UserModel? user;

  // TODO: Add a BannerAd instance
  late BannerAd _bannerAd;

  // TODO: Add _isAdLoaded
  bool _isAdLoaded = false;

  final bannerAd = BannerAd(
    adUnitId: Ads.bannerAdUnitId,
    size: AdSize.mediumRectangle,
    request: AdRequest(),
    listener: AdListener(
      onAdLoaded: (Ad ad) {
        UtilLogger.log("DEBUGGGGG", 1);
      },
      onAdFailedToLoad: (ad, error) {
        UtilLogger.log("DEBUGGGGG", error.message);
      },
      onAdOpened: (Ad ad) => UtilLogger.log("DEBUGGGGG", 3),
      onAdClosed: (Ad ad) => UtilLogger.log("DEBUGGGGG", 4),
      onApplicationExit: (Ad ad) => UtilLogger.log("DEBUGGGGG", 5),
    ),
  );

  final myRewarded = RewardedAd(
    adUnitId: Ads.rewardedAdUnitId,
    request: AdRequest(),
    listener: AdListener(
      onRewardedAdUserEarnedReward: (ad, reward) {
        UtilLogger.log("Reward earned");
      },
    ),
  );

  @override
  void initState() {
    super.initState();


    bannerAd.load();
    myRewarded.load();
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd.dispose();
    bannerAd.dispose();
    myRewarded.dispose();
  }

  ///On navigation
  void onNavigate(String route) {
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, profileState) {
        UserModel? user;

        if (profileState is ProfileLoaded) {
          user = profileState.loggedUser;
        } else if (profileState is ProfileLoadFailure) {
          user = null;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              Translate.of(context)!.translate('profile'),
            ),
          ),
          body: BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is ProfileSaveSuccess || state is ProfileSaveFailure) {
                AppBloc.profileBloc.add(LoadProfile());
              }
            },
            child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, authState) {
                if (authState is Authenticated) {
                  return SafeArea(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.only(
                              top: 16,
                            ),
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                ),
                                child: AppUserInfo(
                                  user: user,
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, Routes.editProfile,
                                        arguments: user);
                                  },
                                  type: AppUserType.information,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 16, right: 16, top: 8),
                                child: Column(
                                  children: [
                                    AppListTitle(
                                      title: Translate.of(context)!
                                          .translate('settings'),
                                      icon: SvgPicture.asset(
                                        ICON_CONST.SETTING,
                                        width: 20,
                                        height: 25,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      onPressed: () {
                                        onNavigate(Routes.setting);
                                      },
                                      trailing: Row(
                                        children: <Widget>[
                                          RotatedBox(
                                            quarterTurns:
                                                UtilLanguage.isRTL() ? 2 : 0,
                                            child: Icon(
                                              Icons.keyboard_arrow_right,
                                              textDirection: TextDirection.ltr,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    AppListTitle(
                                      title: Translate.of(context)!
                                          .translate('cart'),
                                      icon: SvgPicture.asset(
                                        ICON_CONST.CART,
                                        width: 20,
                                        height: 25,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      onPressed: () {
                                        onNavigate(Routes.cart);
                                      },
                                      trailing: Row(
                                        children: <Widget>[
                                          RotatedBox(
                                            quarterTurns:
                                                UtilLanguage.isRTL() ? 2 : 0,
                                            child: Icon(
                                              Icons.keyboard_arrow_right,
                                              textDirection: TextDirection.ltr,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    AppListTitle(
                                      title: Translate.of(context)!
                                          .translate('order'),
                                      icon: SvgPicture.asset(
                                        ICON_CONST.ORDER,
                                        width: 20,
                                        height: 25,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      onPressed: () {
                                        onNavigate(Routes.myOrders);
                                      },
                                      trailing: Row(
                                        children: <Widget>[
                                          RotatedBox(
                                            quarterTurns:
                                                UtilLanguage.isRTL() ? 2 : 0,
                                            child: Icon(
                                              Icons.keyboard_arrow_right,
                                              textDirection: TextDirection.ltr,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    AppListTitle(
                                      title: Translate.of(context)!
                                          .translate('address'),
                                      icon: SvgPicture.asset(
                                        ICON_CONST.ADDRESS,
                                        width: 30,
                                        height: 25,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      onPressed: () {
                                        onNavigate(Routes.deliveryAddress);
                                      },
                                      trailing: Row(
                                        children: <Widget>[
                                          RotatedBox(
                                            quarterTurns:
                                                UtilLanguage.isRTL() ? 2 : 0,
                                            child: Icon(
                                              Icons.keyboard_arrow_right,
                                              textDirection: TextDirection.ltr,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // _isAdLoaded
                                    //     ? Container(
                                    //         child: AdWidget(ad: _bannerAd),
                                    //         width: _bannerAd.size.width.toDouble(),
                                    //         height: 180.0,
                                    //         alignment: Alignment.center,
                                    //       )
                                    //     : Container()
                                    SizedBox(height: 2,),
                                    Container(
                                      width: bannerAd.size.width.toDouble(),
                                      height: bannerAd.size.height.toDouble() - 4,
                                      child: AdWidget(ad: bannerAd),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16, right: 16, top: 6, bottom: 6),
                          child: BlocBuilder<LoginBloc, LoginState>(
                            builder: (context, logout) {
                              return AppButton(
                                Translate.of(context)!.translate('log_out'),
                                onPressed: () {
                                  AppBloc.authBloc.add(LoggedOut());
                                },
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  );
                }

                return ListView(
                  padding: EdgeInsets.only(
                    top: 15,
                  ),
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: AppUserInfo(type: AppUserType.information),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 8),
                      child: Shimmer.fromColors(
                        baseColor: Theme.of(context).hoverColor,
                        highlightColor: Theme.of(context).highlightColor,
                        enabled: true,
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 40,
                              color: Colors.white,
                              margin: EdgeInsets.only(top: 16),
                            ),
                            Container(
                              height: 40,
                              color: Colors.white,
                              margin: EdgeInsets.only(top: 16),
                            ),
                            Container(
                              height: 40,
                              color: Colors.white,
                              margin: EdgeInsets.only(top: 16),
                            ),
                            Container(
                              height: 40,
                              color: Colors.white,
                              margin: EdgeInsets.only(top: 16),
                            ),
                            Container(
                              height: 40,
                              color: Colors.white,
                              margin: EdgeInsets.only(top: 16),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
