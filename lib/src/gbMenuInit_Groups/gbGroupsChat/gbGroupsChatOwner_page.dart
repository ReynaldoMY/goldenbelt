import 'package:flutter/material.dart';
import 'package:goldenbelt/src/_providers/gb_tgroup_chat_provider.dart';
import 'package:goldenbelt/src/_models/gb_tgroup_chat_model.dart';


class gbGroupsChatOwner_page extends StatefulWidget {

  final String tgroup_id;
  final String tgroup_chat_id;
  final String msg_sender;
  final String msg_message;
  final String msg_datetime;
  final String parent_msg_sender;
  final String parent_msg_message;

  const gbGroupsChatOwner_page({Key? key,
    required this.tgroup_id,
    required this.tgroup_chat_id,
    required this.msg_sender,
    required this.msg_message,
    required this.msg_datetime,
    required this.parent_msg_sender,
    required this.parent_msg_message,

  }) :super(key: key);

  @override
  State<gbGroupsChatOwner_page> createState() => _gbGroupsChatOwner_pageState();
}

class _gbGroupsChatOwner_pageState extends State<gbGroupsChatOwner_page> {

  bool isMessageActive = true;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomRight,
        child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery
                  .of(context)
                  .size
                  .width - 60,
            ),
            child: Card(
            color: Color(0xFFe1f7d4),
            child: InkWell(
            onLongPress: () {

              // Calcular la posición del tap
              final RenderBox cardRenderBox = context.findRenderObject() as RenderBox;
              final Offset cardOffset = cardRenderBox.localToGlobal(Offset.zero);
              final RelativeRect position = RelativeRect.fromLTRB(
                MediaQuery.of(context).size.width,
                cardOffset.dy,
                MediaQuery.of(context).size.width - cardOffset.dx - cardRenderBox.size.width,
                MediaQuery.of(context).size.height - cardOffset.dy - cardRenderBox.size.height,
              );

              showMenu(
                context: context,
                position: position,
                items: [
                  PopupMenuItem<String>(
                    value: 'DELETE',
                    child: Row(
                      children: [
                        Icon(Icons.delete),
                        SizedBox(width: 8),
                        Text('Eliminar'),
                      ],
                    ),
                  )
                ]
              ).then((value) {
                // Manejar la selección del elemento del menú aquí
                if (value != null) {

                  // Eliminar el mensaje seleccionado.
                  gbGroupChatProvider().deleteMessageChat(widget.tgroup_id, widget.tgroup_chat_id);

                  setState(() {
                    isMessageActive = false;
                  });
                }
              });
            },

                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: isMessageActive ? _MessageActive() : _MessageDeleted()
                )
            )
        )
        )
    );
  }

  Widget _MessageActive()
  {

    return
    Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(child: widget.parent_msg_sender == "" ? SizedBox() : _MessageReplied(widget.parent_msg_sender, widget.parent_msg_message)),

          const SizedBox(
            height: 3,
          ),
          Text(
            widget.msg_message,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.black),
          ),
          Container(
              alignment: Alignment.centerRight,
              child: Text(
                widget.msg_datetime,
                textAlign: TextAlign.end,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              )),
        ]
    );
  }

  Widget _MessageReplied(lv_sender, lv_message)
  {
    return
      Center(
          child: SizedBox(
              width: MediaQuery.of(context).size.width, // Ancho total de la pantalla
              child: Container(
                  child: Card(
                    color: Color(0xFFdaeed2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          color: Color(0xFF74394d),
                          width: 4,
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                lv_sender,
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF74394d)
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                lv_message,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),

                        Positioned(
                          top: 0,
                          left: 0,
                          child: Container(color: Color(0xFF74394d), width:5, height:100),
                        ),
                      ],
                    ),
                  )
              )
          )
      );
  }

  Widget _MessageDeleted()
  {
    return
      Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              "Mensaje Eliminado",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
          ]
      );
  }
}