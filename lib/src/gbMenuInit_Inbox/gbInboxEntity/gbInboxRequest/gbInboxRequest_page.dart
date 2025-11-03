import 'package:flutter/material.dart';
import 'package:goldenbelt/main.dart';
import 'package:goldenbelt/src/_models/gb_trequest_model.dart';
import 'package:goldenbelt/src/_providers/gb_trequest_provider.dart';
import 'package:goldenbelt/src/_env/gbLanguage.dart';
import 'package:goldenbelt/src/_env/gbEnvironment.dart';
import 'package:goldenbelt/src/_env/gbUtils.dart';
import 'package:flutter_html/flutter_html.dart';

import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:crypto/crypto.dart';
import 'package:goldenbelt/src/gbMenuInit_Inbox/gbInboxEntity/gbInboxRequest/gbInboxRequest_AttributeTable_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:aws_client/s3_2006_03_01.dart';
import 'package:path/path.dart' as path;
import 'dart:convert';
import 'dart:typed_data';

// ---------------------------------------------------------------------------------------------------
//
// Esta clase determina la Bandeja (inbox) relacionada con los Formularios.
//
// ===================================================================================================

class gbInboxRequest_page extends StatefulWidget {

  const gbInboxRequest_page(
      {
        Key? key,
        required this.label,
        required this.trequest_instance_id
      }): super(key: key);

  final String label;
  final String trequest_instance_id;

  @override
  State<gbInboxRequest_page> createState() => _gbInboxRequestState();
}

class _gbInboxRequestState extends State<gbInboxRequest_page> {

  gbRequestProvider _gbRequestProvider = new gbRequestProvider() ;
  List<gb_trequest> lst_gb_trequest_provider = [];
  List<gb_trequest> lst_gb_trequest_attribute = [];
  List<gb_trequest_files> lst_gb_trequest_provider_files = [];
  List<gb_trequest_output> lst_gb_trequest_attribute_output = [];

  // Declaración del Idioma.
  gbLanguage gb_lang = new gbLanguage();
  // Declaración del Idioma.
  gbSession gb = gbSessionSettings.gb_getSessionValues();

  @override
  void initState() {
    super.initState();
    get_gbRequestData().then((value) => get_gbFilesImage());

  }

  // Se obtienen los datos de la Entidad.
  Future<void> get_gbRequestData() async
  {
    lst_gb_trequest_provider = await _gbRequestProvider.getRequestData(widget.trequest_instance_id);
    lst_gb_trequest_provider.forEach((item) async
    {
      if (item.att_id != null && mounted)
      {
        setState(() {
          lst_gb_trequest_attribute.add(item);
        });
      }
    });
  }

  void get_gbFilesImage() async
  {
    // Se obtienen los atributos de tipo 'FLE'.
    lst_gb_trequest_provider_files = await _gbRequestProvider.getRequestDataSingleFile(widget.trequest_instance_id);
    lst_gb_trequest_provider_files.forEach((item_file)
    {
      for (var i = 0; i < lst_gb_trequest_attribute.length; i++)
      {
        if (item_file.att_id! + '-0' == lst_gb_trequest_attribute[i].att_id)
          {
            String extension = item_file.att_filename!.split('.').last;
            List<String> img_extensions = ['png', 'jpg', 'jpeg', 'gif', 'bmp'];

            get_S3getSignedUrl(item_file.iiv_id).then((value) =>
                setState(()
                {
                  lst_gb_trequest_attribute[i].att_url_file_saved = value;
                   if (img_extensions.contains(extension)) lst_gb_trequest_attribute[i].att_is_image_file = "1";
                }));

            continue;
          }

      };
    });
  }

  Future<void> save_gbRequestData() async {
    lst_gb_trequest_attribute_output.clear();

    for (var item in lst_gb_trequest_attribute) {
      final item_output = gb_trequest_output(
        att_id: item.att_id,
        att_type: item.att_type,
        att_value: _getAttValueFromItem(item), // lógica centralizada abajo
      );

      lst_gb_trequest_attribute_output.add(item_output);
    }

    // Guardar datos
    await _gbRequestProvider.saveRequestData(widget.trequest_instance_id, lst_gb_trequest_attribute_output).then((_) async {
      lst_gb_trequest_provider_files = await _gbRequestProvider.getRequestDataSingleFile(widget.trequest_instance_id);
      for (var item in lst_gb_trequest_provider_files) {
        upload_process(item.att_id, item.iiv_id, item.att_filename);
      }
    });
  }

  String _getAttValueFromItem(gb_trequest item) {
    if (item.att_type == 'TAB' && item.att_elements != null && item.att_elements!.isNotEmpty) {
      // Solo serializamos los rows
      final rows = item.att_elements!.first.rows ?? [];
      return jsonEncode(rows); // convierte a String JSON
    }

    return item.att_value ?? '';
  }

  void upload_process(att_id, iiv_id, filename) async {
    File? file;
    String extension;

    lst_gb_trequest_attribute.forEach((item) {
      // Se ubica al código respectivo del atributo de tipo FLE, para poder hacer el upload asociado.
      if (item.att_id == att_id + "-0") {
        file = item.att_file;
        upload(att_id, iiv_id, filename, file);
      }
    });
  }
    void upload(att_id, iiv_id, filename, File? file) async {

      if (file == null) return;

          var extension = filename.split('.').last;
          final aws_credentials = AwsClientCredentials(accessKey: gbEnvironment.ses_gb_aws_s3_access_key, secretKey: gbEnvironment.ses_gb_aws_s3_secret_key);
          final api = S3(region: gbEnvironment.ses_gb_aws_s3_region, credentials: aws_credentials);
          final key = "doc" + gb.ses_tcompany_id + "/" +  md5.convert(utf8.encode('RQI-IIV:' + iiv_id.toString())).toString();

          //await api.createBucket(bucket: 'my_bucket');
          await api.putObject(
              bucket: gb.ses_aws_s3_bucket ,
              key: key,
              body: file!.readAsBytesSync(),
              contentDisposition: 'attachment; filename="' + htmlEscape.convert(filename) + '"',
              contentType: get_ContentType(extension)
          );
          //File('my_file.png').readAsBytesSync());
          api.close();
  }

  String get_ContentType(pv_filetype)
  {
    switch (pv_filetype)
    {
      case 'pdf': return 'application/pdf';
      case 'doc':
      case 'docx': return 'application/msword';
      case 'xls':
      case 'xlsx': return 'application/vnd.ms-excel';
      case 'ppt':
      case 'pptx': return 'application/vnd.ms-powerpoint';

      case 'gif': return 'image/gif';
      case 'jpg': return 'image/jpg';
      case 'jpeg': return 'image/jpeg';
      case 'png': return 'image/png';

      case 'mpeg': return 'video/mpeg';
      case 'mp4': return 'video/mp4';

      default: return 'application/octet-stream';
    }

  }

  Future? send_gbRequestReceivers()
  {
    save_gbRequestData();
    _gbRequestProvider.sendRequestReceivers(widget.trequest_instance_id);
  }

  Future<File?> pickImage() async {
    try {

      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if(image == null) return null;

      return File(image.path);

    } on PlatformException catch(e) {
      null;
    }
  }
  Future<File?> pickImageCamera() async {
    try {

      final image = await ImagePicker().pickImage(source: ImageSource.camera);

      if(image == null) return null;

      return File(image.path);

    } on PlatformException catch(e) {
      null;
    }
  }

  Future<File?> pickFile() async {
    try {

      final fileTemp = await FilePicker.platform.pickFiles();
      if (fileTemp == null) return null;

      return File(fileTemp!.files.single.path!);

    } on PlatformException catch(e) {
      null;
    }
  }

  Future<void> _selectDate(BuildContext context, index) async {
    DateTime ld_date = DateTime.now();

      String lv_date = lst_gb_trequest_attribute[index].att_value!;
      List<String> la_date = lv_date.split('/');
      String lv_date_formatted = '${la_date[2]}-${la_date[1]}-${la_date[0]}';
      ld_date = DateTime.parse(lv_date_formatted);

      final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: ld_date!,
          firstDate: DateTime(2015),
          lastDate: DateTime(2050)
      );

      if (pickedDate != null && pickedDate != ld_date)
        setState(() {

          String lv_date = pickedDate.toString();
          List<String> la_date = lv_date.split(' ');
          lv_date = la_date[0];
          la_date = lv_date.split('-');
          String lv_date_formatted = '${la_date[2]}/${la_date[1]}/${la_date[0]}';
          lst_gb_trequest_attribute[index].att_value = lv_date_formatted;
        });

  }

  Future<String>  get_S3getSignedUrl(pv_iiv) async
  {
    String S3getSignedUrl =  await _gbRequestProvider.getRequestContentS3getSignedUrl('RQI-IIV', pv_iiv);
    return S3getSignedUrl;
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.label),
        ),
        body: SingleChildScrollView(child: Form(

          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              for (var i = 0; i < lst_gb_trequest_attribute.length; i++)
                //  for ( var item in lst_gb_trequest_attribute )
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                    child: _gbRequestAttribute(lst_gb_trequest_attribute[i], i)
                ),
                SizedBox(height: 50),
                Row( children:
                    [   Spacer(),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFe6e8f4)),
                          child: Text( gb_lang.keyword["lang_gb_save"], style: TextStyle(fontSize: 20, color: Color(0xFF2f3061))),
                          onPressed: () {
                              _formKey.currentState!.validate();
                              // Se graban los datos, considerando el arreglo que se acaba de construir con los datos de salida.
                              save_gbRequestData();

                              Navigator.popUntil(context, ModalRoute.withName('gbMainFrontPage'));

                            }
                        ),
                      Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFe6e8f4)),
                        child: Text( gb_lang.keyword["lang_gb_send"], style: TextStyle(fontSize: 20, color: Color(0xFF2f3061))),
                        onPressed: () {
                          _formKey.currentState!.validate();
                          // Se graban los datos, considerando el arreglo que se acaba de construir con los datos de salida.
                          send_gbRequestReceivers();
                          Navigator.popUntil(context, ModalRoute.withName('gbMainFrontPage'));
                        },
                      ),
                      Spacer()
                    ],
                  ),
              SizedBox(height: 20),
            ],
          ),
        ))
    );
  }

  Widget _gbRequestAttribute(gb_trequest item, int index) {

    switch (item.att_type)
    {

      case 'TIT':
        return Text(item.att_label.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold));

      case 'SEP':

        return Divider();

      case 'GLS':
/*
        List<String> la_urls = ImageLoader().extractUrls(item.att_html!);

        la_urls.forEach((url_img) async {

          final extension = url_img.split('.').last;
          final String base64 = await ImageLoader.loadImageBase64(url_img);

          setState(() {
            item.att_html = item.att_html!.replaceAll(url_img!, "data:image/"+ extension +";base64," + base64!);
          });


        });
*/
        return Html(data:item.att_html!);


      case 'CAL':

        return Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, //
              children: [
                Text(lst_gb_trequest_attribute[index].att_label!, style: TextStyle(fontWeight: FontWeight.bold),),
                Row(
              children: <Widget>[
                MaterialButton(
                  color: Color(0xFFeae4f2),
                  child: const Icon(Icons.calendar_month),
                  onPressed: () => _selectDate(context, index),
                ),
                SizedBox(width: 50),
                Text(lst_gb_trequest_attribute[index].att_value!),

              ],
            )]));

      case 'GBF':
        return Column(
                crossAxisAlignment: CrossAxisAlignment.start, // for left side
                children:[
                      Text(item.att_label.toString(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      Text(item.att_value.toString(),style: TextStyle(fontSize: 12)),
                    ]
                    );
        break;

      case 'TXT':
        return
            Column(
                crossAxisAlignment: CrossAxisAlignment.start, // for left side
                children:
            [
              Text( item.att_label.toString(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              TextFormField(
                  minLines: 1,
                  maxLines: 1,
                  validator: (value) {
                    lst_gb_trequest_attribute[index].att_value = value;

                    return null;
                  },
                  initialValue: item.att_value.toString(),
                  style: TextStyle(color: Colors.black87, fontSize: 12, fontFamily: 'AvenirLight'),
                  decoration: InputDecoration(
                                suffix: GestureDetector(
                                          onTap: () { },
                                          child: Text("", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
                                        ),
                                border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                          borderSide: BorderSide(width:1)
                                )
                )
              )
            ]);
          break;

      case 'MTX':
        return
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // for left side
                  children:
              [
                Text( item.att_label.toString(), style: TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.bold)),
                TextFormField(
                    minLines: 5,
                    maxLines: 10,
                    validator: (value) {
                      lst_gb_trequest_attribute[index].att_value = value;

                      return null;
                    },
                    initialValue: item.att_value.toString(),
                    style: TextStyle(color: Colors.black87, fontSize: 12, fontFamily: 'AvenirLight'),
                    decoration: InputDecoration(
                                  suffix: GestureDetector(
                                            onTap: () { },
                                            child: Text("", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
                                          ),
                                  border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                            borderSide: BorderSide(width:1)
                                           )
                ))
              ]);
      case 'LST':
        return
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // for left side
                  children:
              [
                Text( item.att_label.toString(), style: TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.bold)),
                DropdownMenu<String>(
                  initialSelection: item.att_value.toString(),
                  onSelected: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      lst_gb_trequest_attribute[index].att_value = value!;
                    });
                  },
                  dropdownMenuEntries: item.att_lkp!.map<DropdownMenuEntry<String>>((gb_trequest_lkp lkp) {
                    return DropdownMenuEntry<String>(value: lkp.lkp_id!, label: lkp.lkp_label!);
                  }).toList(),
                )
              ]);

      case 'RAD':

        return
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // for left side
                  children:
                  [
                    Text( item.att_label.toString(), style: TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.bold)),
                    Column(
                        children:
                        [ for (var i = 0; i < item.att_lkp!.length; i++)
                          RadioListTile(
                              title: Text(item.att_lkp![i].lkp_label.toString(),  style: TextStyle(color: Colors.black87, fontSize: 12)),
                              value: item.att_lkp![i].lkp_id.toString(),
                              onChanged: (v) {
                                setState(() {
                                  lst_gb_trequest_attribute[index].att_value = v.toString();
                                });
                              },
                              groupValue: lst_gb_trequest_attribute[index].att_value
                          )
                        ])
                  ]);

    case 'MCH':

        return
              Column
              (   crossAxisAlignment: CrossAxisAlignment.start, // for left side
                  children:
                  [
                  Text( item.att_label.toString(), style: TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.bold)),
                  Column(
                    children:
                    [ for (var i = 0; i < item.att_lkp!.length; i++)

                      CheckboxListTile
                      ( title: Text(item.att_lkp![i].lkp_label.toString(),  style: TextStyle(color: Colors.black87, fontSize: 12)),
                        value: item.att_lkp![i].is_checked == '1',
                        onChanged: (newValue)
                        {
                            setState(()
                            { item.att_lkp![i].is_checked = newValue! ? '1' : '0';
                              String v = '';
                              for (var i = 0; i < item.att_lkp!.length; i++)
                              {
                                if (item.att_lkp![i].is_checked == '1') v = v + item.att_lkp![i].lkp_id.toString() + ',';
                                lst_gb_trequest_attribute[index].att_value = v.toString().substring(0, v.toString().length - (v.toString().length > 0 ? 1 : 0));
                              }
                            });
                        },
                        controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                      )
                    ])
                  ]);
      case 'FLE':

        return Column(
          //crossAxisAlignment: CrossAxisAlignment.start, // for left side
          children: [
            Text( item.att_label.toString(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            item.att_is_image_file != null && item.att_url_file_saved != null && item.att_is_image_file == '1' && item.att_url_file_saved != "" ?  Image.network(item.att_url_file_saved!) : SizedBox(),
            item.att_is_image_file != null && item.att_url_file_saved == null && item.att_is_image_file == '1' ? Image.file(lst_gb_trequest_attribute[index].att_file!) : SizedBox(),

                lst_gb_trequest_attribute[index].att_value != null && lst_gb_trequest_attribute[index].att_value == ""
                ? Text(gb_lang.keyword["lang_gb_without_information"]) :

                  lst_gb_trequest_attribute[index].att_is_image_file != null && lst_gb_trequest_attribute[index].att_is_image_file == '0' ?
                  Text(lst_gb_trequest_attribute[index].att_value.toString()) : SizedBox(),

            Row(
                children:[
                  MaterialButton(
                      color: Color(0xFFeae4f2),
                      child: Row(children:[ Icon(Icons.camera_alt), Icon(Icons.upload)]),
                      onPressed: () async {
                        lst_gb_trequest_attribute[index].att_file = await pickImageCamera() ?? null;

                        if ( lst_gb_trequest_attribute[index].att_file != null) {
                          setState(() {
                            lst_gb_trequest_attribute[index].att_value =
                                path.basename(
                                    lst_gb_trequest_attribute[index].att_file!
                                        .path);
                            lst_gb_trequest_attribute[index].att_is_image_file =
                            "1";
                            lst_gb_trequest_attribute[index].att_url_file_saved =
                            null;

                          });
                        }
                      }
                  ),
                  SizedBox(width:10),
                MaterialButton(
                      color: Color(0xFFeae4f2),
                      child: Row(children:[ Icon(Icons.image_outlined), Icon(Icons.upload)]),
                      onPressed: () async {
                        lst_gb_trequest_attribute[index].att_file = await pickImage() ?? null;

                        if ( lst_gb_trequest_attribute[index].att_file != null) {
                          setState(() {
                            lst_gb_trequest_attribute[index].att_value =
                                path.basename(
                                    lst_gb_trequest_attribute[index].att_file!
                                        .path);
                            lst_gb_trequest_attribute[index].att_is_image_file =
                            "1";
                            lst_gb_trequest_attribute[index].att_url_file_saved =
                            null;

                          });
                        }
                      }
                  ),
                  SizedBox(width:10),
                  MaterialButton(
                      color: Color(0xFFeae4f2),
                      child: Row(children:[ Icon(Icons.text_snippet), Icon(Icons.upload)]),
                      minWidth: 20,

                      onPressed: () async {
                        lst_gb_trequest_attribute[index].att_file = await pickFile();

                        if ( lst_gb_trequest_attribute[index].att_file != null) {
                          setState(() {
                            lst_gb_trequest_attribute[index].att_value =
                                path.basename(
                                    lst_gb_trequest_attribute[index].att_file!
                                        .path);
                            lst_gb_trequest_attribute[index].att_is_image_file =
                            "0";
                            lst_gb_trequest_attribute[index].att_url_file_saved =
                            null;

                          });
                        }
                      }
                  )
                ]
            )  ,
          ],
        );

      case 'TAB':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.att_label.toString(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            gbInboxRequest_AttributeTable_page(
              element: item.att_elements!.first,
              onChanged: (updatedRows) {
                setState(() {
                  item.att_elements!.first.rows = updatedRows;
                });
              },
            ),
          ],
        );

      default:
        return Text(item.att_label.toString());
    }

  }
}

