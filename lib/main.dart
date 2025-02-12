import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management_app/app/core/bindings/application_bindings.dart';
import 'package:management_app/app/core/helpers/database_helper.dart';
import 'package:management_app/app/core/helpers/global_error_handling.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GlobalErrorHandler.init();
  await DatabaseHelper.generateDummyData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Product Management',
      theme: ThemeData(
        useMaterial3: false,
        textTheme: GoogleFonts.interTextTheme(),
      ),
      initialBinding: ApplicationBindings(),
      getPages: AppPages.routes,
      initialRoute: AppPages.INITIAL,
    );
  }
}
