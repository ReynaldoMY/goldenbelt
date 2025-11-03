import 'package:flutter/material.dart';
import 'package:goldenbelt/src/_env/gbLanguage.dart';
import 'package:goldenbelt/src/_env/gbEnvironment.dart';
import 'package:goldenbelt/src/_models/gb_inbox_model.dart';
import 'package:goldenbelt/src/_providers/gb_inbox_provider.dart';
import 'package:goldenbelt/src/gbMenuInit_Inbox/gbInboxEntity/gbInboxEntity_page.dart';

import 'package:goldenbelt/src/_providers/gb_tuser_provider.dart';
import 'package:goldenbelt/src/gbLogin/gbLogin_page.dart';

class gbInboxPage extends StatefulWidget {

  final Function(int) updateInboxCountPending;
  const gbInboxPage({ Key? key, required this.updateInboxCountPending}): super(key: key);

  @override
  State<gbInboxPage> createState() => _gbInboxPageState();
}

class _gbInboxPageState extends State<gbInboxPage> {

  bool _is_validateVersionUpdate = true;
  gbInboxProvider _gbInboxProvider = new gbInboxProvider() ;
  List<gb_inbox> lst_gb_inbox_provider = [];
  List<gb_inbox> lst_gb_inbox = [];
  String gb_tcompany_id = "";
  String gb_group_count_chat_pending = "";
  String gb_inbox_count_pending = "";

  // Declaración del Idioma.
  gbSession gb = gbSessionSettings.gb_getSessionValues();
  // Declaración del Idioma.
  gbLanguage gb_lang = new gbLanguage();

  @override
  void initState()  {
    super.initState();
    validateVersionUpdate();
    get_gbInbox();

    gb_lang.setLanguage(gb.ses_gb_lang);
    gb_tcompany_id = gb.ses_tcompany_id;
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


  // Se actualiza la pantalla de los Grupos.
  _refreshWidget(dynamic value)
  {
    setState(() {
      lst_gb_inbox.clear();
      get_gbInbox();
    });
  }

  // Se obtiene el detalle de los Elementos de la Bandeja.
  void get_gbInbox() async
  {
    int ln_count_pending_total = 0;
    lst_gb_inbox_provider = await _gbInboxProvider.getInbox();
    lst_gb_inbox_provider.forEach((item) {


      if (item.value != null && item.value != '' && mounted)
      {
          try {
            setState(()
            {

              // Se utiliza backend con función que ya trae le Navegador de Inbox (se filtra lo que se va a mostrar).
              if ((item.value!).substring(0, 15) == "lang_gb_version")
              {
                // Se obtiene el tipo de Nodo (Folder del Navegador).
                String gbInboxNode = (item.value!).substring(23, 26);
                String gbInboxCount = (item.value!).substring((item.value!).indexOf("(") + 1, (item.value!).indexOf(")"));
                item.count_pending = int.parse(gbInboxCount);

                int ln_factor = 0;
                // Background por default.
                item.backgroundcolor = Color(0xffabd4ff);
                switch (gbInboxNode) {
                  case 'edt': item.value = gb_lang.keyword["lang_gb_version_status_edt"]; ln_factor = 1; break;
                  case 'rev': item.value = gb_lang.keyword["lang_gb_version_status_rev"]; ln_factor = 1; break;
                  case 'apr': item.value = gb_lang.keyword["lang_gb_version_status_apr"]; ln_factor = 1; break;
                  case 'val': item.value = gb_lang.keyword["lang_gb_version_status_val"]; ln_factor = 1; break;
                  case 'mrq': item.value = gb_lang.keyword["lang_gb_version_status_mrq"]; ln_factor = 1; break;
                  case 'fnd':
                    item.value = gb_lang.keyword["lang_gb_version_status_fnd"];
                    item.backgroundcolor = Color(0xfff2f2f3);
                    ln_factor = 1;
                    break;
                  default:
                    item.value = "";
                }
                ln_count_pending_total = ln_count_pending_total + item.count_pending * ln_factor;
                widget.updateInboxCountPending(ln_count_pending_total);

                // Sólo se agregan a la lista los que tengan valores
                if (item.value != "") lst_gb_inbox.add(item);
              }
            });
          } catch (e, s) {
          }
      }
    });

    gb.ses_inbox_count_pending = ln_count_pending_total.toString();
    gbSessionSettings.gb_setSessionValues(gb);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold
      (
        appBar: new AppBar(
            automaticallyImplyLeading: false,
            title: new Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: new Text(gb_lang.keyword["lang_gb_menu_inbox"]),
            )),
      body:
      ListView.builder(
        itemCount: lst_gb_inbox.length ,
        itemBuilder: (context, index) {
          return
            Card(
                color:  Color(0xffd9e7f9),
                child: ListTile(
                    leading: CircleAvatar(
                      radius:18,
                        backgroundColor: lst_gb_inbox[index].backgroundcolor!,
                        backgroundImage: AssetImage('assets/img/gb_icon_' + lst_gb_inbox[index].gb_type! + '.png')
                    ),
                    title: Text(lst_gb_inbox[index].value!, style: TextStyle(color: Color(0xff2f3061), fontWeight: FontWeight.bold)),
                    trailing: (lst_gb_inbox[index].count_pending == 0) ? Text("") : Badge(label: Text(lst_gb_inbox[index].count_pending.toString()), child: Icon(Icons.inbox)),

                  onTap: ()
                  {
                    if (lst_gb_inbox[index].count_pending == 0) return;

                  setState(() {
                    Navigator.of(context).push
                      (MaterialPageRoute(builder: (context) =>
                        gbInboxEntity_page(
                            inbox_entity_label: lst_gb_inbox[index].value!,
                            inbox_entity_type: lst_gb_inbox[index].gb_type!,
                            lst_gb_inbox_entity: lst_gb_inbox[index].data!)
                    )).then(_refreshWidget);
                  });
                  },
                )
            );
        }
      ),

    );
  }
}
