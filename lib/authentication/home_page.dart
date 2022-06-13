import 'package:flutter/material.dart';
import 'package:services_catalog/map_screen.dart';
import 'package:services_catalog/sidebar/sidebar.dart';


class HomePage extends StatelessWidget {
  static const String id = "home";

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      drawer: SideBar(),
      body: MapScreen(),
    );
  }
}