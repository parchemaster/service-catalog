import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:services_catalog/entities/provider_model.dart';


class SearchBloc {
  final Sink<String> _onFilterTextChanged;
  final BehaviorSubject<Iterable<ProviderModel>> filteredProvidersStream;
  int numOfResults = 0;

  void updateFilter(String term) => _onFilterTextChanged.add(term);

  factory SearchBloc(CollectionReference<ProviderModel> providers) {
    final Stream<Iterable<ProviderModel>> snapshots = providers.snapshots()
        .map((event) {
      return event.docs.map((e) {
        return e.data();
      });
    });

    final onTextChanged = PublishSubject<String>();

    final textStream = onTextChanged
        .distinct()
        .debounceTime(const Duration(milliseconds: 250))
        .startWith("");

    final filteredProvidersStream = Rx.combineLatest2(
      snapshots,
      textStream,
      (Iterable<ProviderModel> snapshot, String text) {
        if (text.isEmpty) return snapshot;
        text = text.toLowerCase();

        return snapshot.where(
          (element) {
            return element.serviceType.toLowerCase().startsWith(text) ||
              element.name.toLowerCase().contains(text) ||
              element.about.toLowerCase().contains(text);
          },
        );
      },
    );

    final filteredProvidersBS = BehaviorSubject<Iterable<ProviderModel>>();
    filteredProvidersBS.addStream(filteredProvidersStream);

    return SearchBloc._(onTextChanged, filteredProvidersBS);
  }

  SearchBloc._(this._onFilterTextChanged, this.filteredProvidersStream) {
    filteredProvidersStream.forEach((element) => numOfResults = element.length);
  }

  void dispose() {
    _onFilterTextChanged.close();
  }

}
