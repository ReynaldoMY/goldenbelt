import 'dart:convert';

gb_notification notificationFromJson(String str) => gb_notification.fromJson(json.decode(str));
String gb_tnotificationToJson(gb_notification data) => json.encode(data.toJson());

class gb_notification {

  String? notification_type;
  String? tentity_type;
  String? tentity_id;
  String? tgroup_id;
  String? group_image;
  String? groupname;
  String? last_datetime;

  List<gb_notification> toList = [];

  gb_notification({
    this.notification_type,
    this.tentity_type,
    this.tentity_id,
    this.tgroup_id,
    this.group_image,
    this.groupname,
    this.last_datetime
  })
  {
    notification_type = this.notification_type ?? "";
    tentity_type = this.tentity_type ?? "";
    tentity_id = this.tentity_id ?? "";
    tgroup_id = this.tgroup_id ?? "0";
    group_image = this.group_image ?? "";
    groupname = this.groupname ?? "";
    last_datetime = this.last_datetime ?? "";
  }

  factory gb_notification.fromJson(Map<String, dynamic> json) =>
      gb_notification(
          notification_type: json["notification_type"].toString(),
          tentity_type: json["tentity_type"].toString(),
          tentity_id: json["tentity_id"].toString(),
          tgroup_id: json["tgroup_id"].toString(),
          group_image: json["group_image"].toString(),
          groupname: json["groupname"].toString(),
          last_datetime: json["last_datetime"].toString()
      );

  gb_notification.fromJsonList(List<dynamic> jsonList) {

    jsonList.forEach((item)
    {
      gb_notification lo_tnotification = gb_notification.fromJson(item);
      toList.add(lo_tnotification);
    });
    return;
  }

  Map<String, dynamic> toJson() => {
    "notification_type": notification_type,
    "tentity_type": tentity_type,
    "tentity_id": tentity_id,
    "tgroup_id": tgroup_id,
    "group_image": group_image,
    "groupname": groupname,
    "last_datetime": last_datetime
  };

}
