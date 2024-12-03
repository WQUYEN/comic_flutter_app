import 'package:comic_app_with_getx/views/all_comic/all_comic_page.dart';
import 'package:comic_app_with_getx/views/category/category_page.dart';
import 'package:comic_app_with_getx/views/comic_completed/completed_comic_page.dart';
import 'package:comic_app_with_getx/views/comic_ongoing/ongoing_comic_page.dart';
import 'package:comic_app_with_getx/views/comic_up_comming/upcoming_comic_page.dart';
import 'package:comic_app_with_getx/views/profile/profile_page.dart';
import 'package:comic_app_with_getx/views/search/search_page.dart';
import 'package:comic_app_with_getx/views/setting/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';

import '../home/home_page.dart';

class DrawerMenuPage extends StatefulWidget {
  const DrawerMenuPage({super.key});

  @override
  State<DrawerMenuPage> createState() => _DrawerMenuPageState();
}

class _DrawerMenuPageState extends State<DrawerMenuPage> {
  List<ScreenHiddenDrawer> _pages = [];
  final mTextStyle = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pages = [
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Home',
          baseStyle: mTextStyle,
          selectedStyle: mTextStyle,
          colorLineSelected: Colors.grey,
        ),
        HomePage(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Category',
          baseStyle: mTextStyle,
          selectedStyle: mTextStyle,
          colorLineSelected: Colors.grey,
        ),
        const CategoryPage(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'New Comic',
          baseStyle: mTextStyle,
          selectedStyle: mTextStyle,
          colorLineSelected: Colors.grey,
        ),
        const AllComicPage(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Ongoing Comic',
          baseStyle: mTextStyle,
          selectedStyle: mTextStyle,
          colorLineSelected: Colors.grey,
        ),
        const OngoingComicPage(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Upcoming Comic',
          baseStyle: mTextStyle,
          selectedStyle: mTextStyle,
          colorLineSelected: Colors.grey,
        ),
        const UpcomingComicPage(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Completed Comic',
          baseStyle: mTextStyle,
          selectedStyle: mTextStyle,
          colorLineSelected: Colors.grey,
        ),
        const CompletedComicPage(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Search',
          baseStyle: mTextStyle,
          selectedStyle: mTextStyle,
          colorLineSelected: Colors.grey,
        ),
        const SearchPage(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Setting',
          baseStyle: mTextStyle,
          selectedStyle: mTextStyle,
          colorLineSelected: Colors.grey,
        ),
        const SettingPage(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Profile',
          baseStyle: mTextStyle,
          selectedStyle: mTextStyle,
          colorLineSelected: Colors.grey,
        ),
        const ProfilePage(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      backgroundColorMenu: Colors.black,
      screens: _pages,
      initPositionSelected: 0,
      slidePercent: 40,
      contentCornerRadius: 20,
    );
  }
}
