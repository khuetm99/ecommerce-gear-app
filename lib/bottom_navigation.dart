import 'package:ecommerce_app/blocs/authentication/authentication_bloc.dart';
import 'package:ecommerce_app/screens/profile/profile.dart';
import 'package:ecommerce_app/screens/wishlist/wishlist.dart';
import 'package:ecommerce_app/utils/translate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/authentication/bloc.dart';
import 'configs/routes.dart';
import 'screens/home/home_screen.dart';
import 'widgets/custom_bottom_navbar.dart';

class BottomNavigation extends StatefulWidget {
  BottomNavigation({Key? key}) : super(key: key);

  @override
  _BottomNavigationState createState() {
    return _BottomNavigationState();
  }
}

class _BottomNavigationState extends State<BottomNavigation>
    with WidgetsBindingObserver {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }



  ///On change tab bottom menu
  void _onItemTapped({int? index, bool? requireLogin}) async {
    if (requireLogin! && (index == 1 || index == 2)) {
      final result = await Navigator.pushNamed(
        context,
        Routes.signIn,
        arguments: index == 1 ? Routes.wishList : Routes.account,
      );
      switch (result) {
        case Routes.wishList:
          index = 1;
          break;
        case Routes.account:
          index = 2;
          break;
        default:
          return;
      }
    }
    setState(() {
      selectedIndex = index!;
    });
  }


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) async{
        if (state is Unauthenticated && (selectedIndex == 1 || selectedIndex == 2)) {
          final result = await Navigator.pushNamed(
            context,
            Routes.signIn,
            arguments: selectedIndex == 1 ? Routes.wishList : Routes.account,
          );
          if (result == null) {
            setState(() {
              selectedIndex = 0;
            });
          }
        }
      },
      builder: (context, state) {
        final requireLogin = state is Unauthenticated;

        return Scaffold(
          body: IndexedStack(
            children: <Widget>[HomeScreen(), WishList(), Profile()],
            index: selectedIndex,
          ),
          bottomNavigationBar: SalomonBottomBar(
            itemPadding: EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
            items: [
              SalomonBottomBarItem(
                icon:  Icon(Icons.home),
                title: Text(Translate.of(context)!.translate('home')),
                selectedColor: Theme.of(context).primaryColor
              ),
              SalomonBottomBarItem(
                  icon:  Icon(Icons.bookmark),
                  title: Text(Translate.of(context)!.translate('wish_list')),
                  selectedColor: Theme.of(context).primaryColor
              ),
              SalomonBottomBarItem(
                icon: Icon(Icons.account_circle),
                title: Text(Translate.of(context)!.translate('profile')),
                  selectedColor: Theme.of(context).primaryColor
              ),
            ],
            currentIndex: selectedIndex,
            onTap: (index) {
              _onItemTapped(index: index, requireLogin: requireLogin);
            },
          ),
        );
      },
    );
  }
}
