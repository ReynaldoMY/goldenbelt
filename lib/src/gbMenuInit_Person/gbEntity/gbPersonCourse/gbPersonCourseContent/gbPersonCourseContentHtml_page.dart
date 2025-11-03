import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:goldenbelt/src/_providers/gb_tcourse_provider.dart';

class gbPersonCourseContentHtmlView_page extends StatefulWidget {
  const gbPersonCourseContentHtmlView_page(
      { Key? key,
        required this.title,
        required this.tenrollment_instance_tcourse_id,
        required this.tcourse_content_id
      }): super(key: key);

  final String title;
  final String tenrollment_instance_tcourse_id;
  final String tcourse_content_id;

  @override
  State<gbPersonCourseContentHtmlView_page> createState() => _gbPersonCourseContentHtmlView_pageState();
}

class _gbPersonCourseContentHtmlView_pageState extends State<gbPersonCourseContentHtmlView_page> {

  gbCourseProvider _gbCourseProvider = gbCourseProvider();
  var lv_content_html;

  void initState() {

    super.initState();

    get_gbCourseContentHtml().then((value) =>
    setState(() {}));

  }

  Future<void> get_gbCourseContentHtml() async
  {
    lv_content_html = await _gbCourseProvider.getCourseContentItemHtml(widget.tenrollment_instance_tcourse_id, widget.tcourse_content_id);
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: lv_content_html == null ? Column(children:[ SizedBox(height: 100),  Center(child:CircularProgressIndicator())]): Html( data: lv_content_html)));
  }
}
