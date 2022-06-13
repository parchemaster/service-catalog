// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProviderModel _$ProviderModelFromJson(Map<String, dynamic> json) =>
    ProviderModel(
      id: json['id'] as String? ?? "",
      name: json['name'] as String? ?? "",
      address: json['address'] as String? ?? "",
      serviceType: json['serviceType'] as String? ?? "",
      about: json['about'] as String? ?? "",
      geopoint: json['geopoint'] == null
          ? const GeoPoint(0, 0)
          : identity(json['geopoint'] as GeoPoint),
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      imagePath: json['imagePath'] as String? ?? '',
      pictureUrls: json['pictureUrls'] as String? ?? '',
    );

Map<String, dynamic> _$ProviderModelToJson(ProviderModel instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'name': instance.name,
    'address': instance.address,
    'serviceType': instance.serviceType,
    'about': instance.about,
    'phone': instance.phone,
    'email': instance.email,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('geopoint', identity(instance.geopoint));
  val['imagePath'] = instance.imagePath;
  val['pictureUrls'] = instance.pictureUrls;
  return val;
}
