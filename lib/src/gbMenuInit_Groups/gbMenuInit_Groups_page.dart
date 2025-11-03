import 'package:flutter/material.dart';
import 'package:goldenbelt/src/_models/gb_tgroup_model.dart';
import 'package:goldenbelt/src/_providers/gb_tgroup_provider.dart';
import 'package:goldenbelt/src/gbMenuInit_Groups/gbGroupsChat/gbGroupsChat_page.dart';
import 'package:goldenbelt/src/_env/gbLanguage.dart';
import 'package:goldenbelt/src/_env/gbEnvironment.dart';
import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:goldenbelt/src/_providers/gb_tuser_provider.dart';
import 'package:goldenbelt/src/gbLogin/gbLogin_page.dart';

class gbGroupsPage extends StatefulWidget {

  final Function(int) updateGroupCountChatPending;
  const gbGroupsPage
      ({ Key? key, required this.lo_event_gb_tgroup, required this.updateGroupCountChatPending}): super(key: key);

  final gb_tgroup lo_event_gb_tgroup;

  @override
  State<gbGroupsPage> createState() => _gbGroupsPageState();
}

class _gbGroupsPageState extends State<gbGroupsPage> {

  bool _is_validateVersionUpdate = true;
  // Se crea la sesión en la BD.
  gbGroupsProvider _gbGroupsProvider = new gbGroupsProvider() ;
  List<gb_tgroup> lst_gb_tgroup_provider = [];
  List<gb_tgroup> lst_gb_tgroup = [];
  String gb_tcompany_id = "";
  String gb_group_image = "";

  int ln_group_count_chat_pending = 0;

  // Declaración del Idioma.
  gbSession gb = gbSessionSettings.gb_getSessionValues();
  // Declaración del Idioma.
  gbLanguage gb_lang = gbLanguage();

  @override
  void initState()  {
    super.initState();
    validateVersionUpdate();

    setState(() {
      get_gbGroups();
    });

    gb_lang.setLanguage(gb.ses_gb_lang);
    gb_tcompany_id = gb.ses_tcompany_id;
    navigateEvent();


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
      lst_gb_tgroup.clear();
      get_gbGroups();
      });
  }

  // Navegación en caso de un PushNotification.
  void navigateEvent()
  {
    if (mounted)
     {
       setState(()
       {
         // Si es que hay un evento del grupo, se procede a abrirlo.
         if (widget.lo_event_gb_tgroup.tgroup_id != "0")
         {

           Future.delayed(Duration.zero, () {
             Navigator.of(context).push
               (MaterialPageRoute(builder: (context) => gbGroupsChat_page(tgroup:widget.lo_event_gb_tgroup)
             ));
           });

         }
       });
     }
  }

  // Se obtienen los grupos.
  void get_gbGroups() async
  {
    lst_gb_tgroup_provider = await _gbGroupsProvider.getAll();
    ln_group_count_chat_pending = 0;

    for (var i = 0; i < lst_gb_tgroup_provider.length; i++)
    {
      var item = lst_gb_tgroup_provider[i];
      if (item.groupname != null && mounted)
      {
          setState(()
          {
            item.image = AssetImage('assets/img/nophotogroup.png');
            // print(item.group_image);
            if (item.group_image != '' && item.group_image != 'null') {
              item.image = CachedNetworkImageProvider(
                  gbEnvironment.ses_gb_url_img + gb_tcompany_id + '/' +
                      item.group_image!);
            }
            lst_gb_tgroup.add(item);

            if (item.tgroup_id.toString() != "" && item.last_message.toString() != "" )
            {
              item.last_message = _gbGroupsProvider.gb_decrypt(item.last_message,item.tgroup_id);
            }
            if (item.last_datetime == "null")
            {
              item.last_datetime = "";
            }
            ln_group_count_chat_pending += int.parse(item.count_chat_pending!);
            widget.updateGroupCountChatPending(ln_group_count_chat_pending);

          });
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold
      (
        appBar: new AppBar(
            automaticallyImplyLeading: false,
            title: new Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: new Text(gb_lang.keyword["lang_gb_menu_groups"]),
            )),
      body:
      lst_gb_tgroup.length == 0 ?
      Center(
        child: Text(
          gb_lang.keyword["lang_gb_without_information"],
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ) :
      ListView.builder(
        itemCount: lst_gb_tgroup.length ,
        itemBuilder: (context, index) {
          return
            Card(
                child: ListTile(
                    leading: CircleAvatar(
                      radius:28,
                      backgroundImage: lst_gb_tgroup[index].image!
                    ),
                    title: Text(lst_gb_tgroup[index].groupname!),
                    subtitle: Text(lst_gb_tgroup[index].last_message!),
                    trailing: Column
                      (
                        children:<Widget>
                        [ Expanded(child: Text(lst_gb_tgroup[index].last_datetime!)),
                          Container(child: badges.Badge(
                              showBadge: lst_gb_tgroup[index].count_chat_pending != "0",
                              badgeContent: Text(lst_gb_tgroup[index].count_chat_pending!, style: TextStyle(color: Colors.white),),
                              badgeStyle: badges.BadgeStyle(
                            badgeColor: Colors.blue,
                            ))),
                        ]
                      ),
                  onTap: ()
                  {
                      Navigator.of(context).push
                        (MaterialPageRoute(builder: (context) => gbGroupsChat_page(tgroup:lst_gb_tgroup[index])
                        )).then(_refreshWidget);

                      },
                )
            );
        }
      )
    );
  }
}
