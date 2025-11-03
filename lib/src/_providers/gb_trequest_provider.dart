import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:goldenbelt/src/_env/gbEnvironment.dart';
import 'package:goldenbelt/src/_models/gb_trequest_model.dart';
import 'package:http/http.dart' as http;

class gbRequestProvider {

  String _url = gbEnvironment.ses_gb_domain_backend;
  String _api = '/node/tentity';

  late BuildContext context;

  Future? init(BuildContext context)
  {
    this.context = context;

  }

  Future<List<gb_trequest>> getRequestData(String trequest_instance_id) async {

    gbSessionSettings.configurePrefs();
    gbSession gb = gbSessionSettings.gb_getSessionValues();
    final headers = {'Content-Type': 'application/json', 'authorization': 'bearer' + ' ' + gb.ses_jwt_token};
    var params = gb.ses_tcompany_id + "," + gb.ses_tworkspace_id + "," + gb.ses_tuser_id + "," + gb.ses_tperson_id + "," + trequest_instance_id;
    Uri url = Uri.https(_url, '$_api/getRequestData/' + params);

    final response = await http.get(
        url,
        headers: headers
    );

    final data = json.decode(response.body);
    final data_detail =  data[0]["request_data"];
    gb_trequest lo_gb_trequest = gb_trequest.fromJsonList(data_detail);
    return lo_gb_trequest.toList;
  }

  Future<void> saveRequestData(String trequest_instance_id, List<gb_trequest_output> att_values) async {

    gbSessionSettings.configurePrefs();
    gbSession gb = gbSessionSettings.gb_getSessionValues();
    final headers = {'Content-Type': 'application/json', "authorization" : "bearer" + " " + gb.ses_jwt_token};
    var params = gb.ses_tcompany_id + "," + gb.ses_tworkspace_id + "," + gb.ses_tuser_id + "," + gb.ses_tperson_id + "," + trequest_instance_id;
    Uri url = Uri.https(_url, '$_api/saveRequestData/' + params);

    var requestBody = {
      'att_values': att_values
    };

    final response = await http.post(
        url,
        headers: headers,
        body: json.encode(requestBody)
    );

    final data = json.decode(response.body);
  }

  void sendRequestReceivers(String trequest_instance_id) async {

    gbSessionSettings.configurePrefs();
    gbSession gb = gbSessionSettings.gb_getSessionValues();
    final headers = {'Content-Type': 'application/json', 'authorization': 'bearer' + ' ' + gb.ses_jwt_token};
    var params = gb.ses_tcompany_id + "," + gb.ses_tworkspace_id + "," + gb.ses_tuser_id + "," + gb.ses_tperson_id + "," + trequest_instance_id;
    Uri url = Uri.https(_url, '$_api/sendRequestReceivers/' + params);

    final response = await http.get(
        url,
        headers: headers
    );

    final data = json.decode(response.body);
    final data_detail =  data[0]["request_data"];
    //print(data_detail);
  }

  Future<List<gb_trequest_files>> getRequestDataSingleFile(String trequest_instance_id) async {

    gbSessionSettings.configurePrefs();
    gbSession gb = gbSessionSettings.gb_getSessionValues();
    final headers = {'Content-Type': 'application/json', 'authorization': 'bearer' + ' ' + gb.ses_jwt_token};
    var params = gb.ses_tcompany_id + "," + gb.ses_tworkspace_id + "," + gb.ses_tuser_id + "," + gb.ses_tperson_id + "," + trequest_instance_id;
    Uri url = Uri.https(_url, '$_api/getRequestDataSingleFile/' + params);

    final response = await http.get(
        url,
        headers: headers
    );

    final data = json.decode(response.body);
    gb_trequest_files lo_gb_trequest_files = gb_trequest_files.fromJsonList(data);

    return lo_gb_trequest_files.toList;

  }

  Future<String> getRequestContentS3getSignedUrl(String tentity_type, String tentity_id) async {

    gbSessionSettings.configurePrefs();
    gbSession gb = gbSessionSettings.gb_getSessionValues();

    final headers = {'Content-Type': 'application/json', 'authorization': 'bearer' + ' ' + gb.ses_jwt_token};
    var params = gb.ses_tcompany_id + "," + gb.ses_tworkspace_id + "," + gb.ses_tuser_id + "," + gb.ses_tperson_id + "," + tentity_type + "," + tentity_id + "," + gb.ses_aws_s3_bucket;

    Uri url = Uri.https(_url, '$_api/getRequestContentS3getSignedUrl/' + params);

    final response = await http.get(
        url,
        headers: headers
    );
    final data = json.decode(response.body);
    return data['presignedUrl'];
  }
}