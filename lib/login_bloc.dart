import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:services_catalog/entities/provider_model.dart';

class LoginBloc {
  static Stream<ProviderModel?> currentUserStream(final CollectionReference<ProviderModel> providerModelCollection) {
    var sos = FirebaseAuth.instance.userChanges().map((user) {
      if (user == null) {
        print("nulluser");
        return Stream.value(null);
      }

      print("got provider");
      return providerModelCollection.doc(user.uid).snapshots().map((event) => event.data());

    });
    return Rx.switchLatest(sos);
  }
}