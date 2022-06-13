import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:rxdart/rxdart.dart';
import 'package:services_catalog/entities/provider_model.dart';
import 'package:services_catalog/login_bloc.dart';
import 'package:services_catalog/search_bloc.dart';
import 'package:injectable/injectable.dart';


@singleton
class DI {
  final SearchBloc searchBloc;
  final Stream<ProviderModel?> currentUserStream;
  final CollectionReference<ProviderModel> providerModelCollection;
  MapController? mapController;

  factory DI() {
    final _providersCollection = FirebaseFirestore.instance
        .collection('providers')
        .withConverter<ProviderModel>(
      fromFirestore: (document, options) =>
          ProviderModel.fromJson(document.data()!),
      toFirestore: (model, options) => model.toJson(),
    );

    var _currentUserStream = BehaviorSubject<ProviderModel?>();
    _currentUserStream.addStream(LoginBloc.currentUserStream(_providersCollection));

    return DI._(SearchBloc(_providersCollection), _currentUserStream, _providersCollection);
  }

  DI._(this.searchBloc, this.currentUserStream, this.providerModelCollection);

  @disposeMethod
  void dispose() {
    searchBloc.dispose();
  }
}