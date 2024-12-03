import 'package:comic_app_with_getx/routes/routes_name.dart';
import 'package:comic_app_with_getx/views/all_comic/all_comic_page.dart';
import 'package:comic_app_with_getx/views/auth/login/login_page.dart';
import 'package:comic_app_with_getx/views/category/comic_by_category_page.dart';
import 'package:comic_app_with_getx/views/comic_ongoing/ongoing_comic_page.dart';
import 'package:comic_app_with_getx/views/comic_up_comming/upcoming_comic_page.dart';
import 'package:comic_app_with_getx/views/detail_comic/comic_detail_page.dart';
import 'package:comic_app_with_getx/views/drawer_menu/drawer_menu.dart';
import 'package:comic_app_with_getx/views/home/home_page.dart';
import 'package:comic_app_with_getx/views/search/search_page.dart';
import 'package:get/get.dart';

import '../views/chapter_detail/chapter_detail_page.dart';
import '../views/splash/splash_page.dart';

class AppRoutes {
  static appRoutes() => [
        GetPage(
            name: RoutesName.splashPage,
            page: () => SplashPage(),
            transitionDuration: const Duration(milliseconds: 250),
            transition: Transition.leftToRightWithFade),
        GetPage(
            name: RoutesName.loginPage,
            page: () => const LoginPage(),
            transitionDuration: const Duration(milliseconds: 250),
            transition: Transition.leftToRightWithFade),
        GetPage(
            name: RoutesName.drawerMenuPage,
            page: () => const DrawerMenuPage(),
            transitionDuration: const Duration(milliseconds: 250),
            transition: Transition.leftToRightWithFade),
        GetPage(
            name: RoutesName.homePage,
            page: () => HomePage(),
            transitionDuration: const Duration(milliseconds: 250),
            transition: Transition.leftToRightWithFade),
        GetPage(
            name: RoutesName.comicDetailPage,
            page: () => const ComicDetailPage(),
            transitionDuration: const Duration(milliseconds: 250),
            transition: Transition.leftToRightWithFade),
        GetPage(
            name: RoutesName.chapterDetailPage,
            page: () => const ChapterDetailPage(),
            transitionDuration: const Duration(milliseconds: 250),
            transition: Transition.leftToRightWithFade),
        GetPage(
            name: RoutesName.allComicPage,
            page: () => const AllComicPage(),
            transitionDuration: const Duration(milliseconds: 250),
            transition: Transition.leftToRightWithFade),
        GetPage(
            name: RoutesName.searchComicPage,
            page: () => const SearchPage(),
            transitionDuration: const Duration(milliseconds: 250),
            transition: Transition.leftToRightWithFade),
        GetPage(
            name: RoutesName.comicByCategoryPage,
            page: () => const ComicByCategoryPage(),
            transitionDuration: const Duration(milliseconds: 250),
            transition: Transition.leftToRightWithFade),
        GetPage(
            name: RoutesName.upcomingComic,
            page: () => const UpcomingComicPage(),
            transitionDuration: const Duration(milliseconds: 250),
            transition: Transition.leftToRightWithFade),
        GetPage(
            name: RoutesName.ongoingComic,
            page: () => const OngoingComicPage(),
            transitionDuration: const Duration(milliseconds: 250),
            transition: Transition.leftToRightWithFade),
        GetPage(
            name: RoutesName.competedComic,
            page: () => const ComicDetailPage(),
            transitionDuration: const Duration(milliseconds: 250),
            transition: Transition.leftToRightWithFade),
      ];
}
