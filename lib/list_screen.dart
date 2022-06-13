import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:services_catalog/di.dart';
import 'package:services_catalog/entities/provider_model.dart';
import 'package:services_catalog/provider_detail_screen.dart';
import 'package:services_catalog/widgets/service_icon.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final di = GetIt.I.get<DI>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Results"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<Iterable<ProviderModel>>(
          stream: di.searchBloc.filteredProvidersStream,
          builder: (context, snapshot) {
            return ListView(
              children: snapshot.data?.map((provider) {
                return _buildListTile(context, provider);
              }).toList() ?? [],
            );
          },
        ),
      )
    );
  }

  static Widget _buildListTile(BuildContext context, ProviderModel provider) {
    return ListTile(
      leading: ServiceIcon(serviceName: provider.serviceType,
        color: Colors.red,
        size: 25,
      ),
      title: Text(provider.name),
      subtitle: Text(provider.address),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return ProviderDetailScreen(provider);
            },
          ),
        );
      },
    );
  }
}
