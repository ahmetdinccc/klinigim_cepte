import 'package:flutter/material.dart';
import 'package:hasta_takip/widget/button.dart';
import 'package:hasta_takip/widget/text_field.dart';

class MyBottomSheet extends StatefulWidget {
  final String userType; // "Danışman" veya "Doktor" veya "Hasta"

  const MyBottomSheet({super.key, required this.userType});

  @override
  State<MyBottomSheet> createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Doktor kontrolörleri
  final TextEditingController _emailControllerdoctor = TextEditingController();
  final TextEditingController _passwordControllerdoctor =
      TextEditingController();
  final TextEditingController _adControllerdoctor = TextEditingController();
  final TextEditingController _noControllerdoctor = TextEditingController();

  // Danışman / Hasta kontrolörleri
  final TextEditingController _emailControllersecretary =
      TextEditingController();
  final TextEditingController _passwordControllersecretary =
      TextEditingController();
  final TextEditingController _adControllersecretary = TextEditingController();
  final TextEditingController _noControllersecretary = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 840,
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

          // içerik
          Expanded(child: _buildmeeting()),
        ],
      ),
    );
  }

  // ✅ ORTAK GİRİŞ TAB’I
  Widget _buildmeeting() {
    // HASTA GİRİŞİ
    if (widget.userType == "Hasta") {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              MyTextField(
                textt: "E-Posta",
                controller: _emailControllersecretary,
                onchanged: (value) {},
              ),
              const SizedBox(height: 10),
              MyTextField(
                textt: "Şifre",
                controller: _passwordControllersecretary,
                onchanged: (value) {},
              ),
              const SizedBox(height: 20),
              MyButton(
                buttonclick: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/homeadvisor',
                    (route) => false,
                  );
                },
                buttontext: "Giriş Yap",
                textcolor: Colors.white,
                backcolor: const Color(0xFF0EBE80),
                height: 54,
                width: double.infinity,
              ),
              const SizedBox(height: 20),
              Image.asset('assets/secretary2.jpg'),
            ],
          ),
        ),
      );
    }

    // DANIŞMAN / DOKTOR / DİĞER GİRİŞLERİN DEFAULT'U
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            MyTextField(
              textt: "E-Posta",
              controller: _emailControllerdoctor,
              onchanged: (value) {},
            ),
            const SizedBox(height: 10),
            MyTextField(
              textt: "Şifre",
              controller: _passwordControllerdoctor,
              onchanged: (value) {},
            ),
            const SizedBox(height: 20),
            MyButton(
              buttonclick: () {
                Navigator.pop(context);
              },
              buttontext: "Giriş Yap",
              textcolor: Colors.white,
              backcolor: Colors.blue,
              height: 54,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
