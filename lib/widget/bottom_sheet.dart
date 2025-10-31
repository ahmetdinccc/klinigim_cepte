import 'package:flutter/material.dart';
import 'package:hasta_takip/widget/meeting_bottom_sheet.dart';
import 'package:hasta_takip/widget/show_dialog.dart';

class MyBottomSheet1 extends StatelessWidget {
  const MyBottomSheet1({super.key});

  void showSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.calendar_today, color: Colors.teal),
              title: const Text("Randevu Ekle"),
              onTap: () {
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
            ListTile(
              leading: const Icon(Icons.medical_services, color: Colors.blue),
              title: const Text("Hizmet Türü Ekle"),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => ShowDialog(title: "Hizmet Türü Ekle"),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: () {});
  }
}
