import 'package:flutter/material.dart';
import 'package:flutter_applications/screens/food/recommended_food_details.dart';
import 'package:flutter_applications/screens/food_%20carousel.dart';
import 'package:flutter_applications/screens/home_screen.dart';
import 'package:get/get.dart';
import 'data/controllers/product_controller.dart';
import 'helper/dependencies.dart' as dep;
Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await dep.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
      Get.find<ProductController>().getProductList();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ecommerce App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
