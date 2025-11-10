import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:hasta_takip/widget/role_bottom_sheet.dart';

class HomeDeveloper extends StatefulWidget {
  const HomeDeveloper({super.key});

  @override
  State<HomeDeveloper> createState() => _HomeDeveloperState();
}

class _HomeDeveloperState extends State<HomeDeveloper> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text("Oturum bulunamadı.")));
    }

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('developers')
          .doc(user.uid)
          .get(),
      builder: (context, snapshot) {
        // Hata
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                "Veri alınırken hata oluştu: ${snapshot.error}",
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        // Doküman yoksa
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Scaffold(
            body: Center(
              child: Text(
                "Geliştirici profili bulunamadı.\n(Firestore: developers/{uid})",
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        // Başarılı: isim çek
        final data = snapshot.data!.data() as Map<String, dynamic>;
        final name = (data['name'] ?? '') as String;

        return Scaffold(
          backgroundColor: const Color(0xFFE3E3E3),

          appBar: AppBar(
            backgroundColor: const Color(0xFF0EBE80),
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: const Text(
              "Kliniğim Cepte",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hoş geldin, $name 👋",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),

                // İstatistik kartları
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _istatistikKarti("Toplam Hasta", "24", Icons.people_alt),
                    _istatistikKarti(
                      "Bugün Randevu",
                      "5",
                      Icons.calendar_today,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _istatistikKarti("Bekleyen İşlem", "3", Icons.timer),
                    _istatistikKarti("Tamamlanan", "18", Icons.check_circle),
                  ],
                ),

                const SizedBox(height: 32),

                const Text(
                  "Bugünkü Randevular",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),

                // buraya randevu listesi vs gelecek
              ],
            ),
          ),

          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            selectedItemColor: const Color(0xFF0EBE80),
            unselectedItemColor: Colors.grey,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Ana Sayfa",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.message),
                label: "Mesajlar",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Profil",
              ),
            ],
          ),

          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showRoleBottomSheet(context, "geliştirici");
            },
            backgroundColor: const Color(0xFF0EBE80),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }

  // Yardımcı widget
  Widget _istatistikKarti(String baslik, String deger, IconData ikon) {
    return Container(
      width: 165,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(ikon, color: const Color(0xFF0EBE80), size: 26),
            const SizedBox(height: 8),
            Text(
              baslik,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            Text(
              deger,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0EBE80),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
