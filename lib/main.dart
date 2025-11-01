import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hasta_takip/page/advisor/home.dart';
import 'package:hasta_takip/page/developer/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hasta_takip/bloc/my_auth_cubit.dart';
import 'package:hasta_takip/repository/auth_repository.dart';
import 'package:hasta_takip/page/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  // 1) supabase'i başlat
  await Supabase.initialize(
    url: 'https://afdlrxzencxcaybryrmt.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFmZGxyeHplbmN4Y2F5YnJ5cm10Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE5ODg1MTAsImV4cCI6MjA3NzU2NDUxMH0.RrAnpHuqkULPvGIHOZjBbeUbWnZ2dptxNEH_cpmM2Es',
  );

  // 2) repo oluştur
  final authRepo = AuthRepository(Supabase.instance.client);

  runApp(
    // 3) REPO + CUBIT en tepeye
    RepositoryProvider.value(
      value: authRepo,
      child: BlocProvider(
        create: (_) => AuthCubit(authRepo),
        child: const MyApp(),
      ),
    ),
  );
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
        'homedeveloper': (context) => const HomeDeveloper(),
      },
    );
  }
}
