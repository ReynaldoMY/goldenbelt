import 'dart:convert';
import 'dart:io';

// ------------------------ Modelo principal ------------------------

gb_trequest gb_trequestFromJson(String str) => gb_trequest.fromJson(json.decode(str));
String gb_trequestToJson(gb_trequest data) => json.encode(data.toJson());

class gb_trequest {
  String? att_id;
  String? att_type;
  String? att_label;
  String? att_value;
  String? att_html;
  List<gb_trequest_lkp>? att_lkp;
  File? att_file;
  String? att_is_image_file;
  String? att_url_file_saved;
  List<gb_trequest_element>? att_elements;

  List<gb_trequest> toList = [];

  gb_trequest({
    required this.att_id,
    required this.att_type,
    required this.att_label,
    required this.att_value,
    required this.att_html,
    required this.att_lkp,
    required this.att_file,
    required this.att_is_image_file,
    required this.att_url_file_saved,
    required this.att_elements,
  });

  factory gb_trequest.fromJson(Map<String, dynamic> json) => gb_trequest(
    att_id: json["att_id"].toString(),
    att_type: json["att_type"].toString(),
    att_label: json["att_label"].toString(),
    att_value: json["att_value"].toString(),
    att_html: json["att_html"].toString(),
    att_lkp: json["att_lkp"] == null
        ? null
        : List<gb_trequest_lkp>.from(
        json["att_lkp"].map((x) => gb_trequest_lkp.fromJson(x))),
    att_file: null,
    att_is_image_file: json["att_is_image_file"].toString(),
    att_url_file_saved: "",
    att_elements: json["att_elements"] == null
        ? null
        : List<gb_trequest_element>.from(
        json["att_elements"].map((x) => gb_trequest_element.fromJson(x))),
  );

  gb_trequest.fromJsonList(List<dynamic> jsonList) {
    jsonList.forEach((item) {
      gb_trequest lo_gb_trequest = gb_trequest.fromJson(item);
      toList.add(lo_gb_trequest);
    });
  }

  Map<String, dynamic> toJson() => {
    "att_id": att_id,
    "att_type": att_type,
    "att_label": att_label,
    "att_value": att_value,
    "att_html": att_html,
    "att_lkp": att_lkp == null
        ? null
        : List<dynamic>.from(att_lkp!.map((x) => x.toJson())),
    "att_file": null,
    "att_is_image_file": att_is_image_file,
    "att_url_file_saved": att_url_file_saved,
    "att_elements": att_elements == null
        ? null
        : List<dynamic>.from(att_elements!.map((x) => x.toJson())),
  };
}

// ------------------------ Lookup (LKP) ------------------------

class gb_trequest_lkp {
  String? lkp_id;
  String? lkp_label;
  String? is_checked;

  gb_trequest_lkp({
    required this.lkp_id,
    required this.lkp_label,
    required this.is_checked,
  });

  factory gb_trequest_lkp.fromJson(Map<String, dynamic> json) =>
      gb_trequest_lkp(
        lkp_id: json["lkp_id"].toString(),
        lkp_label: json["lkp_label"].toString(),
        is_checked: json["is_checked"].toString(),
      );

  Map<String, dynamic> toJson() => {
    "lkp_id": lkp_id,
    "lkp_label": lkp_label,
    "is_checked": is_checked,
  };
}

// ------------------------ Output simple ------------------------

class gb_trequest_output {
  String? att_id;
  String? att_value;
  String? att_type;

  gb_trequest_output({
    required this.att_id,
    required this.att_value,
    required this.att_type,
  });

  factory gb_trequest_output.fromJson(Map<String, dynamic> json) =>
      gb_trequest_output(
        att_id: json["att_id"].toString(),
        att_value: json["att_value"].toString(),
        att_type: json["att_type"].toString(),
      );

  Map<String, dynamic> toJson() => {
    "att_id": att_id,
    "att_value": att_value,
    "att_type": att_type,
  };
}

// ------------------------ Archivos ------------------------

class gb_trequest_files {
  String? att_id;
  String? iiv_id;
  String? att_filename;

  List<gb_trequest_files> toList = [];

  gb_trequest_files({
    required this.att_id,
    required this.iiv_id,
    required this.att_filename,
  });

  factory gb_trequest_files.fromJson(Map<String, dynamic> json) =>
      gb_trequest_files(
        att_id: json["att_id"].toString(),
        iiv_id: json["iiv_id"].toString(),
        att_filename: json["att_filename"].toString(),
      );

  gb_trequest_files.fromJsonList(List<dynamic> jsonList) {
    jsonList.forEach((item) {
      gb_trequest_files lo_gb_trequest_files =
      gb_trequest_files.fromJson(item);
      toList.add(lo_gb_trequest_files);
    });
  }

  Map<String, dynamic> toJson() => {
    "att_id": att_id,
    "iiv_id": iiv_id,
    "att_filename": att_filename,
  };
}

// ------------------------ Tabla: Elementos ------------------------

class gb_trequest_element {
  List<gb_trequest_column>? cols;
  List<Map<String, String>>? rows;

  gb_trequest_element({
    required this.cols,
    required this.rows,
  });

  factory gb_trequest_element.fromJson(Map<String, dynamic> json) =>
      gb_trequest_element(
        cols: json["cols"] == null
            ? null
            : List<gb_trequest_column>.from(
            json["cols"].map((x) => gb_trequest_column.fromJson(x))),
        rows: json["rows"] == null
            ? null
            : List<Map<String, String>>.from(json["rows"].map((row) =>
        Map<String, String>.from(row.map((k, v) => MapEntry(k, v.toString()))))),
      );

  Map<String, dynamic> toJson() => {
    "cols": cols == null ? null : List<dynamic>.from(cols!.map((x) => x.toJson())),
    "rows": rows,
  };
}

class gb_trequest_column {
  String? title;
  String? key;
  List<gb_trequest_lkp>? att_lkp;

  gb_trequest_column({
    required this.title,
    required this.key,
    this.att_lkp,
  });

  factory gb_trequest_column.fromJson(Map<String, dynamic> json) =>
      gb_trequest_column(
        title: json["title"].toString(),
        key: json["key"].toString(),
        att_lkp: json["att_lkp"] == null
            ? null
            : List<gb_trequest_lkp>.from(json["att_lkp"].map((x) => gb_trequest_lkp.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "title": title,
    "key": key,
    "att_lkp": att_lkp == null ? null : List<dynamic>.from(att_lkp!.map((x) => x.toJson())),
  };
}