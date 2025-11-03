import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:goldenbelt/src/_env/gbEnvironment.dart';
import 'package:goldenbelt/src/_models/gb_tentity_model.dart';
import 'package:http/http.dart' as http;

class gbEntityProvider {

  String _url = gbEnvironment.ses_gb_domain_backend;
  String _api = '/node/tentity';

  late BuildContext context;

  Future? init(BuildContext context)
  {
    this.context = context;

  }

  Future<List<gb_tentity>> getAll(String tentity_type) async {

    gbSessionSettings.configurePrefs();
    gbSession gb = gbSessionSettings.gb_getSessionValues();

    final headers = {'Content-Type': 'application/json', 'authorization': 'bearer' + ' ' + gb.ses_jwt_token};
    var params = gb.ses_tcompany_id + "," + gb.ses_tworkspace_id + "," + gb.ses_tuser_id + "," + gb.ses_tperson_id + "," + gb.ses_tposition_id + "," + tentity_type;

    Uri url = Uri.https(_url, '$_api/getAll/' + params);

    final response = await http.get(
        url,
        headers: headers
    );

    final data = json.decode(response.body);
    final data_detail = data[0]["entity_data"]["entities"];

    gb_tentity lo_gb_tentity = gb_tentity.fromJsonList(data_detail);
    return lo_gb_tentity.toList;
  }

  Future? saveEntityReviserApproval(String tentity_type, String tentity_id, String approval_type) async {

    gbSessionSettings.configurePrefs();
    gbSession gb = gbSessionSettings.gb_getSessionValues();

    final headers = {'Content-Type': 'application/json', 'authorization': 'bearer' + ' ' + gb.ses_jwt_token};
    var params = gb.ses_tcompany_id + "," + gb.ses_tworkspace_id + "," + gb.ses_tuser_id + "," + gb.ses_tperson_id + ","  + tentity_type + "," + tentity_id + "," + approval_type;

    Uri url = Uri.https(_url, '$_api/saveEntityReviserApproval/' + params);

    final response = await http.get(
        url,
        headers: headers
    );

    final data = json.decode(response.body);
    // final data_detail = data[0]["entity_data"]["entities"];
  }

  Future<String> getEntityReviserData(String tentity_type, String tentity_id) async {

    gbSessionSettings.configurePrefs();
    gbSession gb = gbSessionSettings.gb_getSessionValues();

    final headers = {'Content-Type': 'application/json', 'authorization': 'bearer' + ' ' + gb.ses_jwt_token};
    var params = gb.ses_tcompany_id + "," + gb.ses_tworkspace_id + "," + gb.ses_tuser_id + "," + gb.ses_tperson_id + ","  + tentity_type + "," + tentity_id;

    var query_params = {
      'tentity_type': tentity_type,
      'tentity_id': tentity_id
    };

    Uri url = Uri.https(_url, '$_api/getEntityReviserData/' + params, query_params);

    final response = await http.get(
        url,
        headers: headers
    );

    final data = json.decode(response.body);
    return data["obs_detail"];
    // final data_detail = data[0]["entity_data"]["entities"];

  }

  Future? saveEntityReviserData(String tentity_type, String tentity_id, String obs_detail) async {

    gbSessionSettings.configurePrefs();
    gbSession gb = gbSessionSettings.gb_getSessionValues();

    final headers = {'Content-Type': 'application/json', 'authorization': 'bearer' + ' ' + gb.ses_jwt_token};
    var params = gb.ses_tcompany_id + "," + gb.ses_tworkspace_id + "," + gb.ses_tuser_id + "," + gb.ses_tperson_id + "," + tentity_type + "," + tentity_id;

    Uri url = Uri.https(_url, '$_api/saveEntityReviserData/' + params);

    var requestBody = {
      'obs_detail': obs_detail
    };

    final response = await http.post(
        url,
        headers: headers,
        body: json.encode(requestBody)
    );

    final data = json.decode(response.body);
    // final data_detail = data[0]["entity_data"]["entities"];
  }

  Future<String> getEntityS3getSignedUrl(String tentity_type, String tentity_id) async {

    gbSessionSettings.configurePrefs();
    gbSession gb = gbSessionSettings.gb_getSessionValues();

    final headers = {'Content-Type': 'application/json', 'authorization': 'bearer' + ' ' + gb.ses_jwt_token};
    var params = gb.ses_tcompany_id + "," + gb.ses_tworkspace_id + "," + gb.ses_tuser_id + "," + gb.ses_tperson_id + "," + tentity_type + "," + tentity_id + "," + gb.ses_aws_s3_bucket;

    Uri url = Uri.https(_url, '$_api/getEntityS3getSignedUrl/' + params);

    final response = await http.get(
        url,
        headers: headers
    );
    final data = json.decode(response.body);
    return data['presignedUrl'] == null ? "" : data['presignedUrl'];
  }

  Future<gb_tdocument> getEntitySpecificDocumentData(String tentity_type, String tentity_id) async {

    gbSessionSettings.configurePrefs();
    gbSession gb = gbSessionSettings.gb_getSessionValues();

    final headers = {'Content-Type': 'application/json', 'authorization': 'bearer' + ' ' + gb.ses_jwt_token};
    var params = gb.ses_tcompany_id + "," + gb.ses_tworkspace_id + "," + gb.ses_tuser_id + "," + gb.ses_tperson_id + "," + tentity_type + "," + tentity_id;

    Uri url = Uri.https(_url, '$_api/getEntitySpecificData/' + params);

    final response = await http.get(
        url,
        headers: headers
    );

    final data = json.decode(response.body);
    gb_tdocument lo_gb_tdocument = gb_tdocument.fromJson(data["entity_data"][0]);

    return lo_gb_tdocument;
  }

}