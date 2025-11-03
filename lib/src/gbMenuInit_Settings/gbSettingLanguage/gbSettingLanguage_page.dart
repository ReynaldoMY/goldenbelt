import 'package:flutter/material.dart';
import 'package:goldenbelt/src/_env/gbLanguage.dart';
import 'package:goldenbelt/src/_env/gbEnvironment.dart';

class gbSettingLanguage_page extends StatefulWidget {
  const gbSettingLanguage_page(
      { Key? key
      }) : super(key: key);

  @override
  State<gbSettingLanguage_page> createState() =>
      _gbSettingLanguage_pageState();
}

class _gbSettingLanguage_pageState extends State<gbSettingLanguage_page> {

  // Declaración del Idioma.
  gbSession gb = gbSessionSettings.gb_getSessionValues();
  gbLanguage gb_lang = gbSessionSettings.gb_getLanguage();

  List<Map<String, dynamic>> lst_language = [{'name':'Español', 'value':'ES'},{'name':'English', 'value':'EN'}];
  String? lv_language_selected;

  @override
  void initState() {
    super.initState();
    gb_lang.setLanguage(gb.ses_gb_lang);
    lv_language_selected = gb.ses_gb_lang;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(gb_lang.keyword["lang_gb_language"], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFFf3edf7),

      ),
      body:ListView.builder(
          itemCount: lst_language.length ,
          itemBuilder: (context, index) {
            return
              Card(
                  child: ListTile(

                    leading: CircleAvatar(
                        radius:18,
                        backgroundColor: Color(0xfff2f2f3) ,
                        backgroundImage: AssetImage('assets/img/lang' + lst_language[index]['value']! + '.png')
                    ),
                    title: Text(lst_language[index]['name']!, style: TextStyle(fontSize: 14, fontWeight:FontWeight.normal, color: Color(0xFF2e3061))),
                    trailing: lv_language_selected ==  lst_language[index]['value']! ?  Icon(Icons.check) : SizedBox(),

                    onTap: ()
                    {
                      setState(() {
                        gb.ses_gb_lang = lst_language[index]['value']!;
                        lv_language_selected = gb.ses_gb_lang;
                        gbSessionSettings.gb_SetLanguage(gb.ses_gb_lang);
                        gb_lang = gbSessionSettings.gb_getLanguage();
                      });
                    },
                  )
              );
          }
      )
    );
  }
}
