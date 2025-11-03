import 'package:flutter/material.dart';
import 'package:goldenbelt/src/_models/gb_tentity_attribute_model.dart';
import 'package:goldenbelt/src/_providers/gb_tentity_attribute_provider.dart';
import 'package:goldenbelt/src/gbMenuInit_Inbox/gbInboxEntity/gbInboxEntityAttribute/gbInboxEntityAttributeView/gbInboxEntityAttributeView_page.dart';
import 'package:goldenbelt/src/gbMenuInit_Inbox/gbInboxEntity/gbInboxEntityAttribute/gbInboxEntityApproval/gbInboxEntityApproval_page.dart';

import 'package:settings_ui/settings_ui.dart';
import 'package:goldenbelt/src/_env/gbLanguage.dart';
import 'package:goldenbelt/src/_env/gbEnvironment.dart';

// ---------------------------------------------------------------------------------------------------
//
// Esta clase determina la Bandeja (inbox) relacionada a los Atributos de las Entidades.
//
// ===================================================================================================

class gbInboxEntityAttribute_page extends StatefulWidget {

  const gbInboxEntityAttribute_page(
      {
        Key? key,
        required this.tentity_label,
        required this.tentity_type,
        required this.tentity_id
      }): super(key: key);

  final String tentity_label;
  final String tentity_type;
  final String tentity_id;

  @override
  State<gbInboxEntityAttribute_page> createState() => _gbInboxEntityAttributeState();
}

class _gbInboxEntityAttributeState extends State<gbInboxEntityAttribute_page> {

  gbEntityAttributeProvider _gbEntityAttributeProvider = new gbEntityAttributeProvider() ;
  List<gb_tentity_attribute> lst_gb_tentity_attribute_provider = [];
  List<gb_tentity_attribute> lst_gb_tentity_attribute = [];

  // Declaración del Idioma.
  gbLanguage gb_lang = gbLanguage();
  // Declaración del Idioma.
  gbSession gb = gbSessionSettings.gb_getSessionValues();

  @override
  void initState() {
    super.initState();
    get_gbEntityData();
  }

  // Se obtienen los datos de la Entidad.
  void get_gbEntityData() async
  {
    lst_gb_tentity_attribute_provider = await _gbEntityAttributeProvider.getEntityData(widget.tentity_type, widget.tentity_id);
    lst_gb_tentity_attribute_provider.forEach((item)
    {
      if (item.label != null && mounted)
      {
        setState(() { lst_gb_tentity_attribute.add(item);});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.tentity_label),
        ),
        floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                child: Icon(
                    Icons.thumb_up
                ),
                onPressed: () {
                  var lv_tentity_id = widget.tentity_id.substring(widget.tentity_id.indexOf('-') + 1);
                  Navigator.of(context).push
                    (MaterialPageRoute(builder: (context) =>
                      gbInboxEntityApproval_page(approval_type: 'APR', tentity_name: widget.tentity_label, tentity_type: widget.tentity_type, tentity_id: lv_tentity_id)
                  ));
                },
                heroTag: null,
              ),
              SizedBox(
                height: 10,
              ),
              FloatingActionButton(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                child: Icon(
                    Icons.thumb_down
                ),
                onPressed: () {
                  var lv_tentity_id = widget.tentity_id.substring(widget.tentity_id.indexOf('-') + 1);
                  Navigator.of(context).push
                    (MaterialPageRoute(builder: (context) =>
                      gbInboxEntityApproval_page(approval_type: 'DNY', tentity_name: widget.tentity_label, tentity_type: widget.tentity_type, tentity_id: lv_tentity_id)
                  ));

                },
                heroTag: null,
              )
            ]
        ),
        body: SettingsList( sections: _gbEntityAttributeSection() )
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

  SettingsSection _gbSection(gb_tentity_attribute lo_gb_tentity_attribute)
  {
    return SettingsSection(
      title: Text(lo_gb_tentity_attribute.label!),
      tiles: _gbEntityAttributeSectionTile(lo_gb_tentity_attribute.data!)
    );
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
                gbInboxEntityAttributeView_page(
                    title: lo_gb_tentity_attribute.label!,
                    html_data: lo_gb_tentity_attribute.value_html!)
            ));
          }
      );
    }
  }

}
