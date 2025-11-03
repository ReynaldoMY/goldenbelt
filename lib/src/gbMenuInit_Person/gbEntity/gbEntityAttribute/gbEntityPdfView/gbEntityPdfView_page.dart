import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'dart:async';
import 'dart:io';
import 'package:goldenbelt/src/_env/gbLanguage.dart';
import 'package:goldenbelt/src/_env/gbEnvironment.dart';

class gbEntityPdfView_page extends StatefulWidget {
  const gbEntityPdfView_page(
      { Key? key,
        required this.title,
        required this.url
      }): super(key: key);

  final String title;
  final String url;

  @override
  State<gbEntityPdfView_page> createState() => _gbEntityPdfView_pageState();
}

class _gbEntityPdfView_pageState extends State<gbEntityPdfView_page> {

  bool _isLoading = true;

  // Declaración del Idioma.
  gbSession gb = gbSessionSettings.gb_getSessionValues();
  gbLanguage gb_lang = new gbLanguage();

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
        ),

        body: Center(
        child: _isLoading
        ? Center(child: CircularProgressIndicator())
        : const PDF().fromUrl(
          widget.url,
          placeholder: (double progress) => Center(child: CircularProgressIndicator()),
          errorWidget: (dynamic error) => Center(child: Text(gb_lang.keyword["lang_gb_without_information"])),
        ),
    )
    );
  }
}
