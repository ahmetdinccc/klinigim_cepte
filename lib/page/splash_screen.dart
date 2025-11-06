import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hasta_takip/bloc/auth_cubit.dart';
import 'package:hasta_takip/widget/auth_bottom_sheet.dart';
import 'package:hasta_takip/widget/button.dart';
import 'package:hasta_takip/widget/meeting_bottom_sheet.dart';

// bu ikisi local cubit gerekirse oluşturmak için
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hasta_takip/repository/auth_repository.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔑 Üstte AuthCubit var mı? (yoksa null döner)
    AuthCubit? existingCubit;
    try {
      existingCubit = context.read<AuthCubit>(); // varsa alır
    } catch (_) {
      existingCubit = null; // yoksa null
    }

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LOGO
          SizedBox(height: 400, child: Image.asset('assets/image.png')),

          const SizedBox(height: 136),

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
                      // DANIŞMAN
                      MyButton(
                        buttonclick: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (sheetCtx) {
                              if (existingCubit != null) {
                                // ✅ Üstte provider var: aynı cubit’i paylaş
                                return BlocProvider.value(
                                  value: existingCubit,
                                  child: AuthBottomSheet(
                                    userType: "Danışman",
                                    parentContext: context,
                                  ),
                                );
                              } else {
                                // ✅ Üstte yok: local cubit oluştur
                                return BlocProvider(
                                  create: (_) => AuthCubit(
                                    AuthRepository(auth: FirebaseAuth.instance),
                                  ),
                                  child: AuthBottomSheet(
                                    userType: "Danışman",
                                    parentContext: context,
                                  ),
                                );
                              }
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

                      // DOKTOR
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
                            builder: (sheetCtx) {
                              if (existingCubit != null) {
                                return BlocProvider.value(
                                  value: existingCubit,
                                  child: AuthBottomSheet(
                                    userType: "Doktor",
                                    parentContext: context,
                                  ),
                                );
                              } else {
                                return BlocProvider(
                                  create: (_) => AuthCubit(
                                    AuthRepository(auth: FirebaseAuth.instance),
                                  ),
                                  child: AuthBottomSheet(
                                    userType: "Doktor",
                                    parentContext: context,
                                  ),
                                );
                              }
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

                      // HASTA – dokunmadım
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

                      // GELİŞTİRİCİ
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
                            builder: (sheetCtx) {
                              if (existingCubit != null) {
                                return BlocProvider.value(
                                  value: existingCubit,
                                  child: AuthBottomSheet(
                                    parentContext: context,
                                    userType: "Gelistirici",
                                  ),
                                );
                              } else {
                                return BlocProvider(
                                  create: (_) => AuthCubit(
                                    AuthRepository(auth: FirebaseAuth.instance),
                                  ),
                                  child: AuthBottomSheet(
                                    parentContext: context,
                                    userType: "Gelistirici",
                                  ),
                                );
                              }
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
