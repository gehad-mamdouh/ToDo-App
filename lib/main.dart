import 'package:flutter/material.dart';
import 'package:todo/home/home_screen.dart';
import 'package:todo/my_theme_data.dart';
import 'package:todo/splash_screen.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: MyThemeData.lightTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: SplashScreen.routeName,
        routes: {
          SplashScreen.routeName: (context) => SplashScreen(),
          HomeScreen.routeName: (context) => HomeScreen(),
        });
  }
}
