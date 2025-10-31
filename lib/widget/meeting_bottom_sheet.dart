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

  String? selectedDoctor; // seçilen doktor dropdown değeri
  String? selectedService; // seçilen hizmet dropdown değeri

  // Doktor kontrolörleri
  final TextEditingController _emailControllerdoctor = TextEditingController();
  final TextEditingController _passwordControllerdoctor =
      TextEditingController();
  final TextEditingController _adControllerdoctor = TextEditingController();
  final TextEditingController _noControllerdoctor = TextEditingController();

  // Danışman / Hasta kontrolörleri
  final TextEditingController _tcControllersick = TextEditingController();
  final TextEditingController _passwordControllersecretary =
      TextEditingController();
  final TextEditingController _adControllersick = TextEditingController();
  final TextEditingController _noControllersick = TextEditingController();

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
            "${widget.userType} ",
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
              Tab(text: "Randevu Al"),
              Tab(text: "Randevu Geçmişi"),
            ],
          ),

          // içerik
          //İçerik
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildmeetingTab(), // Ortak login ekranı
                _buildpastappointmentTab(), // Kullanıcı türüne göre farklı register
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ RANDEVU AL TAB’I
  Widget _buildmeetingTab() {
    // HASTA RANDEVU GİRİŞİ
    final items1 = ['Ahmet Dinç', 'Rüştü Dinç', 'Mehmet Ak', 'Ali Veli'];
    final items2 = ['Genel Muayene', 'Diş Temizliği', 'Dolgu', 'Kontrol'];
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            MyTextField(
              text: "TC Kimlik No",
              controller: _tcControllersick,
              onchanged: (value) {},
            ),
            const SizedBox(height: 10),
            MyTextField(
              text: "Ad Soyad",
              controller: _adControllersick,
              onchanged: (value) {},
            ),
            const SizedBox(height: 10),
            MyTextField(
              text: "Telefon Numarası",
              controller: _noControllersick,
              onchanged: (value) {},
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedDoctor,
              decoration: InputDecoration(
                labelText: "Doktor Seçiniz",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items: items1
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedDoctor = value;
                });
              },
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: selectedService,
              decoration: InputDecoration(
                labelText: "Hizmet Türü Seçiniz",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items: items2
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedService = value;
                });
              },
            ),
            const SizedBox(height: 10),
            MyButton(
              buttonclick: () {},
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

  // ✅ RANDEVU GEÇMİŞİ TAB’I
  Widget _buildpastappointmentTab() {
    // HASTA RANDEVU GEÇMİŞİ

    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            MyTextField(
              text: "TC Kimlik No",
              controller: _tcControllersick,
              onchanged: (value) {},
            ),
            const SizedBox(height: 10),

            MyButton(
              buttonclick: () {},
              buttontext: "Geçmiş Randevuları Gör",
              textcolor: Colors.white,
              backcolor: const Color(0xFF0EBE80),
              height: 54,
              width: double.infinity,
            ),
            const SizedBox(height: 20),
            Image.asset('assets/sick2.jpg'),
          ],
        ),
      ),
    );
  }
}
