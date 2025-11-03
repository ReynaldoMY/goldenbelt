import 'dart:convert';

gb_tenrollment_instance_tcourse tenrollment_instance_tcourseFromJson(String str) => gb_tenrollment_instance_tcourse.fromJson(json.decode(str));
String tenrollment_instance_tcourseToJson(gb_tenrollment_instance_tcourse data) => json.encode(data.toJson());

class gb_tenrollment_instance_tcourse {
  String? tenrollment_instance_tcourse_id;
  String? tcourse_id;
  String? course;
  String? description;
  String? code;
  String? start_date;
  String? finish_date;
  String? is_finished;

  List<gb_tenrollment_instance_tcourse> toList = [];

  gb_tenrollment_instance_tcourse({
    required this.tenrollment_instance_tcourse_id,
    required this.tcourse_id,
    required this.course,
    required this.description,
    required this.code,
    required this.start_date,
    required this.finish_date,
    required this.is_finished,
  });

  factory gb_tenrollment_instance_tcourse.fromJson(Map<String, dynamic> json) =>
      gb_tenrollment_instance_tcourse(
        tenrollment_instance_tcourse_id: json["tenrollment_instance_tcourse_id"].toString(),
        tcourse_id: json["tcourse_id"].toString(),
        course: json["course"].toString(),
        description: json["description"].toString(),
        code: json["code"].toString(),
        start_date: json["start_date"].toString(),
        finish_date: json["finish_date"].toString(),
        is_finished: json["is_finished"].toString(),
      );

  gb_tenrollment_instance_tcourse.fromJsonList(List<dynamic> jsonList) {

    jsonList.forEach((item)
    {
      gb_tenrollment_instance_tcourse lo_gb_tenrollment_instance_tcourse = gb_tenrollment_instance_tcourse.fromJson(item);
      toList.add(lo_gb_tenrollment_instance_tcourse);
    });
    return;
  }

  Map<String, dynamic> toJson() => {
    "tenrollment_instance_tcourse_id": tenrollment_instance_tcourse_id,
    "tcourse_id": tcourse_id,
    "course": course,
    "description": description,
    "code": code,
    "start_date": start_date,
    "finish_date": finish_date,
    "is_finished": is_finished,
  };
}
gb_tcourse_content tcourse_contentFromJson(String str) => gb_tcourse_content.fromJson(json.decode(str));
String tcourse_contentToJson(gb_tcourse_content data) => json.encode(data.toJson());

class gb_tcourse_content {
  String? tcourse_content_id;
  String? tcourse_id;
  String? course_title;
  String? course_content;
  String? course_content_type_lk;
  String? content_html;
  String? parent_id;
  String? filetype;
  String? filesize;
  String? content_html_consolidated;
  String? S3SignedUrl;
  String? is_finished;

  List<gb_tcourse_content> toList = [];

  gb_tcourse_content({
    required this.tcourse_content_id,
    required this.tcourse_id,
    required this.course_title,
    required this.course_content,
    required this.course_content_type_lk,
    required this.content_html,
    required this.parent_id,
    required this.filetype,
    required this.filesize,
    required this.content_html_consolidated,
    required this.S3SignedUrl,
    required this.is_finished
  });

  factory gb_tcourse_content.fromJson(Map<String, dynamic> json) =>
      gb_tcourse_content(
          tcourse_content_id: json["tcourse_content_id"].toString(),
          tcourse_id: json["tcourse_id"].toString(),
          course_title: json["course_title"].toString(),
          course_content: json["course_content"].toString(),
          course_content_type_lk: json["course_content_type_lk"].toString(),
          content_html: json["content_html"].toString(),
          parent_id: json["parent_id"].toString(),
          filetype: json["filetype"].toString(),
          filesize: json["filesize"].toString(),
          content_html_consolidated: json["content_html_consolidated"].toString(),
          S3SignedUrl: json["S3SignedUrl"].toString(),
          is_finished: json["is_finished"].toString()
      );

  gb_tcourse_content.fromJsonList(List<dynamic> jsonList) {

    jsonList.forEach((item)
    {
      gb_tcourse_content lo_gb_tcourse_content = gb_tcourse_content.fromJson(item);
      toList.add(lo_gb_tcourse_content);
    });
    return;
  }

  Map<String, dynamic> toJson() => {
    "tcourse_content_id": tcourse_content_id,
    "tcourse_id": tcourse_id,
    "course_title": course_title,
    "course_content": course_content,
    "course_content_type_lk": course_content_type_lk,
    "content_html": content_html,
    "parent_id": parent_id,
    "filetype": filetype,
    "filesize": filesize,
    "content_html_consolidated": content_html_consolidated,
    "S3SignedUrl": S3SignedUrl,
    "is_finished": is_finished
  };

}

class gb_tcourse_content_item {
  String? tcourse_content_item_id;
  String? course_content_item;
  String? course_assessment_option_type_lk;
  String? answer;
  String? filename;
  String? filename_instance_id;
  String? is_image_file;
  String? is_sent;
  String? is_closed;
  String? date_is_sent;

  List<gb_tcourse_content_item> toList = [];

  gb_tcourse_content_item({
    required this.tcourse_content_item_id,
    required this.course_content_item,
    required this.course_assessment_option_type_lk,
    required this.answer,
    required this.filename,
    required this.filename_instance_id,
    required this.is_image_file,
    required this.is_sent,
    required this.is_closed,
    required this.date_is_sent

  });

  factory gb_tcourse_content_item.fromJson(Map<String, dynamic> json) =>
      gb_tcourse_content_item(
          tcourse_content_item_id: json["tcourse_content_item_id"].toString(),
          course_content_item: json["course_content_item"].toString(),
          course_assessment_option_type_lk: json["course_assessment_option_type_lk"].toString(),
          answer: json["answer"].toString(),
          filename: json["filename"].toString(),
          filename_instance_id: json["filename_instance_id"].toString(),
          is_image_file: json["is_image_file"].toString(),
          is_sent: json["is_sent"].toString(),
          is_closed: json["is_closed"].toString(),
          date_is_sent: json["date_is_sent"].toString(),
      );

  gb_tcourse_content_item.fromJsonList(List<dynamic> jsonList) {

    jsonList.forEach((item)
    {
      gb_tcourse_content_item lo_gb_tcourse_content_item = gb_tcourse_content_item.fromJson(item);
      toList.add(lo_gb_tcourse_content_item);
    });
    return;
  }

  Map<String, dynamic> toJson() => {
    "tcourse_content_item_id": tcourse_content_item_id,
    "course_content_item": course_content_item,
    "course_assessment_option_type_lk": course_assessment_option_type_lk,
    "answer": answer,
    "filename": filename,
    "filename_instance_id": filename_instance_id,
    "is_image_file": is_image_file,
    "is_sent": is_sent,
    "is_closed": is_closed,
    "date_is_sent": date_is_sent,
  };

}

class gb_tcourse_content_item_option {
  String? course_content_item_option_id;
  String? code;
  String? course_content_item_option;
  String? is_checked;

  List<gb_tcourse_content_item_option> toList = [];

  gb_tcourse_content_item_option({
    required this.course_content_item_option_id,
    required this.code,
    required this.course_content_item_option,
    required this.is_checked
  });

  factory gb_tcourse_content_item_option.fromJson(Map<String, dynamic> json) =>
      gb_tcourse_content_item_option(
          course_content_item_option_id: json["course_content_item_option_id"].toString(),
          code: json["code"].toString(),
          course_content_item_option: json["course_content_item_option"].toString(),
          is_checked: json["is_checked"].toString(),
      );

  gb_tcourse_content_item_option.fromJsonList(List<dynamic> jsonList) {

    jsonList.forEach((item)
    {
      gb_tcourse_content_item_option lo_gb_tcourse_content_item_option = gb_tcourse_content_item_option.fromJson(item);
      toList.add(lo_gb_tcourse_content_item_option);
    });
    return;
  }

  Map<String, dynamic> toJson() => {
    "course_content_item_option_id": course_content_item_option_id,
    "code": code,
    "course_content_item_option": course_content_item_option,
    "is_checked": is_checked
  };

}