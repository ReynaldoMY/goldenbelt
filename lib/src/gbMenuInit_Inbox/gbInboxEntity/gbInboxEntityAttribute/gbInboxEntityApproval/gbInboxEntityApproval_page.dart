import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:goldenbelt/src/_env/gbLanguage.dart';
import 'package:goldenbelt/src/_env/gbEnvironment.dart';
import 'package:goldenbelt/src/_providers/gb_tentity_provider.dart';


class gbInboxEntityApproval_page extends StatefulWidget {
  const gbInboxEntityApproval_page(
      { Key? key,
        required this.approval_type,
        required this.tentity_name,
        required this.tentity_type,
        required this.tentity_id
      }): super(key: key);

  final String approval_type;
  final String tentity_name;
  final String tentity_type;
  final String tentity_id;
  @override
  State<gbInboxEntityApproval_page> createState() => _gbInboxEntityApproval_pageState();
}

class _gbInboxEntityApproval_pageState extends State<gbInboxEntityApproval_page> {

  gbEntityProvider _gbEntityProvider = new gbEntityProvider() ;

  // Declaración del Idioma.
  gbSession gb = gbSessionSettings.gb_getSessionValues();
  gbLanguage gb_lang = new gbLanguage();
  TextEditingController _controller = new TextEditingController();

  @override
  void initState() {

    super.initState();
    gb_lang.setLanguage(gb.ses_gb_lang);
    _gbEntityProvider.getEntityReviserData(widget.tentity_type, widget.tentity_id).then
      ((value) =>
        {
          _controller.text =  value
        }
      );
  }

  void save_gbEntityReviseData() async
  {
        await _gbEntityProvider.saveEntityReviserData(widget.tentity_type, widget.tentity_id, _controller.text);
  }

  Future<void> send_gbEntityReviseApproval() async
  {
    save_gbEntityReviseData();

    var lv_approval_type = widget.approval_type == 'APR' ? 'APPROVE' : 'DENY';
     await _gbEntityProvider.saveEntityReviserApproval(widget.tentity_type, widget.tentity_id, lv_approval_type);
  }
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text( widget.approval_type == 'APR' ? gb_lang.keyword["lang_gb_approval"] : gb_lang.keyword["lang_gb_deny"]),
        backgroundColor: widget.approval_type == 'APR' ? Colors.green : Colors.red,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child:
        Column(
          children: [

            Text(widget.tentity_name, style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
            ),),

            Divider(),

            TextFormField(
              keyboardType: TextInputType.text,
              controller:_controller,
              decoration: InputDecoration(
                constraints: const BoxConstraints.expand(
                    height: 300, width: 400
                ),
                filled: true,
                contentPadding: const EdgeInsets.all(8),
              ),
              maxLength: 250,
              maxLines: 50,

            ),

            SizedBox(height: 50),

            Row( children:
            [   Spacer(),
              ElevatedButton(
                onPressed: () {
                  // Se graban los datos, considerando el arreglo que se acaba de construir con los datos de salida.
                  save_gbEntityReviseData();
                  Navigator.popUntil(context, ModalRoute.withName('gbInboxEntity_page'));
                  ;

                },
                child: Text(gb_lang.keyword["lang_gb_save"]),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  // Se graban los datos, considerando el arreglo que se acaba de construir con los datos de salida.
                  send_gbEntityReviseApproval().then((_)
                      {
                        Navigator.popUntil(context, ModalRoute.withName('gbMainFrontPage'));
                      })
                      ;

                  },

                child:  Text(gb_lang.keyword["lang_gb_confirm"]),
              ),
              Spacer()
            ],
            )
          ],
        ),
      ),
    );
  }
}
