import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class gbEntityAttributeView_page extends StatefulWidget {
  const gbEntityAttributeView_page(
      { Key? key,
        required this.title,
        required this.html_data
      }): super(key: key);

  final String html_data;
  final String title;

  @override
  State<gbEntityAttributeView_page> createState() => _gbEntityAttributeView_pageState();
}

class _gbEntityAttributeView_pageState extends State<gbEntityAttributeView_page> {
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
