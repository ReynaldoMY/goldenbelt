import 'dart:convert';

gb_tsession_mobile tgroupFromJson(String str) => gb_tsession_mobile.fromJson(json.decode(str));
String tgroupToJson(gb_tsession_mobile data) => json.encode(data.toJson());

class gb_tsession_mobile {
  String? tcompany_id;
  String? tuser_id;
  String? token;

  List<gb_tsession_mobile> toList = [];

  gb_tsession_mobile({
    required this.tcompany_id,
    required this.tuser_id,
    required this.token
  });

  factory gb_tsession_mobile.fromJson(Map<String, dynamic> json) =>
      gb_tsession_mobile(
        tcompany_id: json["tcompany_id"].toString(),
        tuser_id: json["tuser_id"].toString(),
        token: json["token"].toString()
      );

  gb_tsession_mobile.fromJsonList(List<dynamic> jsonList) {

    jsonList.forEach((item)
    {
      gb_tsession_mobile lo_tsession_mobile = gb_tsession_mobile.fromJson(item);
      toList.add(lo_tsession_mobile);
    });
    return;
  }

  Map<String, dynamic> toJson() => {
    "tcompany_id": tcompany_id,
    "tuser_id": tuser_id,
    "token": token,
  };
}
