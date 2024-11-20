import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/auth/registeretion/register_screen.dart';
import 'package:todo/home/home_screen.dart';
import 'package:todo/home/home_task_list/edit_task.dart';
import 'package:todo/my_theme_data.dart';
import 'package:todo/provider/auth_user_provider.dart';
import 'package:todo/provider/list_provider.dart';
import 'package:todo/provider/theme_provider.dart';
import 'package:todo/splash_screen.dart';

import 'auth/Login/login_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await FirebaseFirestore.instance.disableNetwork();
  await FirebaseFirestore.instance.clearPersistence();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ListProvider()),
        ChangeNotifierProvider(create: (context) => AuthUserProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      theme: MyThemeData.lightTheme,
      darkTheme: MyThemeData.darkTheme,
      themeMode: themeProvider.themeMode,
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (context) => const SplashScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        EditTask.routeName: (context) => const EditTask(),
      },
    );
  }
}
