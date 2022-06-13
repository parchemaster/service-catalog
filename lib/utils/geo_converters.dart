import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

LatLng toLatLng(GeoPoint geoPoint) {
  return LatLng(geoPoint.latitude, geoPoint.longitude);
}