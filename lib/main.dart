import 'package:flutter/material.dart';
import 'package:hasta_takip/page/advisor/home.dart';
import 'package:hasta_takip/page/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splashscreen',
      routes: {'/splashscreen': (context) => const SplashScreen(),
      '/homeadvisor': (context) => const HomePage(),
      
      },
    );
  }
}
