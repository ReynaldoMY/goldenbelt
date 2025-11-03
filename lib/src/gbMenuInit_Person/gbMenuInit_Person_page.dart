import 'package:flutter/material.dart';
import 'package:goldenbelt/src/_env/gbEnvironment.dart';
import 'package:goldenbelt/src/_env/gbLanguage.dart';
import 'package:goldenbelt/src/gbMenuInit_Person/gbEntity/gbEntity_page.dart';
import 'package:goldenbelt/src/_providers/gb_tuser_provider.dart';
import 'package:goldenbelt/src/_models/gb_tuser_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:goldenbelt/src/gbLogin/gbLogin_page.dart';


class gbPersonFrontPage extends StatefulWidget {
  const gbPersonFrontPage({super.key});

  @override
  State<gbPersonFrontPage> createState() => _gbPersonFrontPageState();
}

class _gbPersonFrontPageState extends State<gbPersonFrontPage> {

  bool _is_validateVersionUpdate = true;

  String gb_company = "";
  String gb_workspace = "";
  String gb_position = "";
  String gb_username = "";
  String gb_person_shortname = "";
  String gb_tcompany_id = "";
  String gb_company_image = "";
  String gb_person_image = "";
  String gb_entity_pro_count = "";
  String gb_entity_pol_count = "";
  String gb_entity_doc_count = "";
  String gb_entity_crs_count = "";
  String gb_entity_req_count = "";
  String gb_entity_pos_count = "";

  // Declaración del Idioma.
  gbLanguage gb_lang = new gbLanguage();
  //String _url = gbEnvironment.ses_gb_domain;

  @override
  void initState() {

    super.initState();
    validateVersionUpdate();
    gbSessionSettings.configurePrefs();
    gbSession gb = gbSessionSettings.gb_getSessionValues();

    gb_company = gb.ses_company;
    gb_workspace = gb.ses_workspace;
    gb_position = gb.ses_position;
    gb_username = gb.ses_username;
    gb_person_shortname = gb.ses_person_shortname;
    gb_tcompany_id = gb.ses_tcompany_id;
    gb_company_image = gb.ses_company_image;
    gb_person_image = gb.ses_person_image;
    gb_entity_pro_count = gb.ses_entity_pro_count;
    gb_entity_pol_count = gb.ses_entity_pol_count;
    gb_entity_doc_count = gb.ses_entity_doc_count;
    gb_entity_crs_count = gb.ses_entity_crs_count;
    gb_entity_req_count = gb.ses_entity_req_count;
    gb_entity_pos_count = gb.ses_entity_pos_count;

    // Declaración del Idioma.
    gb_lang.setLanguage(gb.ses_gb_lang);

    // Validación de Nulidad de Imágenes (Personas).
    if (gb_person_image == 'null' || gb_person_image == '')
    {
      gb_person_image = gbEnvironment.ses_gb_url_img_gb + '/nophoto.png';
    }
    else
    {
      gb_person_image = Uri.encodeFull(gbEnvironment.ses_gb_url_img + gb_tcompany_id + '/' + gb_person_image);
    }

    // Validación de Nulidad de Imágenes (Compañía)
    if (gb_company_image == 'null' || gb_company_image == '')
    {
      gb_company_image = gbEnvironment.ses_gb_url_img_gb + '/nocompanyphoto.png';
    }
    else
    {
      gb_company_image = Uri.encodeFull(gbEnvironment.ses_gb_url_img + gb_tcompany_id + '/' + gb_company_image);
    }

  }

  // Procedimiento para validar si es que la versión se ha vuelto obsoleta.
  void validateVersionUpdate() async
  {
    gbUserProvider _gbUserProvider = new gbUserProvider() ;
    _is_validateVersionUpdate = await _gbUserProvider.validateVersionUpdate();

    setState(() {
      if (!_is_validateVersionUpdate)
      { Navigator.pushReplacement( context, MaterialPageRoute(builder: (context) => gbLoginPage(startup_msg:gb_lang.keyword["lang_gb_error_version_obsolete"])));
      }
    });
  }

  Future<int> updateUserData() async {

    gbSession gb = gbSessionSettings.gb_getSessionValues();
    gbUserProvider _gbUserProvider = new gbUserProvider() ;

    gb_tuser lo_gb_tuser = await _gbUserProvider.getUser(tuser_id:gb.ses_tuser_id, jwt_token:gb.ses_jwt_token);

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

    gb_entity_pro_count = lo_gb_tuser.entity_pro_count!;
    gb_entity_pol_count = lo_gb_tuser.entity_pol_count!;
    gb_entity_doc_count = lo_gb_tuser.entity_doc_count!;
    gb_entity_crs_count = lo_gb_tuser.entity_crs_count!;
    gb_entity_req_count = lo_gb_tuser.entity_req_count!;
    gb_entity_pos_count = lo_gb_tuser.entity_pos_count!;


    gbSessionSettings.gb_setSessionValues(gb);

    return 1;
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body:
        Container
        (   width : double.infinity,
            color: Color(0xfff3f3f3),

            child: Column
            (   mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:
            [     Row(
                   children:  <Widget>
                   [ Spacer(),
                     const Image(image: AssetImage('assets/img/gb_logo_horizontal.png'), height: 25),
                     Spacer(),
                     Image(image: CachedNetworkImageProvider( gb_company_image ), height: 25),
                     /*Center(
                       child: _imageProvider_ImgCompany != null
                           ? Image(image: _imageProvider_ImgCompany!, height: 25)
                           : SizedBox(),
                     ),*/
                     //Image(image: _imageProvider_ImgCompany, height: 25),
                     Spacer(),
                    ]
                  ),
              SizedBox(height: 30),
              Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
              children:
        [
          Spacer(),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                      image: CachedNetworkImageProvider( gb_person_image ),
                      fit: BoxFit.fitHeight
                  )
                ),
              ),
          Spacer(),
                Column(
                    children: [
              Text(gb_person_shortname, style: TextStyle(fontSize: 18, fontWeight:FontWeight.bold, color: Color(0xFF2e3061))),
              Text(gb_position, style: TextStyle(fontSize: 12, color: Color(0xFF2e3061))),
              Text(gb_username, style: TextStyle(fontSize: 10, fontWeight:FontWeight.normal, color: Color(0xFF2e3061))),

              ]),
          Spacer()
        ],

              ),
              SizedBox(height:10),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
                  children:
                  [
                  _gbModule('PRO', gb_lang.keyword["lang_gb_process_p"], gb_entity_pro_count, 'assets/img/gb_dashboard_process.png', Color(0xFF6f87d8)),
                  _gbModule('POS', gb_lang.keyword["lang_gb_position_p"], gb_entity_pos_count, 'assets/img/gb_dashboard_position.png', Color(0xFFe58280)),
                  ]),
              Row(
                    crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
                    children:
                    [
                      _gbModule('DOC', gb_lang.keyword["lang_gb_document_p"], gb_entity_doc_count, 'assets/img/gb_dashboard_document_d.png', Color(0xFF59b556)),
                      _gbModule('POL', gb_lang.keyword["lang_gb_policy_p"], gb_entity_pol_count, 'assets/img/gb_dashboard_policies.png', Color(0xFFe5a10f)),
                  ]),
              Row(
                    crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
                    children:
                    [
                    _gbModule('REQ', gb_lang.keyword["lang_gb_request_p"], gb_entity_req_count, 'assets/img/gb_dashboard_request.png', Color(0xFF0066CC)),
                    _gbModule('CRS', gb_lang.keyword["lang_gb_course_p"], gb_entity_crs_count, 'assets/img/gb_dashboard_course_128a.png', Color(0xFF61afcb)),
                    ],

              ),
              SizedBox(height:20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
                children:
                [
                  Text(gb_company, style: TextStyle(fontSize: 10, fontWeight:FontWeight.bold, color: Color(0xFF2e3061))),
                  Text(gb_workspace, style: TextStyle(fontSize: 10, fontWeight:FontWeight.normal, color: Color(0xFF2e3061))),
                ],

              ),
            ]

           )
        ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () {

          updateUserData().then((int result)
          {
            setState(() {});
          });

        },
        backgroundColor: Color(0xFFe6e8f4),
        foregroundColor: Colors.black,
      ),
    );
  }

  Widget _GBBanner()
  {
    return Row
      ( mainAxisAlignment: MainAxisAlignment.center,
        children:
        [ Image.asset('assets/img/logo_gb.png', width:30, height:30),
          Text('Goldenbelt 3.4', style: TextStyle(fontSize: 24, fontWeight:FontWeight.bold, color: Color(0xFF2e3061)))
        ]
    );
  }

  Widget _gbModule(String pv_entity_type, String pv_label, String pv_label_figure, String pv_file_image, Color po_color)
  {
    return

      GestureDetector(
          onTap: () {
            if (pv_label_figure != "0") {
              Navigator.of(context).push
                (MaterialPageRoute(builder: (context) =>
                  gbEntityPage(
                      entity_type: pv_entity_type, entity_label: pv_label)
              ));
            }
          } ,
          child: Card(

        elevation: 5,
        color: po_color,

        child:  SizedBox(
            width: 150,
            height: 50,

            child:
            Row(
                children:
                [ Container(child: Padding(
                    padding: EdgeInsets.only(left: 5.0),
                    child:  Image.asset('$pv_file_image', width:40 , height:40),
                  )),
                  Spacer(),
                  Column(
                    children:
                    [ Spacer(),
                      Text('$pv_label', style: TextStyle(fontSize: 14, color: Color(0xFFffffff))),
                      Text('$pv_label_figure', style: TextStyle(fontSize: 14, fontWeight:FontWeight.bold, color: Color(0xFFffffff))),
                      Spacer()
                    ],
                  ),
                  Spacer(),
                ])

        )
    )
      );
  }
}
