import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:another_flushbar/flushbar.dart';

import 'package:hasta_takip/widget/button.dart';
import 'package:hasta_takip/widget/text_field.dart';
import 'package:hasta_takip/bloc/auth_cubit.dart';
import 'package:hasta_takip/bloc/auth_state.dart' as my;

class AuthBottomSheet extends StatefulWidget {
  /// "Danışman" | "Doktor" | "Gelistirici"
  final String userType;

  const AuthBottomSheet({super.key, required this.userType});

  @override
  State<AuthBottomSheet> createState() => _AuthBottomSheetState();
}

class _AuthBottomSheetState extends State<AuthBottomSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // danışman
  final _emailSecretary = TextEditingController();
  final _passSecretary = TextEditingController();

  // doktor
  final _emailDoctor = TextEditingController();
  final _passDoctor = TextEditingController();

  // geliştirici
  final _emailDev = TextEditingController();
  final _passDev = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailSecretary.dispose();
    _passSecretary.dispose();
    _emailDoctor.dispose();
    _passDoctor.dispose();
    _emailDev.dispose();
    _passDev.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    return BlocListener<AuthCubit, my.AuthState>(
      listener: (context, state) {
        if (state is my.AuthError) {
          Flushbar(
            flushbarPosition: FlushbarPosition.TOP,
            animationDuration: const Duration(milliseconds: 500),
            forwardAnimationCurve: Curves.easeOut,
            reverseAnimationCurve: Curves.easeIn,
            message: state.message,
            backgroundColor: const Color.fromARGB(255, 175, 76, 76),
          ).show(context);
        } else if (state is my.LoggedIn) {
          final role = state.role.toLowerCase();
          Navigator.of(context).pop();

          // role'e göre yönlendirme
          if (role == 'developer' ||
              role == 'gelistirici' ||
              role == 'geliştirici') {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil('/homedeveloper', (route) => false);
          } else if (role == 'doctor' || role == 'doktor') {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil('/homedoctor', (route) => false);
          } else if (role == 'advisor' ||
              role == 'danışman' ||
              role == 'danisman') {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil('/homeadvisor', (route) => false);
          } else {
            Flushbar(
              flushbarPosition: FlushbarPosition.TOP,
              animationDuration: const Duration(milliseconds: 500),
              forwardAnimationCurve: Curves.easeOut,
              reverseAnimationCurve: Curves.easeIn,
              message: "Bilinmeyen kullanıcı rolü: $role",
              backgroundColor: Colors.green,
            ).show(context);
          }
        }
      },
      child: Container(
        height: 700,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Giriş Yap",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Expanded(child: _buildLoginTab(authCubit)),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginTab(AuthCubit authCubit) {
    final type = widget.userType.toLowerCase();

    if (type == "danışman" || type == "danisman" || type == "advisor") {
      return _loginForm(
        authCubit: authCubit,
        emailController: _emailSecretary,
        passController: _passSecretary,
        buttonColor: const Color(0xFF0EBE80),
        img: Image.asset('assets/secretary1.jpg'),
      );
    }

    if (type == "doktor" || type == "doctor") {
      return _loginForm(
        authCubit: authCubit,
        emailController: _emailDoctor,
        passController: _passDoctor,
        buttonColor: const Color(0xFF02714A),
        img: Image.asset('assets/doctor1.jpg'),
      );
    }

    // geliştirici
    return _loginForm(
      authCubit: authCubit,
      emailController: _emailDev,
      passController: _passDev,
      buttonColor: const Color(0xFF02714A),
      img: Image.asset('assets/developer.jpg'),
    );
  }

  Widget _loginForm({
    required AuthCubit authCubit,
    required TextEditingController emailController,
    required TextEditingController passController,
    required Color buttonColor,
    required Image img,
  }) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            MyTextField(
              text: "E-Posta",
              controller: emailController,
              onchanged: (_) {},
            ),
            const SizedBox(height: 15),
            MyTextField(
              text: "Şifre",
              controller: passController,
              onchanged: (_) {},
              isPassword: true,
            ),
            const SizedBox(height: 20),
            MyButton(
              buttonclick: () {
                final email = emailController.text.trim();
                final pass = passController.text.trim();

                if (email.isEmpty || pass.isEmpty) {
                  Flushbar(
                    flushbarPosition: FlushbarPosition.TOP,
                    animationDuration: const Duration(milliseconds: 500),
                    forwardAnimationCurve: Curves.easeOut,
                    reverseAnimationCurve: Curves.easeIn,
                    message: "Lütfen tüm alanları doldurun",
                    backgroundColor: const Color.fromARGB(255, 175, 76, 76),
                    duration: Duration(seconds: 2),
                  ).show(context);
                  return;
                }

                authCubit.getSignIn(email, pass);
              },
              buttontext: "Giriş Yap",
              textcolor: Colors.white,
              backcolor: buttonColor,
              height: 54,
              width: double.infinity,
            ),
            const SizedBox(height: 20),
            img,
          ],
        ),
      ),
    );
  }
}
