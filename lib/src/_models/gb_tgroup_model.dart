import 'dart:convert';
import 'package:flutter/material.dart';

gb_tgroup tgroupFromJson(String str) => gb_tgroup.fromJson(json.decode(str));
String tgroupToJson(gb_tgroup data) => json.encode(data.toJson());


class gb_tgroup {
  String? id;
  String? tgroup_id;
  String? groupname;
  String? last_message;
  String? last_datetime;
  String? group_image;
  String? count_chat_pending;
  ImageProvider? image;
  List<gb_tgroup> toList = [];

  gb_tgroup({
    this.id,
    this.tgroup_id,
    this.groupname,
    this.last_message,
    this.last_datetime,
    this.group_image,
    this.count_chat_pending,
    this.image
  })
  {
    id = this.id ?? "0";
    tgroup_id = this.tgroup_id ?? "0";
    groupname = this.groupname ?? "";
    last_message = this.last_message ?? "";
    last_datetime = this.last_datetime ?? "";
    group_image = this.group_image ?? "";
    count_chat_pending = this.count_chat_pending ?? "";
  }

  factory gb_tgroup.fromJson(Map<String, dynamic> json) =>
      gb_tgroup(
          id: json["id"].toString(),
          tgroup_id: json["tgroup_id"].toString(),
          groupname: json["groupname"].toString(),
          last_message: json["last_message"].toString(),
          last_datetime: json["last_datetime"].toString(),
          group_image: json["group_image"].toString(),
          count_chat_pending: json["count_chat_pending"].toString()
      );

  gb_tgroup.fromJsonList(List<dynamic> jsonList) {

    jsonList.forEach((item)
    {
      gb_tgroup lo_tgroup = gb_tgroup.fromJson(item);
      toList.add(lo_tgroup);
    });
    return;
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "tgroup_id": tgroup_id,
    "groupname": groupname,
    "group_image": group_image,
    "count_chat_pending": count_chat_pending
  };
}
