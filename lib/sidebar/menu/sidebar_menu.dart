import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:services_catalog/authentication/add_user_page.dart';
import 'package:services_catalog/di.dart';
import 'package:services_catalog/entities/provider_model.dart';
import 'package:services_catalog/sidebar/menu/log_out_item.dart';
import 'package:services_catalog/sidebar/page/user_page/user_profil_page.dart';
import 'package:services_catalog/sign_in.dart';


class SideBarMenu extends StatelessWidget {

  final EdgeInsets padding;
  final ProviderModel? providerModel;

  const SideBarMenu({Key? key, required this.padding, this.providerModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: StreamBuilder<ProviderModel?>(
        stream: GetIt.I.get<DI>().currentUserStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return SignIn(padding: padding);
          }
          final providerModel = snapshot.data!;

          return Container(
            padding: const EdgeInsets.only(top: 40),
            child: ListView(
              children: <Widget>[
                Row(
                  children: [
                    Container(
                      padding: padding,
                      child: InkWell(
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: FirebaseImage(providerModel.imagePath),
                        ),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AddUserPage(providerModel: providerModel,)
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const UserProfilePage(),
                        ),
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                providerModel.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Color.fromRGBO(93, 107, 89, 42),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                providerModel.email,
                                overflow: TextOverflow.ellipsis,
                                textWidthBasis: TextWidthBasis.parent,
                                style: const TextStyle(fontSize: 14,
                                  color: Color.fromRGBO(93, 107, 89, 42),
                                ),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.arrow_forward,
                            color: Color.fromRGBO(93, 107, 89, 42),
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                LogOutItem(padding: padding),
              ],
            ),
          );
        },
      ),
    );
  }
}