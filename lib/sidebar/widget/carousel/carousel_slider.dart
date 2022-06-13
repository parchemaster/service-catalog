import 'package:file_picker/file_picker.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:services_catalog/authentication/add_user_page.dart';
import 'package:services_catalog/di.dart';
import 'package:services_catalog/entities/provider_model.dart';
import 'package:services_catalog/fire_base/storage.dart';
import 'package:services_catalog/my_color.dart';


class CarouselSliderWidget extends StatelessWidget {
  final String uid;
  static int imageCount = 0;
  final Storage storage = Storage();
  final List<String> urlList;
  CarouselSliderWidget({Key? key, required this.uid, required this.urlList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<ProviderModel?>(
          stream: GetIt.I.get<DI>().currentUserStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null) {
              return Container();
            }

            final providerModel = snapshot.data!;

            if(providerModel.pictureUrls == "empty" && uid == providerModel.id) {
              return addButton(context: context, providerModel: providerModel);
            }

            if (uid == providerModel.id) {
              return Column(
                children: [
                  CarouselSlider.builder(
                    options: CarouselOptions(
                      height: 400,
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.8,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration: const Duration(
                          milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                    ),
                    itemCount: urlList.length,
                    itemBuilder: (context, int itemIndex, int pageViewIndex) {
                      return Image(
                        image: FirebaseImage(urlList[itemIndex]),
                      );
                    },
                  ),
                  addButton(context: context, providerModel: providerModel),
                ],
              );
            }
            else {
              return Column(
                children: [
                  CarouselSlider.builder(
                    options: CarouselOptions(
                      height: 400,
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.8,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration: const Duration(
                          milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                    ),
                    itemCount: urlList.length,
                    itemBuilder: (context, int itemIndex, int pageViewIndex) {
                      return Image(
                        image: FirebaseImage(urlList[itemIndex]),
                      );
                    },
                  ),
                ],
              );
            }

          },

        ),
      ],
    );
  }

  Widget addButton({
    required BuildContext context,
    required ProviderModel providerModel,
  }) =>
      Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: MyColor.buttonColor,
        ),
        child: MaterialButton(
          child: const Text('Add new photo'),
          onPressed: () async {
            final destination = 'files/' + uid + "/picture_gallery";

            final results = await FilePicker.platform.pickFiles(
              allowMultiple: false,
              type: FileType.custom,
              allowedExtensions: ['png', 'jpg'],
            );

            if (results == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No file selected'),
                ),
              );
              return;
            }

            final path = results.files.single.path!;
            final fileName = results.files.single.name;
            final url = "gs://${FirebaseStorage.instance.ref().bucket}/$destination/$fileName";

            if (providerModel.pictureUrls.contains(url)) {
              return;
            }

            await storage.uploadFile(path, destination, fileName);

            if (providerModel.pictureUrls == "empty") {
              providerModel.pictureUrls = url;
            } else {
              providerModel.pictureUrls += ";" + url;
            }

            await AddUserPage.createUser(providerModel);
          },
        ),
      );
}