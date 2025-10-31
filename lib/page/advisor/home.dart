import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0EBE80),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Kliniğim Cepte",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      // 🔹 Sayfa içeriği
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Hoş geldin, Ahmet 👋",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Bugün randevularını aşağıdan takip edebilirsin.",
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
            const SizedBox(height: 24),

            // 🔸 İstatistik kartları
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _istatistikKarti("Toplam Hasta", "24", Icons.people_alt),
                _istatistikKarti("Bugün Randevu", "5", Icons.calendar_today),
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

            _hastaKart("Rüştü Dinç", "10:00 - Diş Temizliği"),
            _hastaKart("Furkan Uyar", "11:30 - Kontrol"),
            _hastaKart("Kasım Kalaycı", "14:00 - Kanal Tedavisi"),

            const SizedBox(height: 40),

            Center(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  "Yeni Randevu Ekle",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0EBE80),
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),

      // 🔹 Alt navigasyon menüsü
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Ana Sayfa"),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "Mesajlar"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }

  // 🔹 Yardımcı widgetlar

  Widget _istatistikKarti(String baslik, String deger, IconData ikon) {
    return Container(
      width: 165,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
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

  Widget _hastaKart(String isim, String detay) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(isim, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(detay),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: () {},
      ),
    );
  }
}
