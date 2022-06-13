import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:services_catalog/entities/provider_model.dart';
import 'package:services_catalog/provider_detail_screen.dart';

class DetailDialog extends StatelessWidget {
  final ProviderModel provider;

  const DetailDialog({Key? key, required this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            // Bottom rectangular box
            margin: const EdgeInsets.only(top: 40),
            // to push the box half way below circle
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
            // spacing inside the box
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  provider.name,
                  style: textTheme.headline5,
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  provider.serviceType,
                  style: textTheme.bodyText2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  provider.about,
                  style: textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                ButtonBar(
                  buttonMinWidth: 100,
                  alignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    TextButton(
                      child: const Text("show more"),
                      onPressed: () => {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProviderDetailScreen(provider),
                          ),
                        ),
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          CircleAvatar(
            // Top Circle with icon
            maxRadius: 40.0,
            child: ClipOval(
              child: Material(
                color: Colors.transparent,
                child: Ink.image(
                  image: FirebaseImage(provider.imagePath),
                  fit: BoxFit.cover,
                  width: 128,
                  height: 128,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
