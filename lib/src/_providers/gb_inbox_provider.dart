import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:goldenbelt/src/_env/gbEnvironment.dart';
import 'package:goldenbelt/src/_models/gb_inbox_model.dart';
import 'package:http/http.dart' as http;

class gbInboxProvider {

  String _url = gbEnvironment.ses_gb_domain_backend;
  String _api = '/node/tentity';

  late BuildContext context;

  Future? init(BuildContext context)
  {
    this.context = context;

  }

  Future<List<gb_inbox>> getInbox() async {

    gbSessionSettings.configurePrefs();
    gbSession gb = gbSessionSettings.gb_getSessionValues();
    final headers = {'Content-Type': 'application/json', 'authorization': 'bearer' + ' ' + gb.ses_jwt_token};
    var params = gb.ses_tcompany_id + "," + gb.ses_tworkspace_id + "," + gb.ses_tuser_id + "," + gb.ses_tperson_id;
    Uri url = Uri.https(_url, '$_api/getInbox/' + params);

    final response = await http.get(
        url,
        headers: headers
    );

    final data = json.decode(response.body);
    final data_detail = data[0]["entity_data"];

    gb_inbox lo_gb_inbox = gb_inbox.fromJsonList(data_detail);


    return lo_gb_inbox.toList;
  }

}