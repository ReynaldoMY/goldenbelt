import 'package:flutter/material.dart';

class gbGroupsChatSender_page extends StatefulWidget {

  final String tgroup_id;
  final String tgroup_chat_id;
  final String msg_sender;
  final String msg_message;
  final String msg_datetime;
  final String parent_msg_sender;
  final String parent_msg_message;
  final Function(String) onReplyMessage;

  const gbGroupsChatSender_page({Key? key,
    required this.tgroup_id,
    required this.tgroup_chat_id,
    required this.msg_sender,
    required this.msg_message,
    required this.msg_datetime,
    required this.parent_msg_sender,
    required this.parent_msg_message,
    required this.onReplyMessage
  }) :super(key: key);

  @override
  State<gbGroupsChatSender_page> createState() => gbGroupsChatSender_pageState();
}

class gbGroupsChatSender_pageState extends State<gbGroupsChatSender_page> {

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomLeft,
        child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery
                  .of(context)
                  .size
                  .width - 60,
            ),
            child: Card(
                color: Colors.white,
                child: InkWell(
                onLongPress: () {

                // Calcular la posición del tap
                final RenderBox cardRenderBox = context.findRenderObject() as RenderBox;
                final Offset cardOffset = cardRenderBox.localToGlobal(Offset.zero);
                final RelativeRect position = RelativeRect.fromLTRB(
                      cardOffset.dx,
                      cardOffset.dy,
                      MediaQuery.of(context).size.width - cardOffset.dx - cardRenderBox.size.width,
                      MediaQuery.of(context).size.height - cardOffset.dy - cardRenderBox.size.height,
                );

                showMenu(
                      context: context,
                      position: position,
                      items: [
                                PopupMenuItem<String>
                                  (
                                      value: 'REPLY',
                                      child: Row( children: [
                                                        Icon(Icons.reply),
                                                        SizedBox(width: 8),
                                                        Text('Responder'),
                                                  ],
                                        ),
                                  )
                    ]
                ).then((value) {
                // Manejar la selección del elemento del menú aquí
                if (value != null) {
                  widget.onReplyMessage('1');
                // Puedes agregar cualquier lógica adicional aquí según la opción seleccionada
                }
                });
                },

                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(child: widget.parent_msg_sender == "" ? SizedBox() : _MessageReplied(widget.parent_msg_sender, widget.parent_msg_message)),
                          Text(
                            widget.msg_sender,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
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
                          ))
                        ]
                    )
                )
            )
            )
        )
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
                    color: Color(0xFFf2f2f2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          color: Color(0xFFf25643),
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
                                    color: Color(0xFFf25643)
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
                          child: Container(color: Color(0xFFf25643), width:5, height:100),
                        ),
                      ],
                    ),
                  )
              )
          )
      );
  }

}