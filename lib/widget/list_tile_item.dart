import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final Icon leadingIcon;

  const CustomListTile(
      {super.key, this.onTap, required this.leadingIcon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          tileColor: Colors.grey,
          leading: leadingIcon,
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Divider(
          color: Colors.white,
        )
      ],
    );
  }
}
