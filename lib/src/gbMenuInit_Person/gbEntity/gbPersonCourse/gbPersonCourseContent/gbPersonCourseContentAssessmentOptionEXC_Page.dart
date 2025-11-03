import 'package:flutter/material.dart';
import 'package:goldenbelt/src/_env/gbLanguage.dart';
import 'package:goldenbelt/src/_env/gbEnvironment.dart';
import 'package:goldenbelt/src/_models/gb_tcourse_model.dart';
import 'package:goldenbelt/src/_providers/gb_tcourse_provider.dart';


class gbPersonCourseContentAssessmentOptionEXC_page extends StatefulWidget {
  const gbPersonCourseContentAssessmentOptionEXC_page(
      { Key? key,
        required this.title,
        required this.tenrollment_instance_tcourse_id,
        required this.tcourse_content_item_id,
        required this.course_content_item
      }): super(key: key);

  final String tenrollment_instance_tcourse_id;
  final String tcourse_content_item_id;
  final String title;
  final String course_content_item;

  @override
  State<gbPersonCourseContentAssessmentOptionEXC_page> createState() => _gbPersonCourseContentAssessmentOptionEXC_pageState();
}

class _gbPersonCourseContentAssessmentOptionEXC_pageState extends State<gbPersonCourseContentAssessmentOptionEXC_page> {

  gbCourseProvider _gbCourseProvider = new gbCourseProvider() ;
  List<gb_tcourse_content_item_option> lst_gb_tcourse_content_item_options_provider = [];
  List<gb_tcourse_content_item_option> lst_gb_tcourse_content_item_options = [];
  var ln_course_content_item_option_id = '0';

  // Declaración del Idioma.
  gbSession gb = gbSessionSettings.gb_getSessionValues();
  gbLanguage gb_lang = new gbLanguage();

  @override
  void initState() {

    super.initState();
    gb_lang.setLanguage(gb.ses_gb_lang);
    get_gbEnrollmentInstanceContentItems();

  }

  void get_gbEnrollmentInstanceContentItems() async
  {

    lst_gb_tcourse_content_item_options_provider = await _gbCourseProvider.getEnrollmentInstanceContentItemOptions(widget.tenrollment_instance_tcourse_id, widget.tcourse_content_item_id);
    lst_gb_tcourse_content_item_options_provider.forEach((item) {
      if (item.course_content_item_option_id != 'null' && mounted)
      {
        setState(() {
          lst_gb_tcourse_content_item_options.add(item);
          if (item.is_checked == '1') ln_course_content_item_option_id = item.course_content_item_option_id!;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Color(0xFF61afcb),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child:
        Column(
          children: [

            Text(widget.course_content_item, style: TextStyle(
                fontSize: 18,
              fontWeight: FontWeight.bold
            ),),

            Divider(),

            for (var i = 0; i < lst_gb_tcourse_content_item_options.length; i++)
              RadioListTile(
                title: Text(lst_gb_tcourse_content_item_options[i].course_content_item_option!),
                value: lst_gb_tcourse_content_item_options[i].course_content_item_option_id.toString(),
                onChanged: (v) {
                  setState(() {
                    ln_course_content_item_option_id = v.toString();
                  });
                },
                groupValue: ln_course_content_item_option_id
              ),
            Divider(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50), backgroundColor: Color(0xFFe6e8f4)),
              child: Text( gb_lang.keyword["lang_gb_send_answer"], style: TextStyle(fontSize: 20, color: Color(0xFF2f3061))),
              onPressed: () {

                // Se recorre el listado para decodificar la respuesta en términos del código de la opción marcada.
                var lv_answer;
                lst_gb_tcourse_content_item_options_provider.forEach((item)
                {
                  if (item.course_content_item_option_id == ln_course_content_item_option_id)
                  {
                    lv_answer = item.code;
                  }
                });
                _gbCourseProvider.saveAssessmentAnswer(widget.tenrollment_instance_tcourse_id, widget.tcourse_content_item_id, lv_answer);

                // Se inicia la aplicación.
                Navigator.of(context).pop();

              }
            )
          ],
        ),
      ),
    );
  }
}
