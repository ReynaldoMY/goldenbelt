import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:goldenbelt/src/_env/gbEnvironment.dart';
import 'package:goldenbelt/src/_models/gb_tgroup_model.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as aes;
import 'package:hex/hex.dart';
import 'package:password_hash_plus/password_hash_plus.dart';

class gbGroupsProvider {

  String _url = gbEnvironment.ses_gb_domain_backend;
  String _api = '/node/tgroup';

  late BuildContext context;

  Future? init(BuildContext context)
  {
   this.context = context;
  }

  Future<List<gb_tgroup>> getAll() async {

    gbSessionSettings.configurePrefs();
    gbSession gb = gbSessionSettings.gb_getSessionValues();
    final headers = {'Content-Type': 'application/json', "authorization" : "bearer" + " " + gb.ses_jwt_token};
    final params = gb.ses_tcompany_id + "," + gb.ses_tworkspace_id + "," + gb.ses_tuser_id + "," + gb.ses_tperson_id;

    Uri url = Uri.https(_url, '$_api/getAll/' + params);

    final response = await http.get(
        url,
        headers: headers
    );

    final data = json.decode(response.body);
    gb_tgroup lo_tgroup = gb_tgroup.fromJsonList(data);
    return lo_tgroup.toList;
  }

  Future? updAccess(String tgroup_id) async {

    gbSessionSettings.configurePrefs();
    gbSession gb = gbSessionSettings.gb_getSessionValues();
    final headers = {'Content-Type': 'application/json', "authorization" : "bearer" + " " + gb.ses_jwt_token};
    var params = gb.ses_tcompany_id + "," + gb.ses_tworkspace_id + "," + gb.ses_tuser_id + "," + gb.ses_tperson_id + "," + tgroup_id;
    Uri url = Uri.https(_url, '$_api/updAccess/' + params);

    final response = await http.post(
        url,
        headers: headers
    );

    final data = json.decode(response.body);
  }

  // Obtiene el contador total de Chats Pendientes.
  Future<int> getCountChatPending() async {

    gbSessionSettings.configurePrefs();
    gbSession gb = gbSessionSettings.gb_getSessionValues();
    final headers = {'Content-Type': 'application/json', "authorization" : "bearer" + " " + gb.ses_jwt_token};
    var params = gb.ses_tcompany_id + "," + gb.ses_tworkspace_id + "," + gb.ses_tuser_id + "," + gb.ses_tperson_id;
    Uri url = Uri.https(_url, '$_api/getCountChatPending/' + params);

    final response = await http.get(
        url,
        headers: headers
    );

    final data = json.decode(response.body);
    int count = int.parse(data[0]["group_count_chat_pending"]);
    return count;
  }

  String gb_decrypt(pv_text_encrypted, pv_token)
  {
    final generator = PBKDF2(hashAlgorithm: sha1);
    final key = aes.Key.fromBase16(HEX.encode(generator.generateKey(pv_token, pv_token, 1000, 32)));
    final iv = aes.IV.fromBase16(HEX.encode(generator.generateKey(pv_token, pv_token, 1000, 16)));

    final encrypter = aes.Encrypter(aes.AES(key, mode: aes.AESMode.cbc, padding: 'PKCS7'));

    final decrypted = encrypter.decrypt64(pv_text_encrypted, iv: iv);
    return decrypted;
  }

  String gb_encrypt(pv_text, pv_token)
  {
      final generator = PBKDF2(hashAlgorithm: sha1);
      final key = aes.Key.fromBase16(HEX.encode(generator.generateKey(pv_token, pv_token, 1000, 32)));
      final iv = aes.IV.fromBase16(HEX.encode(generator.generateKey(pv_token, pv_token, 1000, 16)));

      final encrypter = aes.Encrypter(aes.AES(key, mode: aes.AESMode.cbc, padding: 'PKCS7'));

      final encrypted = encrypter.encrypt(pv_text, iv: iv);

      return encrypted.base64.toString();

  }
}