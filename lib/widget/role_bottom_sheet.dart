import 'package:flutter/material.dart';
import 'package:hasta_takip/widget/meeting_bottom_sheet.dart';
import 'package:hasta_takip/widget/show_dialog.dart';

void showRoleBottomSheet(BuildContext context, String userType) {
  final type = userType.toLowerCase(); // küçük-büyük farkı olmasın

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      // danışman
      if (type == "danışman" || type == "danisman") {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.calendar_today, color: Colors.teal),
              title: const Text("Randevu Ekle"),
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25),
                    ),
                  ),
                  builder: (context) =>
                      const MyBottomSheet(userType: "Danışman"),
                );
              },
            ),
          ],
        );
      }

      // geliştirici
      if (type == "geliştirici" ||
          type == "gelistirici" ||
          type == "developer") {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.person_add, color: Colors.blue),
              title: const Text("Danışman / Doktor Ekle"),
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25),
                    ),
                  ),
                  builder: (context) =>
                      const MyBottomSheet(userType: "Geliştirici"),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.medical_services, color: Colors.green),
              title: const Text("Klinik Ekle"),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => ShowDialog(title: "Hizmet Türü Ekle"),
                );
              },
            ),
          ],
        );
      }

      // doktor
      if (type == "doktor" || type == "doctor") {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.calendar_month, color: Colors.green),
              title: const Text("Muayene Randevusu Ekle"),
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25),
                    ),
                  ),
                  builder: (context) => const MyBottomSheet(userType: "Doktor"),
                );
              },
            ),
          ],
        );
      }

      // hiçbirine uymadıysa
      return const SizedBox.shrink();
    },
  );
}
