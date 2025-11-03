import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:goldenbelt/src/_env/gbEnvironment.dart';
import 'package:http/http.dart' as http;

class gbSessionMobileProvider {

  String _url = gbEnvironment.ses_gb_domain_backend;
  String _api = '/node/tsession_mobile';
  String _ver = gbEnvironment.ses_gb_app_mobile_version;

  late BuildContext context;

  Future? init(BuildContext context)
  {
    this.context = context;
  }

  Future? create() async {

    gbSessionSettings.configurePrefs();
    gbSession gb = gbSessionSettings.gb_getSessionValues();

    final headers = {'Content-Type': 'application/json', 'authorization': 'bearer' + ' ' + gb.ses_jwt_token};
    var requestBody = {
      'tcompany_id': gb.ses_tcompany_id ,
      'tuser_id': gb.ses_tuser_id ,
      'token_mobile': gb.ses_token_mobile,
      'version': _ver
    };

    Uri url = Uri.https(_url, '$_api/create/');

    final response = await http.post(
        url,
        headers: headers,
        body: json.encode(requestBody)
    );

    final data = json.decode(response.body);
    //print(data);

  }

}