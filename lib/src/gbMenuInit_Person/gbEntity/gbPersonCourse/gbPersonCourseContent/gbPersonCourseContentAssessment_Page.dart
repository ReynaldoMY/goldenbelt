import 'package:flutter/material.dart';
import 'package:goldenbelt/src/_models/gb_tcourse_model.dart';
import 'package:goldenbelt/src/_providers/gb_tcourse_provider.dart';
import 'package:goldenbelt/src/gbMenuInit_Person/gbEntity/gbPersonCourse/gbPersonCourseContent/gbPersonCourseContentAssessmentOptionEXC_page.dart';
import 'package:goldenbelt/src/gbMenuInit_Person/gbEntity/gbPersonCourse/gbPersonCourseContent/gbPersonCourseContentAssessmentOptionINC_page.dart';
import 'package:goldenbelt/src/gbMenuInit_Person/gbEntity/gbPersonCourse/gbPersonCourseContent/gbPersonCourseContentAssessmentOptionFLD_page.dart';
import 'package:goldenbelt/src/gbMenuInit_Person/gbEntity/gbPersonCourse/gbPersonCourseContent/gbPersonCourseContentAssessmentOptionFLE_page.dart';
import 'package:goldenbelt/src/_env/gbLanguage.dart';
import 'package:goldenbelt/src/_env/gbEnvironment.dart';

class gbPersonCourseContentAssessment_page extends StatefulWidget
{
  const gbPersonCourseContentAssessment_page(
      { Key? key,
        required this.title,
        required this.tenrollment_instance_tcourse_id,
        required this.tcourse_content_id
      }): super(key: key);

  final String title;
  final String tenrollment_instance_tcourse_id;
  final String tcourse_content_id;

  @override
  State<gbPersonCourseContentAssessment_page> createState() => _gbPersonCourseContentAssessment_pageState();
}

class _gbPersonCourseContentAssessment_pageState extends State<gbPersonCourseContentAssessment_page>
{
  gbCourseProvider _gbCourseProvider = new gbCourseProvider() ;
  List<gb_tcourse_content_item> lst_gb_tcourse_content_item_provider = [];
  List<gb_tcourse_content_item> lst_gb_tcourse_content_item = [];

  // Declaración del Idioma.
  gbSession gb = gbSessionSettings.gb_getSessionValues();
  gbLanguage gb_lang = new gbLanguage();

  @override
  void initState() {

    super.initState();
    gb_lang.setLanguage(gb.ses_gb_lang);
    get_gbEnrollmentInstanceContentItems();
  }

  // Se actualiza la pantalla.
  _refreshWidget(dynamic value)
  {
    setState(() {
      lst_gb_tcourse_content_item.clear();
      get_gbEnrollmentInstanceContentItems();
    });
  }

  void get_gbEnrollmentInstanceContentItems() async
  {

    lst_gb_tcourse_content_item_provider = await _gbCourseProvider.getEnrollmentInstanceContentItems(widget.tenrollment_instance_tcourse_id, widget.tcourse_content_id);
    lst_gb_tcourse_content_item_provider.forEach((item) {
      if (item.tcourse_content_item_id != 'null' && mounted)
      {
        setState(() {
          lst_gb_tcourse_content_item.add(item);

        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: ListView.builder(
            itemCount: lst_gb_tcourse_content_item.length ,
            itemBuilder: (context, index) {
              var title = gb_lang.keyword["lang_gb_question"] + " " + "${index + 1}";
              return
                Card(
                    child: ListTile(
                      leading:
                      Column(mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            CircleAvatar(
                                radius:20,
                                child: Text("${index + 1}"),
                              backgroundColor: Colors.indigo,
                              foregroundColor: Colors.white,

                            ),
                          ])
                      ,
                      trailing:
                      Column(mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children:[
                            Icon(lst_gb_tcourse_content_item[index].is_closed == '1' ? Icons.lock_open : Icons.lock_open),
                            Text(lst_gb_tcourse_content_item[index].is_sent == '1'
                                ? gb_lang.keyword["lang_gb_course_status_sent"] + " "+ lst_gb_tcourse_content_item[index].date_is_sent
                                : gb_lang.keyword["lang_gb_course_status_pending"],
                                style: TextStyle(color: lst_gb_tcourse_content_item[index].is_sent == '1' ? Color(0xFF3a579a) : Color(0xFFf1184c), fontWeight: FontWeight.bold)
                            )
                          ])
                      ,
                      title: Text('${title}', style: TextStyle(fontSize: 14, fontWeight:FontWeight.normal, color: Color(0xFF2e3061))),

                      onTap: ()
                      {

                        if (lst_gb_tcourse_content_item[index].course_assessment_option_type_lk == 'EXC') {
                          Navigator.of(context).push
                            (MaterialPageRoute(builder: (context) =>
                              gbPersonCourseContentAssessmentOptionEXC_page
                                ( title: title,
                                  tenrollment_instance_tcourse_id: widget.tenrollment_instance_tcourse_id,
                                  tcourse_content_item_id: lst_gb_tcourse_content_item[index].tcourse_content_item_id!,
                                  course_content_item: lst_gb_tcourse_content_item[index].course_content_item!
                              ))).then(_refreshWidget);
                        }

                        if (lst_gb_tcourse_content_item[index].course_assessment_option_type_lk == 'INC') {
                          Navigator.of(context).push
                            (MaterialPageRoute(builder: (context) =>
                              gbPersonCourseContentAssessmentOptionINC_page
                                ( title: title,
                                  tenrollment_instance_tcourse_id: widget.tenrollment_instance_tcourse_id,
                                  tcourse_content_item_id: lst_gb_tcourse_content_item[index].tcourse_content_item_id!,
                                  course_content_item: lst_gb_tcourse_content_item[index].course_content_item!
                              ))).then(_refreshWidget);
                        }

                        if (lst_gb_tcourse_content_item[index].course_assessment_option_type_lk == 'FLD') {
                          Navigator.of(context).push
                            (MaterialPageRoute(builder: (context) =>
                              gbPersonCourseContentAssessmentOptionFLD_page
                                ( title: title,
                                  tenrollment_instance_tcourse_id: widget.tenrollment_instance_tcourse_id,
                                  tcourse_content_item_id: lst_gb_tcourse_content_item[index].tcourse_content_item_id!,
                                  course_content_item: lst_gb_tcourse_content_item[index].course_content_item!,
                                  answer: lst_gb_tcourse_content_item[index].answer!,
                              ))).then(_refreshWidget);
                        }


                        if (lst_gb_tcourse_content_item[index].course_assessment_option_type_lk == 'FLE') {

                          Navigator.of(context).push
                            (MaterialPageRoute(builder: (context) =>
                              gbPersonCourseContentAssessmentOptionFLE_page
                                ( title: title,
                                tenrollment_instance_tcourse_id: widget.tenrollment_instance_tcourse_id,
                                tcourse_content_item_id: lst_gb_tcourse_content_item[index].tcourse_content_item_id!,
                                course_content_item: lst_gb_tcourse_content_item[index].course_content_item!,
                                filename: lst_gb_tcourse_content_item[index].filename!,
                                filename_instance_id:  lst_gb_tcourse_content_item[index].filename_instance_id!,
                                is_image_file: lst_gb_tcourse_content_item[index].is_image_file! == '1',
                              ))).then(_refreshWidget);
                        }
                      },
                    )
                );
            }
        )
    );
  }
}
