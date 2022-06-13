import 'package:flutter/material.dart';
import 'package:services_catalog/sidebar/widget/carousel/carousel_slider.dart';
import 'package:services_catalog/sidebar/widget/user_widget/profile_widget.dart';

import 'package:services_catalog/entities/provider_model.dart';

class SpecialistPage extends StatelessWidget {
  static const routeName = '/provider-detail-screen';
  final ProviderModel model;

  const SpecialistPage({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: model.imagePath,
            onClicked: () {},
            isEdit: false
          ),

          const SizedBox(height: 24),

          Column(
            children: [
              Text(
                model.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 4),

              Text(
                model.email,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),

              Text(
                model.about,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),

          CarouselSliderWidget(uid: model.id, urlList: model.pictureUrls.split(";")),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}