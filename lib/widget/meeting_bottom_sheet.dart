import 'package:flutter/material.dart';
import 'package:hasta_takip/widget/button.dart';
import 'package:hasta_takip/widget/text_field.dart';

class MyBottomSheet extends StatefulWidget {
  /// "Danışman" | "Doktor" | "Hasta" | "Geliştirici"
  final String userType;

  const MyBottomSheet({super.key, required this.userType});

  @override
  State<MyBottomSheet> createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // ortak dropdown
  String? selectedDoctor;
  String? selectedService;

  // hasta / danışman form controller’ları
  final _tcController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  // geliştirici – danışman/doktor ekleme
  final _devAdvisorName = TextEditingController();
  final _devAdvisorEmail = TextEditingController();
  final _devAdvisorPass = TextEditingController();

  final _devDoctorName = TextEditingController();
  final _devDoctorEmail = TextEditingController();
  final _devDoctorPass = TextEditingController();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _tcController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _devAdvisorName.dispose();
    _devAdvisorEmail.dispose();
    _devAdvisorPass.dispose();
    _devDoctorName.dispose();
    _devDoctorEmail.dispose();
    _devDoctorPass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final role = widget.userType.toLowerCase();
    final isDeveloper =
        role == 'geliştirici' || role == 'gelistirici' || role == 'developer';

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
            "Danışman / Doktor Ekle",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          if (isDeveloper)
            TabBar(
              controller: _tabController,
              labelColor: Colors.teal,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.teal,
              tabs: const [
                Tab(text: "Danışman Ekle"),
                Tab(text: "Doktor Ekle"),
              ],
            )
          else
            TabBar(
              controller: _tabController,
              labelColor: Colors.teal,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.teal,
              tabs: const [
                Tab(text: "Randevu Al"),
                Tab(text: "Randevu Geçmişi"),
              ],
            ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: isDeveloper
                  ? [
                      _buildDanismanDoktorUserForm(), // Danışman / Doktor Ekle
                      _buildDoktorUserForm(), // Klinik Ekle
                    ]
                  : [
                      _buildMeetingTab(role), // Randevu Al
                      _buildHistoryTab(role), // Randevu Geçmişi
                    ],
            ),
          ),
        ],
      ),
    );
  }

  //randevu ekleme tabı
  Widget _buildMeetingTab(String role) {
    final doctorItems = ['Ahmet Dinç', 'Rüştü Dinç', 'Mehmet Ak', 'Ali Veli'];
    final serviceItems = ['Genel Muayene', 'Diş Temizliği', 'Dolgu', 'Kontrol'];
    final Items = ['doktor', 'danışman'];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            MyTextField(
              text: role == 'doktor' ? "Hasta TC Kimlik No" : "TC Kimlik No",
              controller: _tcController,
              onchanged: (_) {},
            ),
            const SizedBox(height: 10),
            MyTextField(
              text: role == 'doktor' ? "Hasta Ad Soyad" : "Ad Soyad",
              controller: _nameController,
              onchanged: (_) {},
            ),
            const SizedBox(height: 10),
            MyTextField(
              text: "Telefon Numarası",
              controller: _phoneController,
              onchanged: (_) {},
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedDoctor,
              decoration: InputDecoration(
                labelText: "Doktor Seçiniz",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: doctorItems
                  .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  selectedDoctor = val;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedService,
              decoration: InputDecoration(
                labelText: "Hizmet Türü Seçiniz",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: serviceItems
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  selectedService = val;
                });
              },
            ),
            const SizedBox(height: 20),
            MyButton(
              buttonclick: () {
                // TODO: randevu kaydı
              },
              buttontext: "Randevu Oluştur",
              textcolor: Colors.white,
              backcolor: const Color(0xFF0EBE80),
              height: 54,
              width: double.infinity,
            ),
            const SizedBox(height: 20),
            Image.asset('assets/sick.jpg'),
          ],
        ),
      ),
    );
  }

  //randevu geçmişi tabı
  Widget _buildHistoryTab(String role) {
    // danışman
    if (role == 'danışman' || role == 'danisman' || role == 'advisor') {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            MyTextField(
              text: "Hasta TC / Ad",
              controller: _tcController,
              onchanged: (_) {},
            ),
            const SizedBox(height: 10),
            MyButton(
              buttonclick: () {},
              buttontext: "Geçmiş Randevuları Getir",
              textcolor: Colors.white,
              backcolor: const Color(0xFF0EBE80),
              height: 54,
              width: double.infinity,
            ),
            const SizedBox(height: 20),
            Image.asset('assets/sick2.jpg'),
          ],
        ),
      );
    }

    // hasta veya diğer
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          MyTextField(
            text: "Hasta TC / Ad",
            controller: _tcController,
            onchanged: (_) {},
          ),
          const SizedBox(height: 10),
          MyButton(
            buttonclick: () {},
            buttontext: "Geçmiş Randevuları Getir",
            textcolor: Colors.white,
            backcolor: const Color(0xFF0EBE80),
            height: 54,
            width: double.infinity,
          ),
          const SizedBox(height: 20),
          Image.asset('assets/sick2.jpg'),
        ],
      ),
    );
  }

  //GELİŞTİRİCİ DANIŞMAN VEYA DOKTOR EKLE TAB'I
  Widget _buildDanismanDoktorUserForm() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            MyTextField(
              text: "Ad Soyad",
              controller: _devAdvisorName,
              onchanged: (_) {},
            ),
            const SizedBox(height: 10),
            MyTextField(
              text: "E-Posta",
              controller: _devAdvisorEmail,
              onchanged: (_) {},
            ),
            const SizedBox(height: 10),
            MyTextField(
              text: "Geçici Şifre",
              controller: _devAdvisorPass,
              onchanged: (_) {},
            ),
            const SizedBox(height: 10),
            MyButton(
              buttonclick: () {},
              buttontext: "Danışman Oluştur",
              textcolor: Colors.white,
              backcolor: Colors.blue,
              height: 46,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }

  //GELİŞTİRİCİ DOKTOR EKLE TAB'I
  Widget _buildDoktorUserForm() {
    final _clinicName = TextEditingController();
    final _clinicPhone = TextEditingController();
    final _clinicAddress = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            MyTextField(
              text: "Klinik Adı",
              controller: _clinicName,
              onchanged: (_) {},
            ),
            const SizedBox(height: 10),
            MyTextField(
              text: "Telefon",
              controller: _clinicPhone,
              onchanged: (_) {},
            ),
            const SizedBox(height: 10),
            MyTextField(
              text: "Adres",
              controller: _clinicAddress,
              onchanged: (_) {},
            ),
            const SizedBox(height: 20),
            MyButton(
              buttonclick: () {
                // TODO: klinik kaydı
              },
              buttontext: "Klinik Kaydet",
              textcolor: Colors.white,
              backcolor: Colors.teal,
              height: 54,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
