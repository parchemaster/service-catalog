
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:services_catalog/entities/provider_model.dart';
import 'package:services_catalog/sidebar/page/user_page/specialist_popup.dart';

class ProviderDetailScreen extends StatelessWidget {

  static const routeName = '/provider-detail-screen';
  final ProviderModel model;

  const ProviderDetailScreen(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Provider detail"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.phone),
        onPressed: () => launchUrl(Uri.parse("tel:${model.phone}")),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SpecialistPage(model: model),
          ],
        ),
      ),
    );
  }
}
