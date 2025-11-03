import 'package:goldenbelt/src/_env/gbLanguage.dart';
import 'dart:convert';

gb_tentity_attribute gb_tentity_attributeFromJson(String str) => gb_tentity_attribute.fromJson(json.decode(str));
String gb_tentity_attributeToJson(gb_tentity_attribute data) => json.encode(data.toJson());

class gb_tentity_attribute {

  String? id;
  String? value;
  String? label;
  String? value_html;
  List<gb_tentity_attribute>? data;

  List<gb_tentity_attribute> toList = [];

  gb_tentity_attribute({
    required this.id,
    required this.value,
    required this.label,
    required this.value_html,
    required this.data
  });

  factory gb_tentity_attribute.fromJson(Map<String, dynamic> json) =>
      gb_tentity_attribute(
          id: json["id"].toString(),
          value: json["value"].toString(),
          label: gbLanguage().gbValidate(json["label"].toString()),
          value_html: json["value_html"].toString(),
          data: json["data"] == null ? null : List<gb_tentity_attribute>.from(json["data"].map((x) => gb_tentity_attribute.fromJson(x)))
      );

  gb_tentity_attribute.fromJsonList(List<dynamic> jsonList) {

    jsonList.forEach((item)
    {
      gb_tentity_attribute lo_gb_tentity_attribute = gb_tentity_attribute.fromJson(item);
      toList.add(lo_gb_tentity_attribute);
    });
    return;
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "value": value,
    "label": label,
    "value_html": value_html,
    "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}
