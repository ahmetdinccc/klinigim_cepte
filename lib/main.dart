import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hasta_takip/firebase_options.dart';
import 'package:hasta_takip/page/advisor/home.dart';
import 'package:hasta_takip/page/developer/home.dart';
import 'package:hasta_takip/bloc/auth_cubit.dart';
import 'package:hasta_takip/repository/auth_repository.dart';
import 'package:hasta_takip/page/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);


 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splashscreen',
      routes: {
        '/splashscreen': (context) => const SplashScreen(),
        '/homeadvisor': (context) => const HomePage(),
        '/homedeveloper': (context) => const HomeDeveloper(),
      },
    );
  }
}
