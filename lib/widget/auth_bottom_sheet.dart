import 'package:flutter/material.dart';
import 'package:hasta_takip/widget/button.dart';
import 'package:hasta_takip/widget/text_field.dart';

class AuthBottomSheet extends StatefulWidget {
  final String userType; // "Danışman" veya "Doktor"

  const AuthBottomSheet({super.key, required this.userType});

  @override
  State<AuthBottomSheet> createState() => _AuthBottomSheetState();
}

class _AuthBottomSheetState extends State<AuthBottomSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Doktor kontrolörleri
  final TextEditingController _emailControllerdoctor = TextEditingController();
  final TextEditingController _passwordControllerdoctor =
      TextEditingController();
  final TextEditingController _adControllerdoctor = TextEditingController();
  final TextEditingController _noControllerdoctor = TextEditingController();

  // Danışman kontrolörleri
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

          // Sekmeler
          TabBar(
            controller: _tabController,
            labelColor: Colors.teal,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.teal,
            tabs: const [
              Tab(text: "Giriş Yap"),
              Tab(text: "Kayıt Ol"),
            ],
          ),

          //İçerik
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLoginTab(), // Ortak login ekranı
                _buildRegisterTab(), // Kullanıcı türüne göre farklı register
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ ORTAK GİRİŞ TAB’I
  Widget _buildLoginTab() {
    if (widget.userType == "Danışman") {
      // Danışman giriş formu
      return Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              MyTextField(
                text: "E-Posta",
                controller: _emailControllersecretary,
                onchanged: (value) {},
              ),
              SizedBox(height: 10),
              MyTextField(
                text: "Şifre",
                controller: _passwordControllersecretary,
                onchanged: (value) {},
              ),

              const SizedBox(height: 20),
              MyButton(
                buttonclick: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/homeadvisor',
                    (route) => false, // önceki tüm sayfaları temizle
                  );
                },
                buttontext: "Giriş Yap",
                textcolor: Colors.white,
                backcolor: const Color(0xFF0EBE80),
                height: 54,
                width: double.infinity,
              ),

              Image.asset('assets/secretary1.jpg'),
            ],
          ),
        ),
      );
    } else {
      // Doktor giriş formu
      return Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              MyTextField(
                text: "E-Posta",
                controller: _emailControllerdoctor,
                onchanged: (value) {},
              ),
              SizedBox(height: 10),

              MyTextField(
                text: "Şifre",
                controller: _passwordControllerdoctor,
                onchanged: (value) {},
              ),
              const SizedBox(height: 20),
              MyButton(
                buttonclick: () {},
                buttontext: "Giriş Yap",
                textcolor: Colors.white,
                backcolor: const Color(0xFF02714A),
                height: 54,
                width: double.infinity,
              ),

              Image.asset('assets/doctor1.jpg'),
            ],
          ),
        ),
      );
    }
  }

  //FARKLI KAYIT TAB'LARI
  Widget _buildRegisterTab() {
    if (widget.userType == "Danışman") {
      // Danışman kayıt formu
      return Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              MyTextField(
                text: "Ad - Soyad",
                controller: _adControllersecretary,
                onchanged: (value) {},
              ),
              SizedBox(height: 10),

              MyTextField(
                text: "E-Posta",
                controller: _emailControllersecretary,
                onchanged: (value) {},
              ),
              SizedBox(height: 10),

              MyTextField(
                text: "Telefon Numarası",
                controller: _noControllersecretary,
                onchanged: (value) {},
              ),
              SizedBox(height: 10),

              MyTextField(
                text: "Şifre",
                controller: _passwordControllersecretary,
                onchanged: (value) {},
              ),
              SizedBox(height: 10),

              MyTextField(
                text: "Şifre(Tekrar)",
                controller: _passwordControllersecretary,
                onchanged: (value) {},
              ),
              SizedBox(height: 10),

              const SizedBox(height: 20),
              MyButton(
                buttonclick: () {},
                buttontext: "Kayıt Ol",
                textcolor: Colors.white,
                backcolor: const Color(0xFF0EBE80),
                height: 54,
                width: double.infinity,
              ),
              Image.asset('assets/secretary2.jpg', height: 300),
            ],
          ),
        ),
      );
    } else {
      // Doktor kayıt formu
      return Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              MyTextField(
                text: "Ad - Soyad",
                controller: _adControllerdoctor,
                onchanged: (value) {},
              ),
              SizedBox(height: 10),

              MyTextField(
                text: "E-Posta",
                controller: _emailControllerdoctor,
                onchanged: (value) {},
              ),
              SizedBox(height: 10),

              MyTextField(
                text: "Telefon Numarası",
                controller: _noControllerdoctor,
                onchanged: (value) {},
              ),
              SizedBox(height: 10),

              MyTextField(
                text: "Şifre",
                controller: _passwordControllerdoctor,
                onchanged: (value) {},
              ),
              SizedBox(height: 10),

              MyTextField(
                text: "Şifre(Tekrar)",
                controller: _passwordControllerdoctor,
                onchanged: (value) {},
              ),
              SizedBox(height: 10),

              const SizedBox(height: 20),
              MyButton(
                buttonclick: () {},
                buttontext: "Kayıt Ol",
                textcolor: Colors.white,
                backcolor: const Color.fromARGB(255, 2, 113, 74),
                height: 54,
                width: double.infinity,
              ),

              Image.asset('assets/doctor2.jpg'),
            ],
          ),
        ),
      );
    }
  }
}
