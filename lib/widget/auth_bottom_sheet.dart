import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hasta_takip/widget/button.dart';
import 'package:hasta_takip/widget/text_field.dart';
import 'package:hasta_takip/bloc/my_auth_cubit.dart';
import 'package:hasta_takip/bloc/my_auth_state.dart' as my;
import 'package:another_flushbar/flushbar.dart';

class AuthBottomSheet extends StatefulWidget {
  final String userType; // "Danışman" | "Doktor" | "Geliştirici"
  final BuildContext parentContext;

  const AuthBottomSheet({
    super.key,
    required this.userType,
    required this.parentContext,
  });

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
          // 👉 asıl nav'ı parent context ile yapalım
          final navCtx = widget.parentContext;
          final role = state.role.toLowerCase();

          if (role == 'developer' ||
              role == 'gelistirici' ||
              role == 'geliştirici') {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/homedeveloper',
              (route) => false,
            );
          } else if (role == 'doctor' || role == 'doktor') {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/homedoctor',
              (route) => false,
            );
          } else if (role == 'advisor' ||
              role == 'danışman' ||
              role == 'danisman') {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/homeadvisor',
              (route) => false,
            );
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
        height: MediaQuery.of(context).size.height,
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
              "${widget.userType} Girişi",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TabBar(
              controller: _tabController,
              labelColor: Colors.teal,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.teal,
              tabs: const [Tab(text: "Giriş Yap")],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [_buildLoginTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginTab() {
    final type = widget.userType.toLowerCase();

    if (type == "danışman" || type == "danisman" || type == "advisor") {
      return _loginForm(
        rootContext: widget.parentContext,
        emailController: _emailSecretary,
        passController: _passSecretary,
        buttonColor: const Color(0xFF0EBE80),
        img: Image.asset('assets/secretary1.jpg'),
      );
    }

    if (type == "doktor" || type == "doctor") {
      return _loginForm(
        rootContext: widget.parentContext,
        emailController: _emailDoctor,
        passController: _passDoctor,
        buttonColor: const Color(0xFF02714A),
        img: Image.asset('assets/doctor1.jpg'),
      );
    }

    // geliştirici (default)
    return _loginForm(
      rootContext: widget.parentContext,
      emailController: _emailDev,
      passController: _passDev,
      buttonColor: const Color(0xFF02714A),
      img: Image.asset('assets/developer.jpg'),
    );
  }

  Widget _loginForm({
    required BuildContext rootContext,
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
            MyTextField(
              text: "E-Posta",
              controller: emailController,
              onchanged: (_) {},
            ),
            const SizedBox(height: 10),
            MyTextField(
              text: "Şifre",
              controller: passController,
              onchanged: (_) {},
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
                  ).show(context);
                  return;
                }

                rootContext.read<AuthCubit>().getSignIn(email, pass);
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
