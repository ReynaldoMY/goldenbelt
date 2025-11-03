import 'package:flutter/material.dart';
import 'package:goldenbelt/src/_models/gb_tentity_model.dart';
import 'package:goldenbelt/src/_providers/gb_tentity_provider.dart';
import 'package:goldenbelt/src/gbMenuInit_Person/gbEntity/gbEntityAttribute/gbEntityAttribute_page.dart';
import 'package:goldenbelt/src/gbMenuInit_Person/gbEntity/gbPersonCourse/gbPersonCourse_page.dart';

class gbEntityPage extends StatefulWidget {

  const gbEntityPage(
      {
        Key? key,
        required this.entity_type,
        required this.entity_label
      }): super(key: key);

  final String entity_type;
  final String entity_label;


  @override
  State<gbEntityPage> createState() => _gbEntityPageState();
}

class _gbEntityPageState extends State<gbEntityPage> {

  gbEntityProvider _gbEntityProvider = new gbEntityProvider() ;
  List<gb_tentity> lst_gb_tentity_provider = [];
  List<gb_tentity> lst_gb_tentity = [];
  String entity_image = "";
  Color entity_image_background_color =  Color(0xFF6f87d8);

  @override
  void initState() {

    super.initState();
    get_gbEntityAll();
    set_EntityImage();
  }

  void get_gbEntityAll() async
  {

    lst_gb_tentity_provider = await _gbEntityProvider.getAll(widget.entity_type);
    lst_gb_tentity_provider.forEach((item) {

      if (item.tentity_id != 'null' && mounted)
      {
        setState(() {
          lst_gb_tentity.add(item);});
      }
    });

  }

  void set_EntityImage()
  {
    switch (widget.entity_type) {
      case 'PRO':
        entity_image = 'assets/img/gb_dashboard_process.png';
        entity_image_background_color = Color(0xFF6f87d8); break;
      case 'DOC':
        entity_image = 'assets/img/gb_dashboard_document_d.png';
        entity_image_background_color = Color(0xFF59b556); break;
      case 'POL':
        entity_image = 'assets/img/gb_dashboard_policies.png';
        entity_image_background_color = Color(0xFFe5a10f); break;
      case 'CRS':
        entity_image = 'assets/img/gb_dashboard_course_128a.png';
        entity_image_background_color = Color(0xFF61afcb); break;
      case 'REQ':
        entity_image = 'assets/img/gb_dashboard_request.png';
        entity_image_background_color = Color(0xFF0066CC); break;
      case 'POS':
        entity_image = 'assets/img/gb_dashboard_position.png';
        entity_image_background_color = Color(0xFFe58280); break;

      default:

        entity_image = 'assets/img/gb_dashboard_process.png';
        entity_image_background_color = Color(0xFF6f87d8);
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.entity_label),
        ),
        body: ListView.builder(
            itemCount: lst_gb_tentity.length ,
            itemBuilder: (context, index) {
              return
                Card(
                    child: ListTile(
                      leading:
                      Column(mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                        CircleAvatar(
                            radius:20,
                            child: Image.asset(entity_image, width:30, height:30), backgroundColor: entity_image_background_color
                        ),
                      ])
                      ,
                      title: Text(lst_gb_tentity[index].tentity_name!, style: TextStyle(fontSize: 14, fontWeight:FontWeight.normal, color: Color(0xFF2e3061))),
                      subtitle: Row( mainAxisAlignment: MainAxisAlignment.end, children:
                      [
                        Container(child : lst_gb_tentity[index].is_owner == "1" ? Image(image: AssetImage('assets/img/gb_dare_OWN.png'), width: 20) : Text("")),
                        Container(child : lst_gb_tentity[index].is_editor == "1" ? Image(image: AssetImage('assets/img/gb_dare_EDT.png'), width: 20) : Text("")),
                        Container(child : lst_gb_tentity[index].is_reviser == "1" ? Image(image: AssetImage('assets/img/gb_dare_REV.png'), width: 20) : Text("")),
                        Container(child : lst_gb_tentity[index].is_approver == "1" ? Image(image: AssetImage('assets/img/gb_dare_APR.png'), width: 20) : Text("")),
                      ]),

                      onTap: ()
                      {
                        if (widget.entity_type != 'CRS') {
                          Navigator.of(context).push
                            (MaterialPageRoute(builder: (context) =>
                              gbEntityAttribute_page(
                                  entity_label: lst_gb_tentity[index].tentity_name!,
                                  entity_type: widget.entity_type,
                                  entity_id: lst_gb_tentity[index].tentity_id!)
                          ));
                        }
                        else
                        {
                          Navigator.of(context).push
                            (MaterialPageRoute(builder: (context) =>
                              gbPersonCourse_page(
                                  course_label: lst_gb_tentity[index].tentity_name!,
                                  tenrollment_instance_tcourse_id: lst_gb_tentity[index].tentity_id!)
                          ));
                        }
                      },
                    )
                );
            }
        )
    );
  }
}
