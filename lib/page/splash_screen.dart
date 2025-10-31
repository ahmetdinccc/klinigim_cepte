import 'package:flutter/material.dart';
import 'package:hasta_takip/widget/auth_bottom_sheet.dart';
import 'package:hasta_takip/widget/button.dart';
import 'package:hasta_takip/widget/meeting_bottom_sheet.dart';

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
                            builder: (context) =>
                                const AuthBottomSheet(userType: "Danışman"),
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
                            builder: (context) =>
                                const AuthBottomSheet(userType: "Doktor"),
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
