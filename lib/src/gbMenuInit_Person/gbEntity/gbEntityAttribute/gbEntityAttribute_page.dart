import 'package:flutter/material.dart';
import 'package:goldenbelt/src/_models/gb_tentity_attribute_model.dart';
import 'package:goldenbelt/src/_providers/gb_tentity_attribute_provider.dart';
import 'package:goldenbelt/src/_providers/gb_tentity_provider.dart';
import 'package:goldenbelt/src/gbMenuInit_Person/gbEntity/gbEntityAttribute/gbEntityAttributeView/gbEntityAttributeView_page.dart';
import 'package:goldenbelt/src/gbMenuInit_Person/gbEntity/gbEntityAttribute/gbEntityPdfView/gbEntityPdfView_page.dart';
import 'package:goldenbelt/src/gbMenuInit_Person/gbEntity/gbEntityAttribute/gbDocumentDownload/gbDocumentDownload_page.dart';
import 'package:settings_ui/settings_ui.dart';


class gbEntityAttribute_page extends StatefulWidget {

  const gbEntityAttribute_page(
      {
        Key? key,
        required this.entity_label,
        required this.entity_type,
        required this.entity_id
      }): super(key: key);

  final String entity_label;
  final String entity_type;
  final String entity_id;

  @override
  State<gbEntityAttribute_page> createState() => _gbEntityAttributeState();
}

class _gbEntityAttributeState extends State<gbEntityAttribute_page> {

  gbEntityAttributeProvider _gbEntityAttributeProvider = new gbEntityAttributeProvider() ;
  gbEntityProvider _gbEntityProvider = new gbEntityProvider();
  String S3getSignedUrl = "";
  bool is_pdf_file = false;

  List<gb_tentity_attribute> lst_gb_tentity_attribute_provider = [];
  List<gb_tentity_attribute> lst_gb_tentity_attribute = [];

  @override
  void initState() {
    super.initState();
    get_gbEntityData();
  }

  // Se obtienen los datos de la Entidad.
  void get_gbEntityData() async
  {
    lst_gb_tentity_attribute_provider = await _gbEntityAttributeProvider.getEntityData(widget.entity_type, widget.entity_id);
    lst_gb_tentity_attribute_provider.forEach((item)
    {
      if (item.label != null && mounted)
      {
        setState(() { lst_gb_tentity_attribute.add(item);});
      }
    });
  }

  Future<void> get_gbEntityS3SignedUrl() async
  {
    S3getSignedUrl =  await _gbEntityProvider.getEntityS3getSignedUrl(widget.entity_type, widget.entity_id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.entity_label),
        ),
        body:
        SettingsList(
            sections: _gbEntityAttributeSection()
        ),
      floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [

            widget.entity_type != 'DOC' ?
            FloatingActionButton(
              backgroundColor:  Color(0xFFf2f2f7),
              foregroundColor: Colors.red,//Colors.indigo,
              child: Icon(
                  Icons.picture_as_pdf_rounded
              ),
              onPressed: () {
                get_gbEntityS3SignedUrl().then((_) {

                  Navigator.of(context).push
                    (MaterialPageRoute(builder: (context) =>

                      gbEntityPdfView_page(
                          title: widget.entity_label,
                          url: S3getSignedUrl)
                  ));

                });

              },
              heroTag: null,
            )
            :
            FloatingActionButton(
              backgroundColor:  Color(0xFFf2f2f7),
              foregroundColor: Colors.indigo,
              child: Icon(
                  Icons.attach_file
              ),
              onPressed: () {
                get_gbEntityS3SignedUrl().then((_) {

                  Navigator.of(context).push
                    (MaterialPageRoute(builder: (context) =>

                      gbDocumentDownload_page(
                          title: widget.entity_label,
                          tdocument_id: widget.entity_id,
                          url: S3getSignedUrl)
                  ));

                });

              },
              heroTag: null,
            )
          ]
      )
    );
  }

  // Listado de las Clases de Atributos.
  List <SettingsSection> _gbEntityAttributeSection()
  {
    List <SettingsSection> gbEntityAttributeSection = [];
    for(var i=0;i<lst_gb_tentity_attribute.length;i++)
    {
      gbEntityAttributeSection.add(_gbSection(lst_gb_tentity_attribute[i]));
    }
    return gbEntityAttributeSection;
  }

  // Listado de las Clases de Atributos.
  List <SettingsTile> _gbEntityAttributeSectionTile(List<gb_tentity_attribute> lo_lst_gb_tentity_attribute)
  {
    List <SettingsTile> gbEntityAttributeSectionTile = [];
    for(var i=0;i<lo_lst_gb_tentity_attribute.length;i++)
    {
      gbEntityAttributeSectionTile.add(_gbSectionTile(lo_lst_gb_tentity_attribute[i]));
    }
    return gbEntityAttributeSectionTile;
  }

  SettingsSection _gbSection(gb_tentity_attribute lo_gb_tentity_attribute)
  {
    return SettingsSection(
        title: Text(lo_gb_tentity_attribute.label!),
        tiles: _gbEntityAttributeSectionTile(lo_gb_tentity_attribute.data!)
    );
  }

  SettingsTile _gbSectionTile(gb_tentity_attribute lo_gb_tentity_attribute)
  {
    if (lo_gb_tentity_attribute.value_html!.length == 0)
    {
      return SettingsTile(
        title: Text(lo_gb_tentity_attribute.label ?? ""),
        value: Text(lo_gb_tentity_attribute.value!),
      );
    }
    else {
      return SettingsTile.navigation(
          title: Text(lo_gb_tentity_attribute.label ?? ""),
          value: Text(""),
          onPressed: (BuildContext context) {

            Navigator.of(context).push
              (MaterialPageRoute(builder: (context) =>

                gbEntityAttributeView_page(
                    title: lo_gb_tentity_attribute.label!,
                    html_data: lo_gb_tentity_attribute.value_html!)
            ));
          }
      );
    }
  }

}
