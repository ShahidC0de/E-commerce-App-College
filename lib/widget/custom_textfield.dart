import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController textEditingController;
  final Widget prefixIcon;
  final TextInputType textInputType;
  const CustomTextField(
      {super.key,
      required this.textEditingController,
      required this.prefixIcon,
      required this.hintText,
      required this.textInputType});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(40),
      ),
      height: 60,
      width: 300,
      child: TextFormField(
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        controller: textEditingController,
        keyboardType: textInputType,
        decoration: InputDecoration(
            //decoration of textformfield.
            //EMAIL TEXTFORM FILED
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Colors.white,
            ),
            prefixIcon: prefixIcon,
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.lightBlueAccent,
              ),
              borderRadius: BorderRadius.circular(40.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                width: 2,
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(40.0),
            )),
      ),
    );
  }
}
