import 'package:comic_app_with_getx/routes/routes_name.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    navigateToLogin();
  }

  void navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 10)); // Chờ 3 giây
    Get.offNamed(RoutesName.loginPage); // Điều hướng tới LoginPage
  }
}
