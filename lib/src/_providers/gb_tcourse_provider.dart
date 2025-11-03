import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:goldenbelt/src/_env/gbEnvironment.dart';
import 'package:goldenbelt/src/_models/gb_tcourse_model.dart';
import 'package:http/http.dart' as http;

class gbCourseProvider {

  String _url = gbEnvironment.ses_gb_domain_backend;
  String _api = '/node/tcourse';

  late BuildContext context;

  Future? init(BuildContext context)
  {
    this.context = context;

  }

  Future<List<gb_tenrollment_instance_tcourse>> getEnrollmentInstanceAll(String tenrollment_instance_tcourse_id) async {

    gbSessionSettings.configurePrefs();
    gbSession gb = gbSessionSettings.gb_getSessionValues();

    final headers = {'Content-Type': 'application/json', 'authorization': 'bearer' + ' ' + gb.ses_jwt_token};
    var params = gb.ses_tcompany_id + "," + gb.ses_tworkspace_id + "," + gb.ses_tuser_id + "," + gb.ses_tperson_id + "," + tenrollment_instance_tcourse_id;

    Uri url = Uri.https(_url, '$_api/getEnrollmentInstance/' + params);

    final response = await http.get(
        url,
        headers: headers
    );

    final data = json.decode(response.body);

    gb_tenrollment_instance_tcourse lo_gb_tenrollment_instance_tcourse = gb_tenrollment_instance_tcourse.fromJsonList(data);
    return lo_gb_tenrollment_instance_tcourse.toList;
  }

  Future<List<gb_tcourse_content>> getCourseContentAll(String tenrollment_instance_tcourse_id) async {

    gbSessionSettings.configurePrefs();
    gbSession gb = gbSessionSettings.gb_getSessionValues();

    final headers = {'Content-Type': 'application/json', 'authorization': 'bearer' + ' ' + gb.ses_jwt_token};
    var params = gb.ses_tcompany_id + "," + gb.ses_tworkspace_id + "," + gb.ses_tuser_id + "," + gb.ses_tperson_id + "," + tenrollment_instance_tcourse_id;

    Uri url = Uri.https(_url, '$_api/getEnrollmentInstanceContent/' + params);

    final response = await http.get(
        url,
        headers: headers
    );

    final data = json.decode(response.body);

    gb_tcourse_content lo_gb_tcourse_content = gb_tcourse_content.fromJsonList(data);
    return lo_gb_tcourse_content.toList;
  }

  Future<String> getCourseContentItemHtml(String tenrollment_instance_tcourse_id, String tcourse_content_id) async {

    gbSessionSettings.configurePrefs();
    gbSession gb = gbSessionSettings.gb_getSessionValues();

    final headers = {'Content-Type': 'application/json', 'authorization': 'bearer' + ' ' + gb.ses_jwt_token};
    var params = gb.ses_tcompany_id + "," + gb.ses_tworkspace_id + "," + gb.ses_tuser_id + "," + gb.ses_tperson_id + "," + tenrollment_instance_tcourse_id + "," + tcourse_content_id;

    Uri url = Uri.https(_url, '$_api/getEnrollmentInstanceContentHtml/' + params);

    final response = await http.get(
        url,
        headers: headers
    );

    final data = json.decode(response.body);
    String lv_content_html_consolidated = data[0]["content_html_consolidated"];

    return lv_content_html_consolidated.toString();
  }

  Future<List<gb_tcourse_content>> getCourseContentConsolidateHtmlItems(String tcourse_content_id) async {

    gbSessionSettings.configurePrefs();
    gbSession gb = gbSessionSettings.gb_getSessionValues();

    final headers = {'Content-Type': 'application/json', 'authorization': 'bearer' + ' ' + gb.ses_jwt_token};
    var params = gb.ses_tcompany_id + "," + gb.ses_tworkspace_id + "," + gb.ses_tuser_id + "," + gb.ses_tperson_id + "," + tcourse_content_id;

    Uri url = Uri.https(_url, '$_api/getCourseContentConsolidateHtmlItems/' + params);

    final response = await http.get(
        url,
        headers: headers
    );

    final data = json.decode(response.body);

    gb_tcourse_content lo_gb_tcourse_content = gb_tcourse_content.fromJsonList(data);
    return lo_gb_tcourse_content.toList;
  }

  Future<String> getCourseContentS3getSignedUrl(String tcourse_content_id) async {

    gbSessionSettings.configurePrefs();
    gbSession gb = gbSessionSettings.gb_getSessionValues();

    final headers = {'Content-Type': 'application/json', 'authorization': 'bearer' + ' ' + gb.ses_jwt_token};
    var params = gb.ses_tcompany_id + "," + gb.ses_tworkspace_id + "," + gb.ses_tuser_id + "," + gb.ses_tperson_id + "," + tcourse_content_id + "," + gb.ses_aws_s3_bucket;

    Uri url = Uri.https(_url, '$_api/getCourseContentS3getSignedUrl/' + params);

    final response = await http.get(
        url,
        headers: headers
    );
    final data = json.decode(response.body);
    return data['presignedUrl'];
  }

  Future<List<gb_tcourse_content_item>> getEnrollmentInstanceContentItems(String tenrollment_instance_tcourse_id, String tcourse_content_id) async {

    gbSessionSettings.configurePrefs();
    gbSession gb = gbSessionSettings.gb_getSessionValues();

    final headers = {'Content-Type': 'application/json', 'authorization': 'bearer' + ' ' + gb.ses_jwt_token};
    var params = gb.ses_tcompany_id + "," + gb.ses_tworkspace_id + "," + gb.ses_tuser_id + "," + gb.ses_tperson_id + "," + tenrollment_instance_tcourse_id + "," + tcourse_content_id;

    Uri url = Uri.https(_url, '$_api/getEnrollmentInstanceContentItems/' + params);

    final response = await http.get(
        url,
        headers: headers
    );

    final data = json.decode(response.body);

    gb_tcourse_content_item lo_gb_tcourse_content_item = gb_tcourse_content_item.fromJsonList(data);
    return lo_gb_tcourse_content_item.toList;
  }

  Future<List<gb_tcourse_content_item_option>> getEnrollmentInstanceContentItemOptions(String tenrollment_instance_tcourse_id, String tcourse_content_item_id) async {

    gbSessionSettings.configurePrefs();
    gbSession gb = gbSessionSettings.gb_getSessionValues();

    final headers = {'Content-Type': 'application/json', 'authorization': 'bearer' + ' ' + gb.ses_jwt_token};
    var params = gb.ses_tcompany_id + "," + gb.ses_tworkspace_id + "," + gb.ses_tuser_id + "," + gb.ses_tperson_id + "," + tenrollment_instance_tcourse_id + "," + tcourse_content_item_id;

    Uri url = Uri.https(_url, '$_api/getEnrollmentInstanceContentItemOptions/' + params);

    final response = await http.get(
        url,
        headers: headers
    );

    final data = json.decode(response.body);

    gb_tcourse_content_item_option lo_gb_tcourse_content_item_option = gb_tcourse_content_item_option.fromJsonList(data);
    return lo_gb_tcourse_content_item_option.toList;
  }

  Future<String> saveAssessmentAnswer(String tenrollment_instance_tcourse_id, String tcourse_content_item_id, String answer) async {

    gbSessionSettings.configurePrefs();
    gbSession gb = gbSessionSettings.gb_getSessionValues();
    final headers = {'Content-Type': 'application/json', "authorization" : "bearer" + " " + gb.ses_jwt_token};
    var params = gb.ses_tcompany_id + "," + gb.ses_tworkspace_id + "," + gb.ses_tuser_id + "," + gb.ses_tperson_id + "," + tenrollment_instance_tcourse_id + "," + tcourse_content_item_id;
    Uri url = Uri.https(_url, '$_api/saveAssessmentAnswer/' + params);

    var requestBody = {
      'answer': answer
    };

    final response = await http.post(
        url,
        headers: headers,
        body: json.encode(requestBody)
    );

    final data = json.decode(response.body);
    String lv_response = data[0]["gb_enrollment_save_answer"].toString();

    return lv_response;

  }

  Future<String> getCourseS3getSignedUrl(String tentity_type, String tentity_id) async {

    gbSessionSettings.configurePrefs();
    gbSession gb = gbSessionSettings.gb_getSessionValues();

    final headers = {'Content-Type': 'application/json', 'authorization': 'bearer' + ' ' + gb.ses_jwt_token};
    var params = gb.ses_tcompany_id + "," + gb.ses_tworkspace_id + "," + gb.ses_tuser_id + "," + gb.ses_tperson_id + "," + tentity_type + "," + tentity_id + "," + gb.ses_aws_s3_bucket;

    Uri url = Uri.https(_url, '$_api/getCourseS3getSignedUrl/' + params);

    final response = await http.get(
        url,
        headers: headers
    );
    final data = json.decode(response.body);
    return data['presignedUrl'];
  }

}