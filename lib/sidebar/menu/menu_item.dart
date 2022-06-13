import 'package:flutter/material.dart';

class SideMenuItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback? onClicked;
  final color = const Color.fromRGBO(93, 107, 89, 42);
  final hoverColor = const Color.fromRGBO(93, 107, 89, 42);

  const SideMenuItem({Key? key, required this.text, required this.icon, this.onClicked}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

}