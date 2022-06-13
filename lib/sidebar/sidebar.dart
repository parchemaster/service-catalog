import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:services_catalog/di.dart';
import 'package:services_catalog/entities/provider_model.dart';
import 'package:services_catalog/sidebar/menu/sidebar_menu.dart';


class SideBar extends StatelessWidget {
  final padding = const EdgeInsets.symmetric(horizontal: 20);

  const SideBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ProviderModel?>(
      stream: GetIt.I.get<DI>().currentUserStream,
      builder: (context, snapshot) {
        return SideBarMenu(padding: padding, providerModel: snapshot.data);
      },
    );
  }
}
