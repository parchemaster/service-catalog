import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'provider_model.g.dart';

GeoPoint identity(GeoPoint value) {
  return value;
}


@JsonSerializable(explicitToJson: true, includeIfNull: false)
class ProviderModel {
  @JsonKey(name: 'id')
  String id;
  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'address')
  String address;
  @JsonKey(name: 'serviceType')
  String serviceType;
  @JsonKey(name: 'about')
  String about;
  @JsonKey(name: 'phone', defaultValue: "")
  String phone;
  @JsonKey(name: 'email', defaultValue: "")
  String email;
  @JsonKey(name: 'geopoint', toJson: identity, fromJson: identity)
  GeoPoint geopoint;
  @JsonKey(name: 'imagePath', defaultValue: "")
  String imagePath;
  @JsonKey(name: 'pictureUrls', defaultValue: "")
  String pictureUrls;


  ProviderModel.id(this.name, this.address, this.serviceType, this.geopoint, this.phone, this.email, this.imagePath, this.about, this.pictureUrls) : id = const Uuid().v1();

  ProviderModel({this.id = "", this.name = "", this.address = "", this.serviceType = "", this.about = "", this.geopoint = const GeoPoint(0, 0), this.phone = "", this.email = "", this.imagePath = "", this.pictureUrls = ""});

  factory ProviderModel.fromJson(Map<String, dynamic> json) => _$ProviderModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProviderModelToJson(this);

}
