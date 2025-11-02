import 'package:flutter/material.dart';
import 'package:hasta_takip/bloc/my_auth_cubit.dart';
import 'package:hasta_takip/widget/auth_bottom_sheet.dart';
import 'package:hasta_takip/widget/button.dart';
import 'package:hasta_takip/widget/meeting_bottom_sheet.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //LOGO
          SizedBox(height: 400, child: Image.asset('assets/image.png')),

          SizedBox(height: 136),

          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset('assets/image2.png', fit: BoxFit.cover),
                ),

                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      // DANIŞMAN BUTONU
                      MyButton(
                        buttonclick: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              return BlocProvider.value(
                                value: context.read<AuthCubit>(),
                                child: AuthBottomSheet(
                                  userType: "Danışman",
                                  parentContext: context,
                                ),
                              );
                            },
                          );
                        },
                        buttontext: "Danışman",
                        textcolor: const Color(0xFFFFFFFF),
                        backcolor: const Color(0xFF0EBE80),
                        height: 54,
                        width: double.infinity,
                      ),

                      const SizedBox(height: 16),

                      // DOKTOR BUTONU
                      MyButton(
                        buttonclick: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25),
                              ),
                            ),
                            builder: (context) {
                              return BlocProvider.value(
                                value: context.read<AuthCubit>(),
                                child: AuthBottomSheet(
                                  userType: "Doktor",
                                  parentContext: context,
                                ),
                              );
                            },
                          );
                        },
                        buttontext: "Doktor",
                        textcolor: const Color(0xFFFFFFFF),
                        backcolor: const Color(0xFF02714A),
                        height: 54,
                        width: double.infinity,
                      ),

                      const SizedBox(height: 16),
                      MyButton(
                        buttonclick: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25),
                              ),
                            ),
                            builder: (context) =>
                                const MyBottomSheet(userType: "Hasta"),
                          );
                        },
                        buttontext: "Hasta",
                        textcolor: const Color(0xFFFFFFFF),
                        backcolor: const Color.fromARGB(255, 63, 213, 160),
                        height: 54,
                        width: double.infinity,
                      ),
                      TextButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25),
                              ),
                            ),
                            builder: (context) {
                              return BlocProvider.value(
                                value: context.read<AuthCubit>(),
                                child: AuthBottomSheet(
                                  parentContext: context,
                                  userType: "Gelistirici",
                                ),
                              );
                            },
                          );
                        },
                        child: const Text(
                          "Geliştirici",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
