import 'dart:convert';

gb_tgroup_chat tgroup_chatFromJson(String str) => gb_tgroup_chat.fromJson(json.decode(str));
String tgroup_chatToJson(gb_tgroup_chat data) => json.encode(data.toJson());

class gb_tgroup_chat {
  String? id;
  String? tcompany_id;
  String? tgroup_id;
  String? tperson_id;
  String? person_shortname;
  String? person_image;
  String? message;
  String? audit_date_ins;
  String? is_owner;
  String? jwt_token;
  String? parent_id;

  List<gb_tgroup_chat> toList = [];

  gb_tgroup_chat({
    required this.id,
    required this.tcompany_id,
    required this.tgroup_id,
    required this.tperson_id,
    required this.person_shortname,
    required this.person_image,
    required this.message,
    required this.audit_date_ins,
    required this.is_owner,
    required this.jwt_token,
    required this.parent_id
  });

  factory gb_tgroup_chat.fromJson(Map<String, dynamic> json) =>
      gb_tgroup_chat(
        id: json["id"].toString(),
        tcompany_id: json["tcompany_id"].toString(),
        tgroup_id: json["tgroup_id"].toString(),
        tperson_id: json["tperson_id"].toString(),
        person_shortname: json["person_shortname"].toString(),
        person_image: json["person_image"].toString(),
        message: json["message"].toString(),
        audit_date_ins: json["audit_date_ins"].toString(),
        is_owner: json["is_owner"].toString(),
        jwt_token: json["jwt_token"].toString(),
        parent_id: json["parent_id"].toString(),
      );

  gb_tgroup_chat.fromJsonList(List<dynamic> jsonList) {

    jsonList.forEach((item)
    {
      gb_tgroup_chat lo_tgroup_chat = gb_tgroup_chat.fromJson(item);
      toList.add(lo_tgroup_chat);
    });
    return;
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "tcompany_id": tcompany_id,
    "tgroup_id": tgroup_id,
    "tperson_id": tperson_id,
    "person_shortname": person_shortname,
    "person_image": person_image,
    "message": message,
    "audit_date_ins": audit_date_ins,
    "is_owner": is_owner,
    "jwt_token": jwt_token,
    "parent_id": parent_id
  };
}
