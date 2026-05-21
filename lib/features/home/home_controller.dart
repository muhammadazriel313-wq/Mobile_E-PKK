import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final List<Widget> imgList = [
    Container(
      child: Image.asset(
        "assets/images/Banner0.png",
        fit: BoxFit.cover,
      ),
    ),
    Container(
      child: Image.asset(
        "assets/images/Banner2.png",
        fit: BoxFit.cover,
      ),
    ),
    Container(
      child: Image.asset(
        "assets/images/Banner3.png",
        fit: BoxFit.cover,
      ),
    ),
    Container(
      child: Image.asset(
        "assets/images/Banner4.png",
        fit: BoxFit.cover,
      ),
    ),
  ];
}
