import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get_it/get_it.dart';
import 'package:latlong2/latlong.dart';
import 'package:osm_nominatim/osm_nominatim.dart';
import 'package:services_catalog/di.dart';

import 'package:services_catalog/entities/provider_model.dart';
import 'package:services_catalog/fire_base/storage.dart';
import 'package:services_catalog/my_color.dart';
import 'package:services_catalog/sidebar/widget/user_widget/profile_widget.dart';
import 'package:services_catalog/text_field.dart';


class AddUserPage extends StatefulWidget {
  final ProviderModel? providerModel;

  const AddUserPage({Key? key, this.providerModel}) : super(key: key);

  @override
  State<AddUserPage> createState() => _AddUserPageState();

  static Future createUser(ProviderModel user) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final idUser = auth.currentUser?.uid;
    final docUser = FirebaseFirestore.instance.collection('providers').doc(idUser);
    user.id = docUser.id;
    user.email = auth.currentUser!.email.toString();
    final json = user.toJson();
    await docUser.set(json);
  }
}

class _AddUserPageState extends State<AddUserPage> {
  final controllerName = TextEditingController();
  final controllerServiceType = TextEditingController();
  final controllerAbout = TextEditingController();
  final controllerAddress = TextEditingController();
  final controllerPhone = TextEditingController();

  String _newImage = "gs://" +
      FirebaseStorage.instance.ref().bucket + "/image_for_service_app/profile_image.png";

  set newImage(String value) => setState(() {
    _newImage = value;
  });


  @override
  void initState() {
    super.initState();

    if(widget.providerModel != null) {
      controllerName.text = widget.providerModel!.name;
      controllerServiceType.text = widget.providerModel!.serviceType;
      controllerAbout.text = widget.providerModel!.about;
      controllerAddress.text = widget.providerModel!.address;
      controllerPhone.text = widget.providerModel!.phone;
      _newImage = widget.providerModel?.imagePath ?? "gs://" +
          FirebaseStorage.instance.ref().bucket + "/image_for_service_app/profile_image.png";
    }
  }

  bool isEditingUser() {
    return widget.providerModel != null;
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final idUser = auth.currentUser!.uid;
    final di = GetIt.I.get<DI>();

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditingUser() ? 'Edit User' : 'Add User'),
        automaticallyImplyLeading: isEditingUser(),
        backgroundColor: MyColor.textColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProfileWidget(
                imagePath: _newImage,
                isEdit: true,
                onClicked: () async {
                  final destination = 'files/' + idUser + "/picture_profile";
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

                  final newImagePath = "gs://" +
                      FirebaseStorage.instance.ref().bucket + "/" + destination + "/" + fileName;

                  await Storage()
                      .uploadFile(path, destination, fileName)
                      .then((value) => print('Done'));

                  newImage = newImagePath;
                },
              ),
              MyTextField(controller: controllerName, hintText: "John Smith", labelText: "Name"),

              const SizedBox(height: 12),

              MyTextField(controller: controllerServiceType, hintText: "plumber", labelText: "Type of service"),

              const SizedBox(height: 12),

              MyTextField(controller: controllerPhone, hintText: "+420 111 222 333", labelText: "Phone", keyboardType: TextInputType.phone,),

              const SizedBox(height: 12,),

              Container(
                child: TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: controllerAddress,
                    style: const TextStyle(color: MyColor.textColor),
                    decoration: const InputDecoration(
                      hintText: "New street 25",
                      hintStyle: TextStyle(
                        color: MyColor.textColor,
                      ),
                      labelText: "Address",
                      labelStyle: TextStyle(
                        color: MyColor.textColor,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: MyColor.textColor),
                      ),
                    ),
                  ),
                  suggestionsCallback: (pattern) async {
                    final searchResult = await Nominatim.searchByName(
                      query: pattern,
                      limit: 5,

                      addressDetails: true,
                      extraTags: true,
                      nameDetails: true,
                    );
                    return searchResult;
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text((suggestion as Place).displayName),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    controllerAddress.text = (suggestion as Place).displayName;
                  },
                  hideOnEmpty: true,
                  hideOnLoading: true,
                ),
              ),

              const SizedBox(height: 12),

              MyTextField(controller: controllerAbout, hintText: "Y22 years old, programmer", labelText: "Something about you"),

              const SizedBox(height: 32),

              Container(
                width: 300,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: MyColor.buttonColor,
                ),
                child: MaterialButton(
                  onPressed: () async {
                    if (controllerServiceType.text.isNotEmpty
                        && controllerName.text.isNotEmpty && controllerAddress.text.isNotEmpty) {
                      final place = await Nominatim.searchByName(
                        query: controllerAddress.text,
                        limit: 1,

                        addressDetails: true,
                        extraTags: true,
                        nameDetails: true,
                      );

                      final user = ProviderModel(
                        serviceType: controllerServiceType.text,
                        name: controllerName.text,
                        about: controllerAbout.text,
                        phone: controllerPhone.text,
                        imagePath: _newImage,
                        address: controllerAddress.text,
                        geopoint: GeoPoint(place.first.lat, place.first.lon),
                        pictureUrls: widget.providerModel?.pictureUrls ?? "empty"
                      );
                      await AddUserPage.createUser(user);

                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Account saved successfully")));

                      if(isEditingUser()) {
                        Navigator.of(context).popUntil(
                            ModalRoute.withName(Navigator.defaultRouteName));
                        return;
                      }
                      di.mapController?.moveAndRotate(LatLng(place.first.lat, place.first.lon), 10, 0);
                      Navigator.of(context).pop();
                    }},
                  child: const Text("Save", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
    );
  }
}
