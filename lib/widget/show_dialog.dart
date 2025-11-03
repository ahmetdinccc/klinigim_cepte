import 'package:flutter/material.dart';
import 'package:hasta_takip/widget/button.dart';
import 'package:hasta_takip/widget/text_field.dart';

class ShowDialog extends StatelessWidget {
  final String title;

  const ShowDialog({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final TextEditingController hizmetController = TextEditingController();

    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyTextField(
            text: "Hizmet Adı",
            controller: hizmetController,
            onchanged: (value) {},
          ),
          SizedBox(height: 10),
          MyButton(
            buttonclick: () {},
            buttontext: "Kaydet",
            textcolor: Colors.white,
            backcolor: const Color(0xFF0EBE80),
            height: 54,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
