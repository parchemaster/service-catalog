import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:services_catalog/widgets/service_icon.dart';

class CircularMarker extends Marker {
  CircularMarker(
      {required LatLng point, void Function()? onTap, String label = ""})
      : super(
          point: point,
          builder: _widgetBuilder(label, onTap),
          rotate: true,
          anchorPos: AnchorPos.align(AnchorAlign.center),
        );

  static Widget Function(BuildContext) _widgetBuilder(
      String s, void Function()? onTap) {
    return (BuildContext context) {
      return GestureDetector(
        child: CircleAvatar(
          child: ServiceIcon(
            serviceName: s,
            color: Colors.white,
          ),
          backgroundColor: Colors.red.withAlpha(225),
        ),
        onTap: onTap,
      );
    };
  }
}
