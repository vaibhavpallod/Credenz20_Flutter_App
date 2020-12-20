import 'package:flutter/material.dart';

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double defaultSize;
  static Orientation orientation;

  void init(BuildContext context){
    _mediaQueryData = MediaQuery.of(context);
    screenHeight = _mediaQueryData.size.height;
    screenWidth = _mediaQueryData.size.width;
    orientation = _mediaQueryData.orientation;
  }
}


double getProportionateScreenHeight(double inputHeight){
  double screenHeight = SizeConfig.screenHeight;
  // 812 is the layout height that designer use
  return (inputHeight/812.0)*screenHeight;
}

double getProportionateScreenWidth(double inputWidth){
  double screenWidth = SizeConfig.screenWidth;
  // 375 is the layout Width that designer use
  return (inputWidth/375.0)*screenWidth;
}