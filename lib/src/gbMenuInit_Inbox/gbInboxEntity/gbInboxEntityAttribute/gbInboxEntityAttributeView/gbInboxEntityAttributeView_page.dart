import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class gbInboxEntityAttributeView_page extends StatefulWidget {
  const gbInboxEntityAttributeView_page(
      { Key? key,
        required this.title,
        required this.html_data
      }): super(key: key);

final String html_data;
  final String title;

  @override
  State<gbInboxEntityAttributeView_page> createState() => _gbInboxEntityAttributeView_pageState();
}

class _gbInboxEntityAttributeView_pageState extends State<gbInboxEntityAttributeView_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text(widget.title),
    centerTitle: true,
    ),
    body: SingleChildScrollView(
    child: Html( data: widget.html_data)));
  }
}
