import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:services_catalog/authentication/add_user_page.dart';
import 'package:services_catalog/di.dart';
import 'package:services_catalog/entities/provider_model.dart';
import 'package:services_catalog/my_color.dart';
import 'package:services_catalog/sidebar/widget/carousel/carousel_slider.dart';
import 'package:services_catalog/sidebar/widget/user_widget/profile_widget.dart';

class UserProfilePage extends StatelessWidget {


  const UserProfilePage({
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: MyColor.textColor,
      ),

      body: StreamBuilder<ProviderModel?>(
          stream: GetIt.I.get<DI>().currentUserStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null) {
              return Container();
            }
            final providerModel = snapshot.data!;

            return ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                ProfileWidget(
                  imagePath: providerModel.imagePath,
                  isEdit: true,
                  onClicked: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddUserPage(providerModel: providerModel,)
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                Column(
                  children: [
                    Text(
                      providerModel.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 4),

                    Text(
                      providerModel.email,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 30),

                    Text(
                      providerModel.about,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),

                CarouselSliderWidget(uid: providerModel.id, urlList: providerModel.pictureUrls.split(";")),


                const SizedBox(height: 24),
              ],
            );
          }
      ),
    );
  }
}