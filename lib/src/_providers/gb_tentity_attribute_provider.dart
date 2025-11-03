import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:goldenbelt/src/_env/gbEnvironment.dart';
import 'package:goldenbelt/src/_models/gb_tentity_attribute_model.dart';
import 'package:http/http.dart' as http;

class gbEntityAttributeProvider {

  String _url = gbEnvironment.ses_gb_domain_backend;
  String _api = '/node/tentity';

  late BuildContext context;

  Future? init(BuildContext context)
  {
    this.context = context;

  }

  Future<List<gb_tentity_attribute>> getEntityData(String tentity_type, String tentity_id) async {

    gbSessionSettings.configurePrefs();
    gbSession gb = gbSessionSettings.gb_getSessionValues();
    final headers = {'Content-Type': 'application/json', 'authorization': 'bearer' + ' ' + gb.ses_jwt_token};
    var params = gb.ses_tcompany_id + "," + gb.ses_tworkspace_id + "," + gb.ses_tuser_id + "," + gb.ses_tperson_id + "," + tentity_type  + "," + tentity_id;
    Uri url = Uri.https(_url, '$_api/getEntityData/' + params);

    final response = await http.get(
        url,
        headers: headers
    );

    final data = json.decode(response.body);
    final data_detail = data[0]["entity_data"];

    gb_tentity_attribute lo_gb_tentity_attribute = gb_tentity_attribute.fromJsonList(data_detail);
    return lo_gb_tentity_attribute.toList;
  }


}