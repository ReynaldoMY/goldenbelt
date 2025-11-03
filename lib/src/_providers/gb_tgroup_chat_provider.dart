import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:goldenbelt/src/_env/gbEnvironment.dart';
import 'package:goldenbelt/src/_models/gb_tgroup_chat_model.dart';
import 'package:http/http.dart' as http;

class gbGroupChatProvider {

  String _url = gbEnvironment.ses_gb_domain_backend;
  String _api = '/node/tgroup_chat';
  String tgroup_id = '0';

  late BuildContext context;

  Future? init(BuildContext context)
  {
    this.context = context;
  }

  Future<List<gb_tgroup_chat>> getAll() async {

    gbSessionSettings.configurePrefs();
    gbSession gb = gbSessionSettings.gb_getSessionValues();
    final headers = {'Content-Type': 'application/json', 'authorization': 'bearer' + ' ' + gb.ses_jwt_token};
    final params = gb.ses_tcompany_id + "," + gb.ses_tworkspace_id + "," + gb.ses_tuser_id + "," + gb.ses_tperson_id + "," + this.tgroup_id;

    Uri url = Uri.https(_url, '$_api/getAll/' + params);

    final response = await http.get(
        url,
        headers: headers
    );

    final data = json.decode(response.body);
    gb_tgroup_chat lo_tgroup_chat = gb_tgroup_chat.fromJsonList(data);
    return lo_tgroup_chat.toList;
  }

  Future? deleteMessageChat(String tgroup_id, String tgroup_chat_id) async {

    gbSessionSettings.configurePrefs();
    gbSession gb = gbSessionSettings.gb_getSessionValues();
    final headers = {'Content-Type': 'application/json', "authorization" : "bearer" + " " + gb.ses_jwt_token};
    var params = gb.ses_tcompany_id + "," + tgroup_id+ "," + gb.ses_tperson_id + "," + tgroup_chat_id;
    Uri url = Uri.https(_url, '$_api/deleteMessageChat/' + params);

    final response = await http.post(
        url,
        headers: headers
    );

    final data = json.decode(response.body);
  }


}