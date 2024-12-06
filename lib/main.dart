import 'package:comic_app_with_getx/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'routes/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Wq Comic',
      theme: ThemeData.dark(),
      initialRoute: RoutesName.splashPage,
      getPages: AppRoutes.appRoutes(),
      debugShowCheckedModeBanner: false,
    );
  }
}
