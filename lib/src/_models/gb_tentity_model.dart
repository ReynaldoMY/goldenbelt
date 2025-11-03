import 'dart:convert';

gb_tentity tentityFromJson(String str) => gb_tentity.fromJson(json.decode(str));
String tentityToJson(gb_tentity data) => json.encode(data.toJson());

gb_tdocument tdocumentFromJson(String str) => gb_tdocument.fromJson(json.decode(str));

class gb_tentity {

  String? tentity_id;
  String? tentity_type;
  String? tentity_name;
  String? is_participant;
  String? is_owner;
  String? is_approver;
  String? is_reviser;
  String? is_editor;

  List<gb_tentity> toList = [];

  gb_tentity({
    required this.tentity_id,
    required this.tentity_type,
    required this.tentity_name,
    required this.is_participant,
    required this.is_owner,
    required this.is_approver,
    required this.is_reviser,
    required this.is_editor,
  });

  factory gb_tentity.fromJson(Map<String, dynamic> json) =>
      gb_tentity(
        tentity_id: json["tentity_id"].toString(),
        tentity_type: json["tentity_type"].toString(),
        tentity_name: json["tentity_name"].toString(),
        is_participant: json["is_participant"].toString(),
        is_owner: json["is_owner"].toString(),
        is_approver: json["is_approver"].toString(),
        is_reviser: json["is_reviser"].toString(),
        is_editor: json["is_editor"].toString(),
      );

  gb_tentity.fromJsonList(List<dynamic> jsonList) {

    jsonList.forEach((item)
    {
      gb_tentity lo_gb_tentity = gb_tentity.fromJson(item);
      toList.add(lo_gb_tentity);
    });
    return;
  }

  Map<String, dynamic> toJson() => {
    "tentity_id": tentity_id,
    "tentity_type": tentity_type,
    "tentity_name": tentity_name,
    "is_participant": is_participant,
    "is_owner": is_owner,
    "is_approver": is_approver,
    "is_reviser": is_reviser,
    "is_editor": is_editor,
  };
}

class gb_tdocument {

  String? id;
  String? docname;
  String? file_exists;
  String? filename_pub;
  String? filesize_pub;
  String? file_ext_pub;

  gb_tdocument({
    required this.id,
    required this.docname,
    required this.file_exists,
    required this.filename_pub,
    required this.filesize_pub,
    required this.file_ext_pub,
  });

  factory gb_tdocument.fromJson(Map<String, dynamic> json) =>
      gb_tdocument(
          id: json["id"].toString(),
          docname: json["docname"].toString(),
          file_exists: json["file_exists"].toString(),
          filename_pub: json["filename_pub"].toString(),
          filesize_pub: json["filesize_pub"].toString(),
          file_ext_pub: json["file_ext_pub"].toString(),
      );


}
