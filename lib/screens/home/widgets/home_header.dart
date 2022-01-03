import 'package:ecommerce_app/blocs/app_bloc.dart';
import 'package:ecommerce_app/blocs/authentication/bloc.dart';
import 'package:ecommerce_app/configs/config.dart';
import 'package:ecommerce_app/configs/size_config.dart';
import 'package:ecommerce_app/constants/constants.dart';
import 'package:ecommerce_app/utils/utils.dart';
import 'package:ecommerce_app/widgets/icon_button_with_counter.dart';
import 'package:ecommerce_app/widgets/widget.dart';
import 'package:flutter/material.dart';

class HomePersistentHeader extends SliverPersistentHeaderDelegate {
  double _mainHeaderHeight = SizeConfig.defaultSize * 4;
  double _searchFieldHeight = SizeConfig.defaultSize * 6;
  double _insetVertical = SizeConfig.defaultSize * 1.5;
  double _insetHorizontal = SizeConfig.defaultSize * 1.5;

  // _mainHeaderHeight + 2*_insetVertical
  double _minHeaderExtent = SizeConfig.defaultSize * 7;

  // _mainHeaderHeight + _searchFieldHeight + 2*_insetVertical + whiteSpace
  double _maxHeaderExtent =
      SizeConfig.defaultSize * 13 + SizeConfig.defaultSize;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final size = MediaQuery.of(context).size;
    final offsetPercent = shrinkOffset / _maxHeaderExtent;
    var rangeSearchFieldWidth = (1 - offsetPercent).clamp(0.8, 2);

    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        boxShadow: [
          BoxShadow(
            blurRadius: 1,
            spreadRadius: 1,
            color: Color(0xFFd3d1d1).withOpacity(0.2),
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: _insetVertical,
            left: _insetHorizontal,
            right: _insetHorizontal - 10,
            height: _mainHeaderHeight,
            child: Row(
              children: [
                AnimatedOpacity(
                  opacity: offsetPercent > 0.1 ? 0 : 1,
                  duration: Duration(microseconds: 500),
                  child: Text(
                    "Peachy",
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Spacer(),
                Row(
                  children: [
                    CartButton(),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 8),
                      child: IconButtonWithCounter(
                        icon: ICON_CONST.MESSAGE,
                        onPressed: () async{
                          final authState = AppBloc.authBloc.state;
                          if(authState is Unauthenticated) {
                            final result = await Navigator.pushNamed(
                              context,
                              Routes.signIn,
                              arguments: Routes.message,
                            );
                            if (result != Routes.message) {
                              return;
                            }
                          }
                          Navigator.pushNamed(context, Routes.message);},
                        counter: 0,
                        size: 25,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Positioned(
            bottom: _insetVertical,
            left: 0,
            height: _searchFieldHeight - 3,
            width: size.width * rangeSearchFieldWidth + 5,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: _insetHorizontal),
                child: SearchFieldWidget(
                  readOnly: true,
                  onTap: () => Navigator.pushNamed(context, Routes.search),
                  hintText: Translate.of(context)!
                      .translate('what_would_you_search_today'),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  double get maxExtent => _maxHeaderExtent;

  @override
  double get minExtent => _minHeaderExtent;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
