import 'dart:convert';

gb_tuser tuserFromJson(String str) => gb_tuser.fromJson(json.decode(str));
String tuserToJson(gb_tuser data) => json.encode(data.toJson());

class gb_tuser {

  String? tcompany_id;
  String? tworkspace_id;
  String? tuser_id;
  String? tperson_id;
  String? tposition_id;
  String? person_shortname;
  String? person_image;
  String? company;
  String? company_image;
  String? workspace;
  String? position;
  String? entity_pro_count;
  String? entity_pol_count;
  String? entity_doc_count;
  String? entity_crs_count;
  String? entity_req_count;
  String? entity_pos_count;
  String? group_count_chat_pending;
  String? inbox_count_pending;
  String? jwt_token;
  String? aws_s3_bucket;
  String? login_type;
  String? login_client_id;
  String? login_directory_id;
  String? login_secret_key;
  String? login_field_name;

  List<gb_tuser> toList = [];

  gb_tuser({
    required this.tcompany_id,
    required this.tworkspace_id,
    required this.tuser_id,
    required this.tperson_id,
    required this.tposition_id,
    required this.person_shortname,
    required this.person_image,
    required this.company,
    required this.company_image,
    required this.workspace,
    required this.position,
    required this.entity_pro_count,
    required this.entity_pol_count,
    required this.entity_doc_count,
    required this.entity_crs_count,
    required this.entity_req_count,
    required this.entity_pos_count,
    required this.group_count_chat_pending,
    required this.inbox_count_pending,
    required this.jwt_token,
    required this.aws_s3_bucket,
    required this.login_type,
    required this.login_client_id,
    required this.login_directory_id,
    required this.login_secret_key,
    required this.login_field_name
  });

  factory gb_tuser.fromJson(Map<String, dynamic> json) =>
      gb_tuser(
          tcompany_id: json["tcompany_id"].toString(),
          tworkspace_id: json["tworkspace_id"].toString(),
          tuser_id: json["tuser_id"].toString(),
          tperson_id: json["tperson_id"].toString(),
          tposition_id: json["tposition_id"].toString(),
          person_shortname: json["person_shortname"].toString(),
          person_image: json["person_image"].toString(),
          company: json["company"].toString(),
          company_image: json["company_image"].toString(),
          workspace: json["workspace"].toString(),
          position: json["position"].toString(),
          entity_pro_count: json["entity_pro_count"].toString(),
          entity_pol_count: json["entity_pol_count"].toString(),
          entity_doc_count: json["entity_doc_count"].toString(),
          entity_crs_count: json["entity_crs_count"].toString(),
          entity_req_count: json["entity_req_count"].toString(),
          entity_pos_count: json["entity_pos_count"].toString(),
          group_count_chat_pending: json["group_count_chat_pending"].toString(),
          inbox_count_pending: json["inbox_count_pending"].toString(),
          jwt_token: json["jwt_token"].toString(),
          aws_s3_bucket: json["aws_s3_bucket"].toString(),
          login_type: json["login_type"].toString(),
          login_client_id: json["login_client_id"].toString(),
          login_directory_id: json["login_directory_id"].toString(),
          login_secret_key: json["login_secret_key"].toString(),
          login_field_name: json["login_field_name"].toString()
      );


  Map<String, dynamic> toJson() => {
    "tcompany_id":tcompany_id,
    "tworkspace_id":tworkspace_id,
    "tuser_id":tuser_id,
    "tperson_id":tperson_id,
    "tposition_id":tposition_id,
    "person_shortname":person_shortname,
    "person_image":person_image,
    "company":company,
    "company_image": company_image,
    "workspace":workspace,
    "position":position,
    "entity_pro_count":entity_pro_count,
    "entity_pol_count":entity_pol_count,
    "entity_doc_count":entity_doc_count,
    "entity_crs_count":entity_crs_count,
    "entity_req_count":entity_req_count,
    "entity_pos_count":entity_pos_count,
    "group_count_chat_pending":group_count_chat_pending,
    "inbox_count_pending":inbox_count_pending,
    "jwt_token":jwt_token,
    "aws_s3_bucket":aws_s3_bucket,
    "login_type":login_type,
    "login_client_id":login_client_id,
    "login_directory_id":login_directory_id,
    "login_secret_key":login_secret_key,
    "login_field_name":login_field_name
};

  gb_tuser.fromJsonList(List<dynamic> jsonList) {

    jsonList.forEach((item)
    {
      gb_tuser lo_gb_user = gb_tuser.fromJson(item);
      toList.add(lo_gb_user);
    });
    return;
  }

}
