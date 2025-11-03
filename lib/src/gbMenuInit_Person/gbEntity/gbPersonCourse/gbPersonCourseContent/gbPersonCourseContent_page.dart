import 'package:flutter/material.dart';
import 'package:goldenbelt/src/_models/gb_tcourse_model.dart';
import 'package:goldenbelt/src/_providers/gb_tcourse_provider.dart';
import 'package:goldenbelt/src/gbMenuInit_Person/gbEntity/gbPersonCourse/gbPersonCourseContent/gbPersonCourseContentHtml_page.dart';
import 'package:goldenbelt/src/gbMenuInit_Person/gbEntity/gbPersonCourse/gbPersonCourseContent/gbPersonCourseContentVideo_page.dart';
import 'package:goldenbelt/src/gbMenuInit_Person/gbEntity/gbPersonCourse/gbPersonCourseContent/gbPersonCourseContentAssessment_page.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:goldenbelt/src/_env/gbLanguage.dart';
import 'package:goldenbelt/src/_env/gbEnvironment.dart';

class gbPersonCourseContent_page extends StatefulWidget {

  const gbPersonCourseContent_page(
      {
        Key? key,
        required this.course_label,
        required this.tenrollment_instance_tcourse_id
      }): super(key: key);

  final String course_label;
  final String tenrollment_instance_tcourse_id;


  @override
  State<gbPersonCourseContent_page> createState() => _gbPersonCourseContentPageState();
}

class _gbPersonCourseContentPageState extends State<gbPersonCourseContent_page> {

  gbCourseProvider _gbCourseProvider = new gbCourseProvider() ;
  List<gb_tcourse_content> lst_gb_tcourse_content_provider = [];
  List<gb_tcourse_content> lst_gb_tcourse_content = [];

  List _elements = [];

  // Declaración del Idioma.
  gbSession gb = gbSessionSettings.gb_getSessionValues();
  gbLanguage gb_lang = new gbLanguage();

  @override
  void initState() {

    super.initState();
    get_gbCourseContentAll();

  }

  void get_gbCourseContentAll() async
  {

    lst_gb_tcourse_content_provider = await _gbCourseProvider.getCourseContentAll(widget.tenrollment_instance_tcourse_id);
    lst_gb_tcourse_content_provider.forEach((item) {

      if (item.tcourse_content_id != 'null' && mounted)
      {
        setState(() {
          lst_gb_tcourse_content.add(item);
          _elements.add(
              { "tcourse_content_id":item.tcourse_content_id,
                "name":item.course_content,
                "group":item.course_title,
                "content_html":item.content_html,
                "is_finished": item.is_finished,
                "course_content_type_lk":item.course_content_type_lk,
                "filetype":item.filetype});
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course_label),
      ),
        body: GroupedListView<dynamic, String>(
          elements: _elements,
          groupBy: (element) => element['group'],
          groupComparator: (value1, value2) => value2.compareTo(value1),
          itemComparator: (item1, item2) =>
              item1['name'].compareTo(item2['name']),
          order: GroupedListOrder.DESC,
          useStickyGroupSeparators: true,
          groupSeparatorBuilder: (String value) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          itemBuilder: (c, element) {
            return Card(
              elevation: 8.0,
              margin:
              const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: SizedBox(
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  leading:
                  Column(mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        CircleAvatar(
                            radius:20,
                            child: Image.asset(_CourseIconImage(element['course_content_type_lk'], element['filetype']), width:30, height:30), backgroundColor: Color(0xFF61afcb)
                        ),
                      ]),
                  //const Icon(Icons.account_circle),
                  title: Text(element['name'], style:  const TextStyle(fontSize: 14)),
                  trailing:
                  Column(children:[
                    const Icon(Icons.arrow_right),
                    SizedBox(height:10),
                    _CourseStatus(element['is_finished'])
                  ]),
                  onTap: ()
                  { gbNavigateContent(element, context);},
                ),
              ),

            );
          },
        ),
    );
  }
Widget _CourseStatus(is_finished)
{
  String lv_label = "";
  Color color_bg = Colors.blue;

  switch (is_finished) {
    case '0':
      lv_label = gb_lang.keyword["lang_gb_course_status_started"];
      color_bg = Color(0xFFf17c37);
      break;
    case '1':
      lv_label = gb_lang.keyword["lang_gb_course_status_finished"];
      color_bg = Color(0xFF00994c);
      break;
    case '2':
      lv_label = gb_lang.keyword["lang_gb_course_status_pending"];
      color_bg = Color(0xFFf1184c);
      break;
  }

  return Stack(
      alignment: Alignment.center,
      children:[
        SizedBox(width:80, height:20, child: Container(color: color_bg)),
        Text(lv_label, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
        ]

  );

}

  String _CourseIconImage(String pv_type, String pv_filetype)
  {
    String lv_type = pv_type;

    if (pv_filetype != '') {
      lv_type = 'FLE';
    }

    switch (lv_type)
    {
      case 'CNT':
        return 'assets/img/gb_course_content.png';
        break;

      case 'ASM':
        return 'assets/img/gb_assess_test.png';
        break;

      case 'FLE':
        return 'assets/img/gb_assess_video.png';
        break;

      default:
        return 'assets/img/gb_course_content.png';
    }
  }

  void gbNavigateContent(Map element, BuildContext context)
  {
    // En caso sea una Evaluación.
    if (element['course_content_type_lk'] == 'ASM')
    {
      Navigator.of(context).push
        (MaterialPageRoute(builder: (context) =>
          gbPersonCourseContentAssessment_page(
              title: element['name'],
              tenrollment_instance_tcourse_id: widget.tenrollment_instance_tcourse_id,
              tcourse_content_id: element["tcourse_content_id"]
          )
      ));
      return;
    }
    // En caso sea un video.
    if (element['filetype'] == 'mp4')
    {
      Navigator.of(context).push
        (MaterialPageRoute(builder: (context) =>
          gbPersonCourseContentVideoView_page(
              title: element['name'],
              content_html: element["content_html"],
              tcourse_content_id: element["tcourse_content_id"]
          )
      ));
      return;
    }
    // En caso por defecto, se muestra el formato HTML.
      Navigator.of(context).push
        (MaterialPageRoute(builder: (context) =>
          gbPersonCourseContentHtmlView_page(
              title: element['name'],
              tenrollment_instance_tcourse_id: widget.tenrollment_instance_tcourse_id,
              tcourse_content_id: element["tcourse_content_id"]
          )
      ));

  }

}
