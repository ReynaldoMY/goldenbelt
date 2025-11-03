import 'dart:convert';
import 'package:flutter/material.dart';

gb_inbox gbInboxFromJson(String str) => gb_inbox.fromJson(json.decode(str));
String gbInboxToJson(gb_inbox data) => json.encode(data.toJson());

class gb_inbox
{
  String? id;
  String? parent_id;
  String? refcode;
  String? value;
  String? icon;
  String? open;
  String? is_group;
  String? gb_type;
  Color? backgroundcolor;
  int count_pending = 0;
  List<gb_inbox>? data;

  List<gb_inbox> toList = [];

  gb_inbox({
    required this.id,
    required this.parent_id,
    required this.refcode,
    required this.value,
    required this.icon,
    required this.open,
    required this.is_group,
    required this.gb_type,
    required this.data
  });

  factory gb_inbox.fromJson(Map<String, dynamic> json) =>
      gb_inbox(
          id: json["id"].toString(),
          parent_id: json["parent_id"].toString(),
          refcode: json["refcode"].toString(),
          value: json["value"].toString(),
          icon: json["icon"].toString(),
          open: json["open"].toString(),
          is_group: json["is_group"].toString(),
          gb_type: json["gb_type"].toString(),
          data: json["data"] == null ? null : List<gb_inbox>.from(json["data"].map((x) => gb_inbox.fromJson(x)))
      );

  gb_inbox.fromJsonList(List<dynamic> jsonList) {

    jsonList.forEach((item)
    {
      gb_inbox lo_gb_inbox = gb_inbox.fromJson(item);
      toList.add(lo_gb_inbox);
    });

    return;
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "parent_id": parent_id,
    "refcode": refcode,
    "value": value,
    "icon": icon,
    "open": open,
    "is_group": is_group,
    "gb_type": gb_type,
    "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}
