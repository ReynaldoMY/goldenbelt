import 'dart:io';
import 'package:flutter/material.dart';
import 'package:goldenbelt/src/_env/gbEnvironment.dart';
import 'package:goldenbelt/src/_env/gbUtils.dart';
import 'package:goldenbelt/src/_env/gbLanguage.dart';
import 'package:dio/dio.dart';
import 'package:goldenbelt/src/_models/gb_tentity_model.dart';

import 'package:goldenbelt/src/gbMenuInit_Person/gbEntity/gbEntityAttribute/gbDocumentDownload/gbDocumentDownloadProgress.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_filex/open_filex.dart';
import 'package:goldenbelt/src/_providers/gb_tentity_provider.dart';
import 'package:settings_ui/settings_ui.dart';

class FileDownload {
  Dio dio = Dio();
  bool isSuccess = false;
  String result_filename = "";

  void startDownloading(pv_fileName, pv_url, BuildContext context,
      final Function okCallback) async {
    String fileName = (pv_fileName == "") ? "archivo_descarga.docx" : pv_fileName;
    String baseUrl = pv_url;
    String path = await gbFileHandler().getLocalFilePath(fileName);

    try {
      await dio.download(
        baseUrl,
        path,
        onReceiveProgress: (receivedBytes, totalBytes) {
          okCallback(receivedBytes, totalBytes);
        },
        deleteOnError: true,
      ).then((_) {
        isSuccess = true;
        result_filename = path;
      });
    } catch (e) {
      print("Exception$e");
    }

    if (isSuccess) {
      this.result_filename = path;
      Navigator.pop(context);
    }
  }
}

class gbDocumentDownload_page extends StatefulWidget {

  const gbDocumentDownload_page(
      { Key? key,
        required this.title,
        required this.tdocument_id,
        required this.url
      }): super(key: key);

  final String title;
  final String url;
  final String tdocument_id;

  @override
  State<gbDocumentDownload_page> createState() => _gbDocumentDownload_pageState();
}

class _gbDocumentDownload_pageState extends State<gbDocumentDownload_page> {

  // Declaración del Idioma.
  gbSession gb = gbSessionSettings.gb_getSessionValues();
  gbLanguage gb_lang = gbSessionSettings.gb_getLanguage();

  gbEntityProvider _gbEntityProvider = new gbEntityProvider();
  gb_tdocument? _gb_tdocument;
  gb_tdocument _gb_tdocument_label = new gb_tdocument(id: "", docname: "", filename_pub: "", filesize_pub: "", file_ext_pub:"", file_exists: "0");
  String result_path = "";

  @override
  void initState() {
    print(widget.title);
    print(widget.url);
    print(widget.tdocument_id);
    super.initState();
    get_gbEntitySpecificDocumentData();
  }

  // Se obtienen los datos de la Entidad.
  void get_gbEntitySpecificDocumentData() async
  {
    _gb_tdocument = await _gbEntityProvider.getEntitySpecificDocumentData('DOC', widget.tdocument_id);
    setState(() {
      _gb_tdocument_label = _gb_tdocument!;
      if (_gb_tdocument_label.filename_pub == "null") {

        _gb_tdocument_label.file_exists = '0';
        _gb_tdocument_label.filename_pub =
        gb_lang.keyword["lang_gb_without_information"];
        _gb_tdocument_label.filesize_pub =
        gb_lang.keyword["lang_gb_without_information"];
        _gb_tdocument_label.file_ext_pub =
        gb_lang.keyword["lang_gb_without_information"];
      }
      else
      {
        _gb_tdocument_label.file_exists = '1';
        _gb_tdocument_label.file_ext_pub = _gb_tdocument_label!.filename_pub!.split('.').last;
      }
      get_gbGetLocalFilePath();
    });
  }

  void get_gbGetLocalFilePath() async
  {
    result_path = await gbFileHandler().getLocalFilePath(_gb_tdocument!.filename_pub!);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(gb_lang.keyword["lang_gb_file_attachment"]),
      ),
      body:
      Container(
        color: Color(0xFFf2f2f7),
        alignment: Alignment.topCenter, // Ajusta según necesites
        child: Column(
            children: <Widget>[
              SizedBox(height:10),
              Expanded(
                child:SettingsList(
                    sections: [
                      SettingsSection(
                                title: Text(gb_lang.keyword["lang_gb_document"]),
                                  tiles: [
                                    SettingsTile(
                                      title: Text(_gb_tdocument_label!.docname!),
                                    ),
                                  ],
                      ),
                      SettingsSection(
                        title: Text(gb_lang.keyword["lang_gb_file_name"]),
                        tiles: [
                          SettingsTile(
                            title: Text(_gb_tdocument_label!.filename_pub!),
                          ),
                        ],
                      ),
                      SettingsSection(
                        title: Text(gb_lang.keyword["lang_gb_file_extension"]),
                        tiles: [
                          SettingsTile(
                            title: Text(_gb_tdocument_label!.file_ext_pub!),
                          ),
                        ],
                      ),
                      SettingsSection(
                        title: Text(gb_lang.keyword["lang_gb_file_size"]),
                        tiles: [
                          SettingsTile(
                            title: Text(_gb_tdocument_label!.filesize_pub!),
                          ),
                        ],
                      )
                    ])
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50), backgroundColor: Color(0xFFe6e8f4)),
                  child: Text( gb_lang.keyword["lang_gb_file_view"], style: TextStyle(fontSize: 20, color: Color(0xFF2f3061))),
                  onPressed: () async
                  {
                      if (_gb_tdocument_label!.docname! != null || _gb_tdocument_label!.docname! != "")
                      {
                        bool result = await _permissionRequest();
                        if (result)
                        {
                            if (_gb_tdocument_label.file_exists == "1") {
                              showDialog(
                                  context: context,
                                  builder: (dialogcontext) {
                                    return DownloadProgressDialog(
                                        filename: _gb_tdocument_label!
                                            .filename_pub!, url: widget.url);
                                  }).
                              then((value) {
                                var filename = this.result_path;

                                if (_gb_tdocument_label.file_exists == "1") {
                                  OpenFilex.open(filename);
                                }
                              });
                            }
                        }/*
                        else
                        {
                          print(gb_lang.keyword["lang_gb_without_information"]);
                        }*/
                      }
                  }),

              SizedBox(height:50),

    ],
        ),
      ),
    );
  }

  /*static Future<bool> _permissionRequest() async {
    PermissionStatus result;
    result = await Permission.storage.request();
    if (result.isGranted) {
      return true;
    } else {
      return false;
    }
  }*/
  static Future<bool> _permissionRequest() async {
    if (Platform.isAndroid) {
      if (await Permission.manageExternalStorage.isGranted) {
        return true;
      }

      var status = await Permission.manageExternalStorage.request();
      return status.isGranted;
    } else {
      // En iOS u otros, no se requiere este permiso
      return true;
    }
  }
}