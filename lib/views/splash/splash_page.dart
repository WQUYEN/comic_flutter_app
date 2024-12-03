import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'spash_controller.dart';

class SplashPage extends StatelessWidget {
  SplashPage({super.key});

  // Khởi tạo SplashController
  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.network(
          "https://lottie.host/f1ae78e2-205d-447f-9315-e874e28b3b09/GlHwBhdpey.json",
          width: 200,
          height: 200,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
