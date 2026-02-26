import 'package:flutter/material.dart';
import 'package:hasta_takip/widget/role_bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // 🔹 FİREBASE'DEN VERİLERİ ÇEKEN ANA FONKSİYON
  Future<Map<String, dynamic>> _fetchAdvisorAndClinicData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw "Kullanıcı oturumu bulunamadı.";

    // 1. ADIM: 'advisors' koleksiyonundan danışman bilgilerini çek
    final advisorSnap = await FirebaseFirestore.instance
        .collection('advisors')
        .doc(user.uid)
        .get();

    if (!advisorSnap.exists) throw "Danışman profili bulunamadı.";

    final advisorData = advisorSnap.data() as Map<String, dynamic>;
    final String name = advisorData['name'] ?? 'İsimsiz Danışman';
    final String? clinicId = advisorData['clinicId']; // Resimdeki: "HGcF4Tq..."

    String clinicName = "Klinik Yükleniyor...";

    // 2. ADIM: Eğer clinicId varsa, 'clinics' koleksiyonuna git
    if (clinicId != null && clinicId.isNotEmpty) {
      final clinicSnap = await FirebaseFirestore.instance
          .collection('clinics')
          .doc(clinicId)
          .get();

      if (clinicSnap.exists) {
        final clinicData = clinicSnap.data() as Map<String, dynamic>;
        // GÖRÜNTÜDEKİ KEY: 'clinicname' (Küçük harf olduğuna dikkat!)
        clinicName = clinicData['clinicname'] ?? "İsimsiz Klinik";
      } else {
        clinicName = "Klinik Bulunamadı";
      }
    }

    return {'advisorName': name, 'clinicDisplayName': clinicName};
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchAdvisorAndClinicData(),
      builder: (context, snapshot) {
        // Veri beklenirken yükleme ekranı
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF0EBE80)),
            ),
          );
        }

        // Hata oluşursa
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text("Hata: ${snapshot.error}")));
        }

        final data = snapshot.data!;
        final String finalClinicName = data['clinicDisplayName'];
        final String finalAdvisorName = data['advisorName'];

        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 227, 227, 227),
          appBar: AppBar(
            backgroundColor: const Color(0xFF0EBE80),
            centerTitle: true,
            title: Text(
              finalClinicName,
              style: const TextStyle(
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
                  "Hoş geldin, $finalAdvisorName 👋",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Günlük hasta akışını buradan takip edebilirsin.",
                  style: TextStyle(color: Colors.black54, fontSize: 15),
                ),
                const SizedBox(height: 24),

                // İstatistik Kartları
                Row(
                  children: [
                    Expanded(
                      child: _istatistikKarti(
                        "Toplam Hasta",
                        "24",
                        Icons.people_alt,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _istatistikKarti(
                        "Bugün Randevu",
                        "5",
                        Icons.calendar_today,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _istatistikKarti(
                        "Bekleyen İşlem",
                        "3",
                        Icons.timer,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _istatistikKarti(
                        "Tamamlanan",
                        "18",
                        Icons.check_circle,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),
                const Text(
                  "Bugünkü Randevular",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                _hastaKart("Rüştü Dinç", "10:00 - Diş Temizliği"),
                _hastaKart("Furkan Uyar", "11:30 - Kontrol"),
                _hastaKart("Kasım Kalaycı", "14:00 - Kanal Tedavisi"),
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
            onPressed: () => showRoleBottomSheet(context, "danışman"),
            backgroundColor: const Color(0xFF0EBE80),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }

  // --- Yardımcı Widgetlar ---
  Widget _istatistikKarti(String baslik, String deger, IconData ikon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Icon(ikon, color: const Color(0xFF0EBE80), size: 26),
          const SizedBox(height: 6),
          Text(
            baslik,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black54,
              fontSize: 13,
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
    );
  }

  Widget _hastaKart(String isim, String detay) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(isim, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(detay),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: () {
          // Hasta detay sayfasına yönlendirme kodu buraya gelecek
        },
      ),
    );
  }
}
