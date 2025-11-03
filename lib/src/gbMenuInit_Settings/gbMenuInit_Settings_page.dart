import 'package:flutter/material.dart';
import 'package:goldenbelt/src/_env/gbEnvironment.dart';
import 'package:goldenbelt/src/_env/gbLanguage.dart';
import 'package:goldenbelt/src/gbLogin/gbLogin_page.dart';
import 'package:goldenbelt/src/gbMenuInit_Settings/gbSettingLanguage/gbSettingEnvironment_page.dart';
import 'package:goldenbelt/src/gbMenuInit_Settings/gbSettingLanguage/gbSettingLanguage_page.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:goldenbelt/src/_providers/gb_tuser_provider.dart';

class gbSettingsPage extends StatefulWidget {
  final Function(int) updateWidgetMainLabels;
  const gbSettingsPage({ Key? key, required this.updateWidgetMainLabels}): super(key: key);

  @override
  State<gbSettingsPage> createState() => _gbSettingsPageState();
}

class _gbSettingsPageState extends State<gbSettingsPage> {

  bool _is_validateVersionUpdate = true;
  // Declaración del Idioma.
  gbSession gb = gbSessionSettings.gb_getSessionValues();
  gbLanguage gb_lang = gbSessionSettings.gb_getLanguage();

  @override
  void initState() {
    super.initState();
    validateVersionUpdate();
  }

  // Procedimiento para validar si es que la versión se ha vuelto obsoleta.
  void validateVersionUpdate() async
  {
    gbUserProvider _gbUserProvider = new gbUserProvider() ;
    _is_validateVersionUpdate = await _gbUserProvider.validateVersionUpdate();

    setState(() {
      if (!_is_validateVersionUpdate)
      { Navigator.pushReplacement( context, MaterialPageRoute(builder: (context) => gbLoginPage(startup_msg:gb_lang.keyword["lang_gb_error_version_obsolete"])));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      Container(
          color: Color(0xFFf2f2f7),
          alignment: Alignment.topCenter, // Ajusta según necesites
          child: Column(
          children: <Widget>[
            SizedBox(height:50),
            Expanded(child:SettingsList(
              sections: [
                SettingsSection(
                  title: Text('General'),
                  tiles: [
                    SettingsTile.navigation(
                      leading: Icon(Icons.language),
                      title: Text(gb_lang.keyword["lang_gb_language"]),
                      value: Text(gb.ses_gb_lang),
                      onPressed: (BuildContext context) {
                        Navigator.of(context).push
                          (MaterialPageRoute(builder: (context) =>
                            gbSettingLanguage_page
                              ())).then((value)
                              {
                                setState(() {
                                  gb_lang = gbSessionSettings.gb_getLanguage();
                                  widget.updateWidgetMainLabels(0);
                                });
                              }
                        );
                      },
                    ),
                  ],
                ),
                SettingsSection(
                  title: Text(gb_lang.keyword["lang_gb_company"]),
                  tiles: [
                    SettingsTile(
                      leading: Icon(Icons.home),
                      title: Text(""),
                      value: Text(gb.ses_company),
                    )],
                ),

                SettingsSection(
                      title: Text(gb_lang.keyword["lang_gb_workspace"]),
                      tiles: [
                        SettingsTile(
                          leading: Icon(Icons.home),
                          title: Text(""),
                          value: Text(gb.ses_workspace),
                        )]),
                SettingsSection(
                  title: Text(""),
                  tiles: [
                        SettingsTile.navigation(
                          leading: Icon(Icons.change_circle_outlined),
                          title: Text(gb_lang.keyword["lang_gb_change_environment"]),
                          value: Text(""),
                          onPressed: (BuildContext context) {
                            Navigator.of(context).push
                              (MaterialPageRoute(builder: (context) =>
                                gbSettingEnvironment_page
                                  ())).then((value)

                            {
                              setState(() {
                                gb_lang = gbSessionSettings.gb_getLanguage();
                              });
                            }
                            );
                          },
                        ),
                  ],
                ),
              ],
            )),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50), backgroundColor: Color(0xFFe6e8f4)),
                child: Text( gb_lang.keyword["lang_gb_close_session"], style: TextStyle(fontSize: 20, color: Color(0xFF2f3061))),
                onPressed: () {

                  gbSessionSettings.configurePrefs();
                  // Se guardan los valores de sesión.
                  gbSessionSettings.prefs.remove('ses_tcompany_id');
                  gbSessionSettings.prefs.remove('ses_tworkspace_id');
                  gbSessionSettings.prefs.remove('ses_tuser_id');
                  gbSessionSettings.prefs.remove('ses_tperson_id');
                  gbSessionSettings.prefs.remove('ses_person_shortname');
                  gbSessionSettings.prefs.remove('ses_person_image');

                  // Se inicia la aplicación.
                  Navigator.pushReplacement( context, MaterialPageRoute(builder: (context) => gbLoginPage(startup_msg:"")));

                },
            ),
            SizedBox(height:50),
          ]
      )
      );
  }
}