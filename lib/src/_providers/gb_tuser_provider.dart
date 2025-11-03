import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:goldenbelt/src/_env/gbEnvironment.dart';
import 'package:goldenbelt/src/_models/gb_tuser_model.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';


class gbUserProvider {

  String _url = gbEnvironment.ses_gb_domain_backend;
  String _api = '/node/tuser';
  String _ver = gbEnvironment.ses_gb_app_mobile_version;

  late BuildContext context;

  Future? init(BuildContext context)
  {
    this.context = context;
  }

  Future<gb_tuser> getUser({required String tuser_id, required String jwt_token}) async {

    final headers = {'Content-Type': 'application/json', 'authorization': 'bearer' + ' ' + jwt_token};
    var params = tuser_id;
    Uri url = Uri.https(_url, '$_api/getUser/' + params);

    final response = await http.get(
        url,
        headers: headers
    );

    final data = jsonDecode(response.body);

    gb_tuser lo_tuser = gb_tuser.fromJson(data);
    return lo_tuser;
  }

  Future<gb_tuser> getLogin({required String username, required String  password}) async {

    String lv_password = md5.convert(utf8.encode(password)).toString();

    final headers = {'Content-Type': 'application/json'};
    var params = username + ',' + lv_password;
    Uri url = Uri.https(_url, '$_api/getLogin/' + params);

    final response = await http.get(
        url,
        headers: headers
    );

    final data = jsonDecode(response.body);

    gb_tuser lo_tuser = gb_tuser.fromJson(data);
    return lo_tuser;
  }

  Future<gb_tuser> getLoginType({required String username}) async {

    final headers = {'Content-Type': 'application/json'};
    var params = username;
    Uri url = Uri.https(_url, '$_api/getLoginType/' + params);

    final response = await http.get(
        url,
        headers: headers
    );

    print(_url + '$_api/getLoginType/');
    final data = jsonDecode(response.body);
    gb_tuser lo_tuser = gb_tuser.fromJson(data["login_credentials"]);
    return lo_tuser;
  }

  Future<List<gb_tuser>> getAllCompanyWorkspace() async {

    gbSessionSettings.configurePrefs();
    gbSession gb = gbSessionSettings.gb_getSessionValues();
    final headers = {'Content-Type': 'application/json', 'authorization': 'bearer' + ' ' + gb.ses_jwt_token};
    var params = gb.ses_tuser_id;
    Uri url = Uri.https(_url, '$_api/getAllCompanyWorkspace/' + params);

    final response = await http.get(
        url,
        headers: headers
    );

    final data = json.decode(response.body);
    gb_tuser lo_gb_tuser = gb_tuser.fromJsonList(data);

    return lo_gb_tuser.toList;

  }

  Future<void> updEnvironment({required String tcompany_id, required String tworkspace_id}) async {

    gbSessionSettings.configurePrefs();
    gbSession gb = gbSessionSettings.gb_getSessionValues();
    final headers = {'Content-Type': 'application/json', 'authorization': 'bearer' + ' ' + gb.ses_jwt_token};
    var params = tcompany_id + ',' + tworkspace_id + ',' + gb.ses_tuser_id;
    Uri url = Uri.https(_url, '$_api/updEnvironment/' + params);

    final response = await http.get(
        url,
        headers: headers
    );

    final data = jsonDecode(response.body);

  }

  Future<bool> validateVersionUpdate() async {

    gbSessionSettings.configurePrefs();
    gbSession gb = gbSessionSettings.gb_getSessionValues();
    final headers = {'Content-Type': 'application/json', 'authorization': 'bearer' + ' ' + gb.ses_jwt_token};
    var params = gb.ses_tuser_id + ',' + _ver;
    Uri url = Uri.https(_url, '$_api/validateVersionUpdate/' + params);

    final response = await http.get(
        url,
        headers: headers
    );

    final data = jsonDecode(response.body);

    return data["result"] == '1';
  }


}