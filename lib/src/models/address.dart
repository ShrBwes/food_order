import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Address {
  int id;
  int userId;
  String fullName;
  String mobile;
  String city;
  String address;
  double latitude;
  double longitude;
  String type;
  bool isDefault;

  Address.empty();

  Address({
    @required this.id,
    @required this.userId,
    @required this.fullName,
    @required this.mobile,
    @required this.city,
    @required this.address,
    @required this.latitude,
    @required this.longitude,
    @required this.type,
    @required this.isDefault,
  });

  Address.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'];
      fullName = jsonMap['full_name'] != null ? jsonMap['full_name'] : null;
      mobile = jsonMap['mobile'] != null ? jsonMap['mobile'] : null;
      city = jsonMap['city'] != null ? jsonMap['city'] : null;
      address = jsonMap['address'] != null ? jsonMap['address'] : 'unknown';
      latitude = jsonMap['latitude'].toDouble();
      longitude = jsonMap['longitude'].toDouble();
      type = jsonMap['type'] != null ? jsonMap['type'] : null;
      isDefault = jsonMap['is_default'] ?? false;
    } catch (e) {
      id = null;
      fullName = '';
      mobile = '';
      city = '';
      address = 'unknown';
      latitude = null;
      longitude = null;
      type = null;
      isDefault = false;
      // print(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['id'] = id;
    map['user_id'] = userId;
    map['name'] = fullName;
    map['mobile'] = mobile;
    map['city'] = city;
    map['address'] = address;
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    map['type'] = type;
    map['is_default'] = isDefault;
    return map;
  }
}
