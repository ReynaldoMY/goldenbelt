import 'package:flutter/material.dart';
import 'package:goldenbelt/src/_env/gbEnvironment.dart';
import 'package:goldenbelt/src/_env/gbLanguage.dart';
import 'package:goldenbelt/src/gbMenuInit_Groups/gbMenuInit_Groups_page.dart';
import 'package:goldenbelt/src/gbMenuInit_Person/gbMenuInit_Person_page.dart';
import 'package:goldenbelt/src/gbMenuInit_Settings/gbMenuInit_Settings_page.dart';
import 'package:goldenbelt/src/gbMenuInit_Inbox/gbMenuInit_Inbox_page.dart';
import 'package:goldenbelt/src/_models/gb_notification_model.dart';
import 'package:goldenbelt/src/_models/gb_tgroup_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class gbMainFrontPage extends StatefulWidget {
  const gbMainFrontPage
      ({ Key? key, required this.ln_event_index_page, required this.lo_event_gb_notification}): super(key: key);

  final gb_notification lo_event_gb_notification;
  final int ln_event_index_page;

  @override
  State<gbMainFrontPage> createState() => _gbMainFrontPageState();
}

class _gbMainFrontPageState extends State<gbMainFrontPage> {


  // Declaración del Idioma.
  gbSession gb = gbSessionSettings.gb_getSessionValues();
  gbLanguage gb_lang = gbSessionSettings.gb_getLanguage();
  // Declaración del Idioma.
  //gbLanguage gb_lang = new gbLanguage();

  int ln_index_page = 0;
  int ln_count_group_pending = 0;
  int ln_count_inbox_pending = 0;
  String lv_notification_type = "";
  gb_tgroup lo_gb_tgroup = new gb_tgroup();

  List<String>? destinationLabels;

  @override
  void initState()  {

    super.initState();

    // En caso de los Grupos, se inicializan las variables desde la Notificación.
    lo_gb_tgroup.tgroup_id = widget.lo_event_gb_notification.tgroup_id;
    lo_gb_tgroup.groupname = widget.lo_event_gb_notification.groupname;
    lo_gb_tgroup.last_datetime = widget.lo_event_gb_notification.last_datetime;
    // En caso que se requiera ir a la Bandeja o específicamente a las tareas.
    lv_notification_type = widget.lo_event_gb_notification.notification_type!;

    ln_index_page = widget.ln_event_index_page;
    ln_count_group_pending = int.parse(gb.ses_group_count_chat_pending);
    ln_count_inbox_pending = int.parse(gb.ses_inbox_count_pending);

    _updateWidgetMainLabels(0);

    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage)
    {
      gb_tgroup lo_event_gb_tgroup = gb_tgroup.fromJson(remoteMessage.data);
      print(remoteMessage.data);
      print(lo_event_gb_tgroup.tgroup_id);

      setState(() => this.ln_count_group_pending++);
    });

  }

  void _updateGroupCountChatPending(int count) {
    setState(() {
      ln_count_group_pending = count;
    });
  }

  void _updateInboxCountPending(int count) {
    setState(() {
      ln_count_inbox_pending = count;
    });
  }

  void _updateWidgetMainLabels(int count) {
    setState(() {
      destinationLabels =
      [ gb_lang.keyword["lang_gb_menu_home"],
        gb_lang.keyword["lang_gb_menu_inbox"],
        gb_lang.keyword["lang_gb_menu_groups"],
        gb_lang.keyword["lang_gb_menu_settings"]];
    });
  }

  Widget getPage(int index) {

    switch (index)
    {
      case 0: return gbPersonFrontPage();
      case 1: return gbInboxPage(updateInboxCountPending: _updateInboxCountPending);
      case 2:
        // Se inicializan los valores una vez utilizados.
        gb_tgroup lo_gb_tgroup_current = lo_gb_tgroup;
        lo_gb_tgroup = gb_tgroup();

        return gbGroupsPage(lo_event_gb_tgroup: lo_gb_tgroup_current, updateGroupCountChatPending: _updateGroupCountChatPending);

      case 3: return gbSettingsPage(updateWidgetMainLabels: _updateWidgetMainLabels);

      default:
        return gbSettingsPage(updateWidgetMainLabels: _updateWidgetMainLabels);
    }

  }

  @override
  Widget build(BuildContext context) {
          return Scaffold
            (body: getPage(ln_index_page),

            bottomNavigationBar: NavigationBar
              (height: 60,
              backgroundColor: Color(0xFFf1f5fb),
              selectedIndex: ln_index_page,
              onDestinationSelected: (pn_index_page) =>
                  setState(() => this.ln_index_page = pn_index_page),
              destinations:
              [
                NavigationDestination(icon: Icon(Icons.home_filled),
                    label: destinationLabels![0]),
                NavigationDestination(icon: ( ln_count_inbox_pending == 0 ?
                                            Icon(Icons.inbox):
                                            Badge(label: Text(ln_count_inbox_pending.toString()), child: Icon(Icons.inbox))),
                    label:destinationLabels![1]),
                NavigationDestination(icon: ( ln_count_group_pending == 0 ?
                                            Icon(Icons.chat_bubble_outline):
                                            Badge(label: Text(ln_count_group_pending.toString()), child: Icon(Icons.chat_bubble_outline))),
                    label: destinationLabels![2]),
                NavigationDestination(icon: Icon(Icons.settings),
                    label: destinationLabels![3]),

              ],
            ),
          );
  }
}
