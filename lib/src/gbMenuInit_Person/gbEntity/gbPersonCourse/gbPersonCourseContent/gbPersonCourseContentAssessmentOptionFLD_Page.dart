import 'package:flutter/material.dart';
import 'package:goldenbelt/src/_env/gbLanguage.dart';
import 'package:goldenbelt/src/_env/gbEnvironment.dart';
import 'package:goldenbelt/src/_providers/gb_tcourse_provider.dart';


class gbPersonCourseContentAssessmentOptionFLD_page extends StatefulWidget {
  const gbPersonCourseContentAssessmentOptionFLD_page(
      { Key? key,
        required this.title,
        required this.tenrollment_instance_tcourse_id,
        required this.tcourse_content_item_id,
        required this.course_content_item,
        required this.answer
      }): super(key: key);

  final String tenrollment_instance_tcourse_id;
  final String tcourse_content_item_id;
  final String title;
  final String course_content_item;
  final String answer;

  @override
  State<gbPersonCourseContentAssessmentOptionFLD_page> createState() => _gbPersonCourseContentAssessmentOptionFLD_pageState();
}

class _gbPersonCourseContentAssessmentOptionFLD_pageState extends State<gbPersonCourseContentAssessmentOptionFLD_page> {

  gbCourseProvider _gbCourseProvider = new gbCourseProvider() ;

  // Declaración del Idioma.
  gbSession gb = gbSessionSettings.gb_getSessionValues();
  gbLanguage gb_lang = new gbLanguage();
  TextEditingController _controller = new TextEditingController();

  @override
  void initState() {

    super.initState();
    gb_lang.setLanguage(gb.ses_gb_lang);
    _controller.text = widget.answer;
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

            TextFormField(
              keyboardType: TextInputType.text,
              controller:_controller,
              decoration: InputDecoration(
                constraints: const BoxConstraints.expand(
                    height: 300, width: 400
                ),
                filled: true,
                contentPadding: const EdgeInsets.all(8),
              ),
              maxLength: 250,
              maxLines: 50,

            ),

            Divider(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50), backgroundColor: Color(0xFFe6e8f4)),
              child: Text( gb_lang.keyword["lang_gb_send_answer"], style: TextStyle(fontSize: 20, color: Color(0xFF2f3061))),

              onPressed: () async {

                var lv_answer = _controller.text;


                await _gbCourseProvider.saveAssessmentAnswer(widget.tenrollment_instance_tcourse_id, widget.tcourse_content_item_id, lv_answer);

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
