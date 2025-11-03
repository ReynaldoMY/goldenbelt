import 'package:flutter/material.dart';
import 'package:goldenbelt/src/_env/gbLanguage.dart';
import 'package:goldenbelt/src/_env/gbEnvironment.dart';
import 'package:goldenbelt/src/_providers/gb_tcourse_provider.dart';

import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:aws_client/s3_2006_03_01.dart';


class gbPersonCourseContentAssessmentOptionFLE_page extends StatefulWidget {
  const gbPersonCourseContentAssessmentOptionFLE_page(
      { Key? key,
        required this.title,
        required this.tenrollment_instance_tcourse_id,
        required this.tcourse_content_item_id,
        required this.course_content_item,
        required this.filename,
        required this.filename_instance_id,
        required this.is_image_file
      }): super(key: key);

  final String tenrollment_instance_tcourse_id;
  final String tcourse_content_item_id;
  final String title;
  final String course_content_item;
  final String filename;
  final String filename_instance_id;
  final bool is_image_file;

  @override
  State<gbPersonCourseContentAssessmentOptionFLE_page> createState() => _gbPersonCourseContentAssessmentOptionFLE_pageState();
}

class _gbPersonCourseContentAssessmentOptionFLE_pageState extends State<gbPersonCourseContentAssessmentOptionFLE_page> {

  gbCourseProvider _gbCourseProvider = new gbCourseProvider() ;

  // Declaración del Idioma.
  gbSession gb = gbSessionSettings.gb_getSessionValues();
  gbLanguage gb_lang = new gbLanguage();

  bool isImageFile = false;
  bool isImageFileSaved = false;
  File? file;
  String filename = "";
  FilePickerResult? fileTemp;
  String extension = "";
  String file_fromUrl = "";

  @override
  void initState() {

    super.initState();
    gb_lang.setLanguage(gb.ses_gb_lang);

    // Se valida si el archivo es una imagen para poder recuperarla y mostrarla.
    if (widget.filename != "" && widget.is_image_file)
    {
      // Se obtiene la ruta certificada de la imagen para mostrarla.
      get_S3getSignedUrl().then((value) =>
      {
        setState((){
          file_fromUrl = value;
          isImageFileSaved ??= true;
          filename = "";
        })
      });
    }
    else {
      filename = widget.filename;
    }

  }

  Future<String>  get_S3getSignedUrl() async
  {
    String S3getSignedUrl =  await _gbCourseProvider.getCourseS3getSignedUrl('EIF-FLE', widget.filename_instance_id);
    return S3getSignedUrl;
  }

  Future pickImageCamera() async {
    try {

      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if(image == null) return;
      final imageTemp = File(image.path);
      setState((){
        this.isImageFile = true;
        this.filename = image.name;
        this.file = imageTemp;
        this.extension = filename.split('.').last;
        this.file_fromUrl = "";
      });
    } on PlatformException catch(e) {
      null;
    }
  }

  Future pickImage() async {
    try {

      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null) return;
      final imageTemp = File(image.path);
      setState((){
        this.isImageFile = true;
        this.filename = image.name;
        this.file = imageTemp;
        this.extension = filename.split('.').last;
        this.file_fromUrl = "";
      });
    } on PlatformException catch(e) {
      null;
    }
  }

  Future pickFile() async {
    try {
      final fileTemp = await FilePicker.platform.pickFiles();
      if (fileTemp == null) return;
      file = File(fileTemp!.files.single.path!);
      setState((){
        this.isImageFile = false;
        this.filename = fileTemp!.files.single.name;
        this.extension = fileTemp!.files.single.extension!;
        this.file_fromUrl = "";
        this.file = file;
      });
    } on PlatformException catch(e) {
      null;
    }
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

 Future<String> saveAssessmentAnswerHtml() async
 {
   String lv_id = await _gbCourseProvider.saveAssessmentAnswer(widget.tenrollment_instance_tcourse_id, widget.tcourse_content_item_id, filename);

   return lv_id;
 }

  void upload(id) async {

    final aws_credentials = AwsClientCredentials(accessKey: gbEnvironment.ses_gb_aws_s3_access_key, secretKey: gbEnvironment.ses_gb_aws_s3_secret_key);
    final api = S3(region: gbEnvironment.ses_gb_aws_s3_region, credentials: aws_credentials);
    final key = "doc" + gb.ses_tcompany_id + "/" +  md5.convert(utf8.encode('EIF-FLE:' + id.toString())).toString();

    //await api.createBucket(bucket: 'my_bucket');
    await api.putObject(
        bucket: gb.ses_aws_s3_bucket,
        key: key,
        body: file!.readAsBytesSync(),
          contentDisposition: 'attachment; filename="' + filename + '"',
        contentType: get_ContentType(extension)
    );
        //File('my_file.png').readAsBytesSync());
    api.close();

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

            Text(widget.course_content_item, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Divider(),

            file_fromUrl == "" ? SizedBox() : Image.network(file_fromUrl, fit: BoxFit.fitWidth,  width: 200),
            filename == null ? Column(children: [SizedBox(height: 10), Text(gb_lang.keyword["lang_gb_without_information"]), SizedBox(height: 10)]) :
            isImageFile ? Image.file(file!, fit: BoxFit.fitWidth,  width: 200 ) :
                              Text(filename, style: TextStyle(fontWeight: FontWeight.bold)),

            Divider(),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[

                MaterialButton(
                    color: Color(0xFFeae4f2),
                    child: Row(children:[ Icon(Icons.camera_alt), Icon(Icons.upload)]),
                    onPressed: () async {
                      pickImageCamera();
                      }

                ),
                SizedBox(width:10),
                MaterialButton(
                    color: Color(0xFFeae4f2),
                    child: Row(children:[ Icon(Icons.image_outlined), Icon(Icons.upload)]),
                    onPressed: () async {
                      pickImage();
                    }
                ),
                SizedBox(width:10),
                MaterialButton(
                    color: Color(0xFFeae4f2),
                    child: Row(children:[ Icon(Icons.text_snippet), Icon(Icons.upload)]),
                    minWidth: 20,

                    onPressed: () async {
                      pickFile();

                    }
                )
              ]
            )  ,
            Divider(),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50), backgroundColor: Color(0xFFe6e8f4)),
                child: Text( gb_lang.keyword["lang_gb_send_answer"], style: TextStyle(fontSize: 20, color: Color(0xFF2f3061))),
              onPressed: () {

              if (file != null)
              {
                saveAssessmentAnswerHtml().then((id)
                {
                    upload(id);
                });

              }

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
