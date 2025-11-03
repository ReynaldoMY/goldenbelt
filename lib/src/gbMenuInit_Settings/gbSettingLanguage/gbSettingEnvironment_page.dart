import 'package:flutter/material.dart';
import 'package:goldenbelt/src/_env/gbLanguage.dart';
import 'package:goldenbelt/src/_env/gbEnvironment.dart';
import 'package:goldenbelt/src/_models/gb_tuser_model.dart';
import 'package:goldenbelt/src/_providers/gb_tuser_provider.dart';

class gbSettingEnvironment_page extends StatefulWidget {
  const gbSettingEnvironment_page(
      { Key? key
      }) : super(key: key);

  @override
  State<gbSettingEnvironment_page> createState() =>
      gbSettingEnvironment_pageState();
}

class gbSettingEnvironment_pageState extends State<gbSettingEnvironment_page> {

  // Declaración del Idioma.
  gbSession gb = gbSessionSettings.gb_getSessionValues();
  gbLanguage gb_lang = gbSessionSettings.gb_getLanguage();

  gbUserProvider _gbUserProvider = new gbUserProvider() ;
  List<gb_tuser> lst_gb_tenvironment_provider = [];
  List<gb_tuser> lst_gb_tenvironment = [];

  // Esta variable contendrá la Compañía y el Entorno de Trabajo separados por ':'.
  String lv_environment = '';

  @override
  void initState() {
    super.initState();
    gb_lang.setLanguage(gb.ses_gb_lang);
    lv_environment = gb.ses_tcompany_id + ':' + gb.ses_tworkspace_id;
    get_gbAllCompanyWorkspace();

  }

  void get_gbAllCompanyWorkspace() async
  {
    lst_gb_tenvironment_provider = await _gbUserProvider.getAllCompanyWorkspace();
    lst_gb_tenvironment_provider.forEach((item) async
    {
      if (item.tcompany_id != null && mounted)
      {
        setState(() {
          lst_gb_tenvironment.add(item);
        });
      }
    });
  }

  void get_gbUpdateUserInformation() async
  {
    gb_tuser lo_gb_tuser = await _gbUserProvider.getUser(tuser_id:gb.ses_tuser_id!, jwt_token:gb.ses_jwt_token!);

    gb.ses_tcompany_id = lo_gb_tuser.tcompany_id!;
    gb.ses_tworkspace_id = lo_gb_tuser.tworkspace_id!;
    gb.ses_tuser_id = lo_gb_tuser.tuser_id!;
    gb.ses_tperson_id = lo_gb_tuser.tperson_id!;
    gb.ses_tposition_id = lo_gb_tuser.tposition_id!;
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
    gb.ses_aws_s3_bucket = lo_gb_tuser.aws_s3_bucket!;

    gbSessionSettings.gb_setSessionValues(gb);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(gb_lang.keyword["lang_gb_change_environment"], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          backgroundColor: Color(0xFFf3edf7),
        ),
        body:ListView.builder(
            itemCount: lst_gb_tenvironment.length ,
            itemBuilder: (context, index) {
              return
                Card(
                    child: ListTile(

                      title: Text(lst_gb_tenvironment[index].company!, style: TextStyle(fontSize: 14, fontWeight:FontWeight.bold, color: Color(0xFF2e3061))),
                      subtitle: Text(lst_gb_tenvironment[index].workspace!, style: TextStyle(fontSize: 12, fontWeight:FontWeight.normal, color: Color(0xFF2e3061))),
                      trailing: lv_environment ==  lst_gb_tenvironment[index].tcompany_id! + ':' + lst_gb_tenvironment[index].tworkspace_id!?  Icon(Icons.check) : SizedBox(),

                      onTap: ()
                      {
                        setState(() {
                          lv_environment = lst_gb_tenvironment[index].tcompany_id! + ':' + lst_gb_tenvironment[index].tworkspace_id!;
                          _gbUserProvider.updEnvironment(tcompany_id: lst_gb_tenvironment[index].tcompany_id!, tworkspace_id: lst_gb_tenvironment[index].tworkspace_id!).then((value)
                          {
                            get_gbUpdateUserInformation();
                          }
                          );

                        });
                      },
                    )
                );
            }
        )
    );
  }
}
