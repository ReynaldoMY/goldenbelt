import 'package:flutter/material.dart';
import 'package:goldenbelt/src/_models/gb_tcourse_model.dart';
import 'package:goldenbelt/src/_providers/gb_tcourse_provider.dart';
import 'package:goldenbelt/src/gbMenuInit_Person/gbEntity/gbPersonCourse/gbPersonCourseContent/gbPersonCourseContent_page.dart';

class gbPersonCourse_page extends StatefulWidget {

  const gbPersonCourse_page(
      {
        Key? key,
        required this.course_label,
        required this.tenrollment_instance_tcourse_id
      }): super(key: key);

  final String course_label;
  final String tenrollment_instance_tcourse_id;


  @override
  State<gbPersonCourse_page> createState() => _gbPersonCoursePageState();
}

class _gbPersonCoursePageState extends State<gbPersonCourse_page> {

  gbCourseProvider _gbCourseProvider = new gbCourseProvider() ;
  List<gb_tenrollment_instance_tcourse> lst_gb_tenrollment_instance_tcourse_provider = [];
  List<gb_tenrollment_instance_tcourse> lst_gb_tenrollment_instance_tcourse = [];

  @override
  void initState() {

    super.initState();
    get_gbEnrollmentInstanceAll();
  }

  void get_gbEnrollmentInstanceAll() async
  {

    lst_gb_tenrollment_instance_tcourse_provider = await _gbCourseProvider.getEnrollmentInstanceAll(widget.tenrollment_instance_tcourse_id);
    lst_gb_tenrollment_instance_tcourse_provider.forEach((item) {

      if (item.tenrollment_instance_tcourse_id != 'null' && mounted)
      {
        setState(() {
          lst_gb_tenrollment_instance_tcourse.add(item);});
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.course_label),
        ),
        body: ListView.builder(
            itemCount: lst_gb_tenrollment_instance_tcourse.length ,
            itemBuilder: (context, index) {
              return
                Card(
                    child: ListTile(
                      leading:
                      Column(mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            CircleAvatar(
                                radius:20,
                                child: Image.asset('assets/img/gb_course_content.png', width:30, height:30), backgroundColor: Color(0xFF61afcb)
                            ),
                          ]),
                      title: Text(lst_gb_tenrollment_instance_tcourse[index].course!, style: TextStyle(fontSize: 14, fontWeight:FontWeight.normal, color: Color(0xFF2e3061))),

                      onTap: ()
                      {
                        Navigator.of(context).push
                          (MaterialPageRoute(builder: (context) =>
                            gbPersonCourseContent_page(
                                course_label: lst_gb_tenrollment_instance_tcourse[index].course!,
                                tenrollment_instance_tcourse_id: lst_gb_tenrollment_instance_tcourse[index].tenrollment_instance_tcourse_id!)
                        ));
                      },
                    )
                );
            }
        )
    );
  }


}
