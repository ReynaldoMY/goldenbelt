import 'package:flutter/material.dart';
import 'package:goldenbelt/main.dart';
import 'dart:convert';
import 'package:goldenbelt/src/gbLogin/gbLogin_controller.dart';
import 'package:goldenbelt/src/_providers/gb_tuser_provider.dart';
import 'package:goldenbelt/src/_models/gb_tuser_model.dart';
import 'package:goldenbelt/src/gbMain/gbMain_page.dart';
import 'package:goldenbelt/src/_env/gbEnvironment.dart';
import 'package:goldenbelt/src/_env/gbNotifications.dart';
import 'package:goldenbelt/src/_providers/gb_tsession_mobile_provider.dart';
import 'package:goldenbelt/src/_env/gbLanguage.dart';
import 'package:goldenbelt/src/_models/gb_tgroup_model.dart';
import 'package:goldenbelt/src/_models/gb_notification_model.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_appauth/flutter_appauth.dart';

gb_notification lo_event_gb_notification = gb_notification();

class gbLoginPage extends StatefulWidget {

  final String? startup_msg;
  const gbLoginPage({Key? key, required this.startup_msg}): super(key: key);

  @override
  State<gbLoginPage> createState() => _gbLoginPageState();
}

// Página Inicial de Goldenbelt - Login.
class _gbLoginPageState extends State<gbLoginPage> {

  gbUserProvider _gbUserProvider = new gbUserProvider() ;
  gbSessionMobileProvider _gbSessionMobileProvider = new gbSessionMobileProvider();

  // Declaración del Idioma.
  gbLanguage gb_lang = new gbLanguage();

  FlutterAppAuth _appAuth = FlutterAppAuth();
  String _accessToken = '';

  @override
  void initState()  {

    gbSessionSettings.configurePrefs();
    super.initState();
  }


  Future<void> special_login_v3(login_clientId, login_tenantId) async {
  final String _clientId = login_clientId;
  final String _tenantId = login_tenantId;
  final String _redirectUrl = 'goldenbelt://auth/';
  final String _issuer = 'https://login.microsoftonline.com/' + _tenantId;
  final List<String> _scopes = ['openid', 'profile', 'email', 'offline_access', 'User.Read'];

    try {
      final AuthorizationResponse? result = await _appAuth.authorize(
        AuthorizationRequest(
          _clientId,
          _redirectUrl,
          issuer: _issuer,
          scopes: _scopes,
          promptValues: ['login'],
        ),
      );
      if (result!= null) {
        _accessToken = result.authorizationCode!;
      }
    } catch (e) {
      print('Error signing in: $e');
    }
  }

  // Se valida el login con el usuario y password consignado.
  void gb_validate_login() async
  {
    String username = _con.usrController.text;
    String password = _con.pwdController.text;
    gb_tuser lo_tuser;

    // No se puede dejar el usuario en blanco (como mínimo debe tener valor).
    if (username == "")
    {
      _gbLoginError(gb_lang.keyword['lang_gb_error_login'], gb_lang.keyword['lang_gb_error_empty_userpass']);
      return;
    }

    // Con el usuario, se obtiene el tipo de Login.
    lo_tuser = await _gbUserProvider.getLoginType(username: username);

    // Si tiene conexión convencional, se valida adicionalmente el password.
    if (lo_tuser.login_type == '1')
    {
      // No se puede dejar el usuario en blanco (como mínimo debe tener valor).
      if (password == "")
      {
        _gbLoginError(gb_lang.keyword['lang_gb_error_login'], gb_lang.keyword['lang_gb_error_empty_userpass']);
        return;
      }

      // Se valida el usuario y el password de forma convencional.
      lo_tuser = await _gbUserProvider.getLogin(username: username, password: password);
    }
    else
    {
      String current_tuser_id = lo_tuser.tuser_id!;
      await special_login_v3(lo_tuser.login_client_id, lo_tuser.login_directory_id);
      if (_accessToken == "")
      {
        lo_tuser.tuser_id = "0";
      }
      print('Token:${_accessToken}');
    }

    // Si es que se logró obtener un usuario válido, se procede a obtener los datos del mismo.
    if (int.parse(lo_tuser.tuser_id!) > 0)
    {
      print(lo_tuser.tuser_id!);

      gb_tuser lo_gb_tuser = await _gbUserProvider.getUser(tuser_id:lo_tuser.tuser_id!, jwt_token:lo_tuser.jwt_token!);
      String jsonString = jsonEncode(lo_gb_tuser.toJson());

      if (lo_gb_tuser.tuser_id == 'null')
      {
        _gbLoginError(gb_lang.keyword['lang_gb_error_login'], gb_lang.keyword['lang_gb_error_bad_setup_userpass']);
        return;
      }

      var token = await FirebaseApi().initNotifications();

      // Se graban en el Entorno las variables de sesión.
      gbSession gb = new gbSession();
      gb.ses_gb_lang = 'ES';
      gb_lang.setLanguage(gb.ses_gb_lang);

      gb.ses_token_mobile = token!;
      gb.ses_tcompany_id = lo_gb_tuser.tcompany_id!;
      gb.ses_tworkspace_id = lo_gb_tuser.tworkspace_id!;
      gb.ses_tuser_id = lo_gb_tuser.tuser_id!;
      gb.ses_tperson_id = lo_gb_tuser.tperson_id!;
      gb.ses_tposition_id = lo_gb_tuser.tposition_id!;
      gb.ses_username = username;
      gb.ses_person_shortname = lo_gb_tuser.person_shortname!;
      gb.ses_person_image = lo_gb_tuser.person_image!;
      gb.ses_company = lo_gb_tuser.company!;
      gb.ses_company_image = lo_gb_tuser.company_image!;
      gb.ses_workspace = lo_gb_tuser.workspace!;
      gb.ses_position = lo_gb_tuser.position!;
      gb.ses_entity_pro_count = lo_gb_tuser.entity_pro_count!;
      gb.ses_entity_pol_count = lo_gb_tuser.entity_pol_count!;
      gb.ses_entity_doc_count = lo_gb_tuser.entity_doc_count!;
      gb.ses_entity_crs_count = lo_gb_tuser.entity_crs_count!;
      gb.ses_entity_req_count = lo_gb_tuser.entity_req_count!;
      gb.ses_entity_pos_count = lo_gb_tuser.entity_pos_count!;
      gb.ses_group_count_chat_pending = lo_gb_tuser.group_count_chat_pending!;
      gb.ses_inbox_count_pending = lo_gb_tuser.inbox_count_pending!;
      gb.ses_jwt_token = lo_tuser.jwt_token!;
      gb.ses_aws_s3_bucket = lo_gb_tuser.aws_s3_bucket!;

      gbSessionSettings.gb_setSessionValues(gb);

      // Se crea la sesión en la BD.
      await _gbSessionMobileProvider.create();

      // Se inicia la aplicación.
      Navigator.push( context, MaterialPageRoute(builder: (context) => gbMainFrontPage(ln_event_index_page: 0, lo_event_gb_notification: lo_event_gb_notification)));
    }
    else {
      _gbLoginError(gb_lang.keyword['lang_gb_error_login'], gb_lang.keyword['lang_gb_error_bad_userpass']);
    }

  }

  void _gbLoginError(msgTitle, msgError)
  {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            backgroundColor: Color(0xFFffffff),
            content:
            Container(
                height:60,
                child:
                Row(
                    children:[
                      Container(
                        child: Image.asset('assets/img/error.png', width:40, height:40),
                      ),
                      SizedBox(width:10),
                      Container(
                          child:
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(msgTitle, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                              Text(msgError, style: TextStyle(fontSize: 12))
                            ],
                          ))
                    ])
            )

        ));
  }

  gbLoginController _con = new gbLoginController();



  @override
  Widget build(BuildContext context) {
    return Stack(
          children:[
                Container(
                decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/img/gb_background.png'), // <-- BACKGROUND IMAGE
                    fit: BoxFit.cover,
                ),
                ),
                ),
                Scaffold(backgroundColor: Colors.transparent,
                  body: Container(
                child: Column
                    (children: <Widget>
                     [ const SizedBox(height: 15),
                       Container
                         ( child: Column
                           ( children:
                             [ SizedBox(height: 150),
                               _GBBanner(),
                               SizedBox(height: 50),
                               _gbTxtField(gb_lang.keyword['lang_gb_user'], _con.usrController),
                               SizedBox(height: 20),
                               _gbTxtField(gb_lang.keyword['lang_gb_pass'], _con.pwdController, true),

                               _btnLoginConnect(),
                               Container(
                                   width: 240.0,
                                   height: 50.0,
                                   child:Center(
                                   child: Text(widget.startup_msg!, textAlign:TextAlign.center, style:TextStyle(fontSize: 14, color: Colors.red, fontWeight: FontWeight.bold))
                                   )
                               )
                            ]
                          )
                        ),
                      ]
                  )
                )
                )
          ]);
  }

  Widget _GBBanner()
  {
    return Row
      ( mainAxisAlignment: MainAxisAlignment.center,
        children:
        [ Image.asset('assets/img/logo_gb.png', width:50, height:50),
          Text('Goldenbelt 3.4', style: TextStyle(fontSize: 32, fontWeight:FontWeight.bold, color: Color(0xFF2e3061)))
        ]
    );
  }

   Widget  _btnLoginConnect()
  {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal:50, vertical:30),
      child: ElevatedButton
        ( onPressed: () { gb_validate_login(); },
          child: Text(gb_lang.keyword['lang_gb_connect'], style: TextStyle(color: Color(0xFFFFFFFF))),
          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF4c82ac))
        ),
    );
  }

  Widget _gbTxtField(String label, TextEditingController controller, [bool isPassword = false])
  {
    return Container
      ( margin: EdgeInsets.symmetric(horizontal: 50),
        child: TextFormField
          ( controller: controller,
            obscureText: isPassword,
            cursorColor: Color(0xFF4c82ac),
            decoration: InputDecoration
              ( fillColor: Color(0xFFFFFFFF),
                filled: true,
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                      style: BorderStyle.none, color: Color(0xFFFFFFFF)),
                ),
                border: UnderlineInputBorder(),
                labelText: '$label',
                labelStyle: TextStyle(color: Color(0xFF4c82ac)),
                ),
          ),
      );
  }


}