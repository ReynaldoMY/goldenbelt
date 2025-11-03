import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goldenbelt/src/_models/gb_tgroup_model.dart';
import 'package:goldenbelt/src/_models/gb_tgroup_chat_model.dart';
import 'package:goldenbelt/src/_providers/gb_tgroup_chat_provider.dart';
import 'package:goldenbelt/src/_providers/gb_tgroup_provider.dart';
import 'package:goldenbelt/src/gbMenuInit_Groups/gbGroupsChat/gbGroupsChatOwner_page.dart';
import 'package:goldenbelt/src/gbMenuInit_Groups/gbGroupsChat/gbGroupsChatSender_page.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:goldenbelt/src/_env/gbEnvironment.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'dart:typed_data';

class gbGroupsChat_page extends StatefulWidget {

  const gbGroupsChat_page
      ({
          Key? key,
          required this.tgroup
      }): super(key: key);

  final gb_tgroup tgroup;
  @override
  State<gbGroupsChat_page> createState() => _gbGroupsChat_pageState();
}

class _gbGroupsChat_pageState extends State<gbGroupsChat_page> {

  IO.Socket? socket;

  TextEditingController _msgController = TextEditingController();
  gbGroupChatProvider _gbGroupChatProvider = new gbGroupChatProvider() ;
  gbGroupsProvider _gbGroupProvider = new gbGroupsProvider() ;
  List<gb_tgroup_chat> lst_gb_tgroup_chat_provider = [];
  List<gb_tgroup_chat> lst_gb_tgroup_chat = [];
  gbSession gb = gbSession();
  String _isMessageReplied = '0';
  int _isIndexOfMessageReplied = 0;

  @override
  void initState() {

    super.initState();
    connectToServer();

    gbSessionSettings.configurePrefs();
    gb = gbSessionSettings.gb_getSessionValues();
    get_gbGroupChat();

  }

  void connectToServer() async {

    // Crear un SecurityContext personalizado para SSL
   var securityContext = SecurityContext.defaultContext;

    socket = IO.io("https://" + gbEnvironment.ses_gb_domain_backend, <String, dynamic>{
     'transports': ['websocket'],
      'autoConnect': true
    });

    socket!.onConnectError((data) => print(data));
    socket!.connect();

    socket!.onConnect((_) {

      socket!.emit("room", widget.tgroup.tgroup_id);

      socket!.on('messages', (data) {

        //print('Received message: $data');

          setState(() {
            gb_tgroup_chat lo_tgroup_chat =
            gb_tgroup_chat(
                id: data["id"] ?? "",
                tcompany_id: data["tcompany_id"].toString() ,
                tgroup_id: data["tgroup_id"],
                tperson_id: data["tperson_id"].toString(),
                person_shortname: data["person_shortname"] ?? "",
                person_image: data["person_image"] ?? "",
                message: _gbGroupProvider.gb_decrypt(data["message"], widget.tgroup.tgroup_id) ?? "",
                audit_date_ins: data["audit_date_ins"] ?? "",
                is_owner: gb.ses_tperson_id == (data["tperson_id"].toString()) ? "1" : "0",
                jwt_token: gb.ses_jwt_token,
                parent_id: data["parent_id"]
            );

            lst_gb_tgroup_chat.add(lo_tgroup_chat);
          });

      });

    });

  }

  void get_gbGroupChat() async
  {

    await _gbGroupProvider.updAccess(widget.tgroup.tgroup_id!);

    _gbGroupChatProvider.tgroup_id = widget.tgroup.tgroup_id!;
    lst_gb_tgroup_chat_provider = await _gbGroupChatProvider.getAll();
    lst_gb_tgroup_chat_provider.forEach((item) {
      if (item.id != null && mounted)
      {
        setState(()
        {
          item.message = _gbGroupProvider.gb_decrypt(item.message!, widget.tgroup.tgroup_id!);
          lst_gb_tgroup_chat.add(item);
        });
      }
    });
  }

  void sendMsg() {
    String message = _msgController.text.trim();
    message = _gbGroupProvider.gb_encrypt(message, widget.tgroup.tgroup_id!);
    //print('Mensaje por Enviar');
    //print(gb.ses_tcompany_id + gb.ses_person_shortname);

    DateFormat dateFormat = DateFormat("dd/MM HH:mm");
    String lv_today_now = dateFormat.format(DateTime.now());

    if (message.isNotEmpty) {

      gb_tgroup_chat lo_tgroup_chat =
      gb_tgroup_chat(
          id: "",
          tcompany_id: gb.ses_tcompany_id,
          tgroup_id: widget.tgroup.tgroup_id,
          tperson_id: gb.ses_tperson_id,
          person_shortname: gb.ses_person_shortname,
          person_image: gb.ses_person_image,
          message: message,
          audit_date_ins: lv_today_now,
          is_owner: "1",
          jwt_token: gb.ses_jwt_token,
          parent_id: _isMessageReplied
      );

      socket!.emit('new-message', lo_tgroup_chat.toJson());
      _msgController.clear();
      _closeMessageReplied();
    }
  }
  @override
  void dispose() {
    _msgController.dispose();
    socket!.dispose();
    // ignore: avoid_print
    // print('Dispose used');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Row(
          children: [
            CircleAvatar(
              radius:20,
              backgroundImage: widget.tgroup.image!,
            ),
            Container(width:10),
            Expanded(child:
            Column(
              children:[
                Container(
                    alignment: Alignment.centerLeft,
                    child:
                    Text('${widget.tgroup.groupname}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                Container(
                    alignment: Alignment.centerLeft,
                    child:
                      Text('${widget.tgroup.last_datetime}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal))),
              ]
            )
            )
          ]
        )
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Color(0xFFb6c2d4), // Color de fondo deseado
              child: ListView.builder(
              reverse: true,
              shrinkWrap: true,
              itemCount: lst_gb_tgroup_chat.length,
              itemBuilder: (BuildContext context, int index) {

                int ln_index = lst_gb_tgroup_chat.length - index - 1;
                int ln_parent_index = int.parse(lst_gb_tgroup_chat[ln_index].parent_id!);

                String lv_parent_msg_sender = "";
                String lv_parent_msg_message = "";

                if (ln_parent_index != 0) {
                  for (var i = 0; i < lst_gb_tgroup_chat.length; i++) {

                    if (int.parse(lst_gb_tgroup_chat[i].id!) == ln_parent_index)
                    {
                      lv_parent_msg_sender = lst_gb_tgroup_chat[i].person_shortname!;
                      lv_parent_msg_message = lst_gb_tgroup_chat[i].message!;
                      break;
                    }
                  }
                }

                // print(lst_gb_tgroup_chat[ln_index].id!);
                if (lst_gb_tgroup_chat[ln_index].is_owner == '1') {
                  return gbGroupsChatOwner_page(
                      tgroup_id: lst_gb_tgroup_chat[ln_index].tgroup_id!,
                      tgroup_chat_id: lst_gb_tgroup_chat[ln_index].id!,
                      msg_sender: lst_gb_tgroup_chat[ln_index].person_shortname!,
                      msg_message: lst_gb_tgroup_chat[ln_index].message!,
                      msg_datetime: lst_gb_tgroup_chat[ln_index].audit_date_ins!,
                      parent_msg_sender: lv_parent_msg_sender,
                      parent_msg_message: lv_parent_msg_message
                  );
                }
                else {
                  return gbGroupsChatSender_page(
                      tgroup_id: lst_gb_tgroup_chat[ln_index].tgroup_id!,
                      tgroup_chat_id: lst_gb_tgroup_chat[ln_index].id!,
                      msg_sender: lst_gb_tgroup_chat[ln_index].person_shortname!,
                      msg_message: lst_gb_tgroup_chat[ln_index].message!,
                      msg_datetime: lst_gb_tgroup_chat[ln_index].audit_date_ins!,
                      parent_msg_sender: lv_parent_msg_sender,
                      parent_msg_message: lv_parent_msg_message,
                      onReplyMessage: (isReplied) {
                        setState(() {
                          _isMessageReplied = isReplied == "1" ? lst_gb_tgroup_chat[ln_index].id! : '0';
                          _isIndexOfMessageReplied = ln_index;
                        });
                      }
                  );
                }
              },

              ),
            )
          ),
          Container(
          child:    _isMessageReplied == '0' ?
                SizedBox() :
                _MessageReplied(lst_gb_tgroup_chat[_isIndexOfMessageReplied].person_shortname!, lst_gb_tgroup_chat[_isIndexOfMessageReplied].message!)
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:15, vertical:20),
            child:
            Row(
              children:
              [
                Expanded(

                  child: TextFormField(
                    minLines: 1,
                    maxLines: 5,
                    controller: _msgController,
                    decoration: InputDecoration(
                        contentPadding:  EdgeInsets.symmetric(horizontal: 10),
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(width:1, color: Colors.blueGrey)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueGrey), // Color del borde cuando está seleccionado
                        )
                    ),
                  ),
                ),
                Container(
                  width: 10,
                ),
                Container(
                  width: 40,
                    child:
                          MaterialButton(
                              focusColor: Colors.black12,
                              highlightColor: Colors.black12,
                              onPressed: sendMsg,
                              color: Colors.blue,
                              textColor: Colors.white,
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(10),
                              child:
                              Icon(Icons.send, size: 24)
                ))

              ],
            ),
          ),
        ],
      ),
    );
  }

  void _closeMessageReplied()
  {
    setState(() {
      _isMessageReplied = '0';
    });
  }

  Widget _MessageReplied(lv_sender, lv_message)
  {
    return
      Center(
      child: SizedBox(
              width: MediaQuery.of(context).size.width, // Ancho total de la pantalla
              child: Container(
                          color: Color(0xFFb6c2d4),
                          child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                    color: Colors.green,
                                    width: 4,
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          lv_sender,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          lv_message,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: IconButton(
                                      icon: Icon(Icons.close),
                                      onPressed: _closeMessageReplied,
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    child: Container(color: Colors.green, width:5, height:100),
                                  ),
                                ],
                              ),
                            )
                  )
      )
    );
  }
}
