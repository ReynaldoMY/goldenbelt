import 'package:flutter/material.dart';
import 'package:goldenbelt/src/_models/gb_inbox_model.dart';
import 'package:goldenbelt/src/gbMenuInit_Inbox/gbInboxEntity/gbInboxEntityAttribute/gbInboxEntityAttribute_page.dart';
import 'package:goldenbelt/src/gbMenuInit_Inbox/gbInboxEntity/gbInboxRequest/gbInboxRequest_page.dart';
import 'package:goldenbelt/src/_env/gbLanguage.dart';

class gbInboxEntity_page extends StatefulWidget {
  const gbInboxEntity_page({
    Key? key,
    required this.inbox_entity_label,
    required this.inbox_entity_type,
    required this.lst_gb_inbox_entity,
  }) : super(key: key);

  final String inbox_entity_label;
  final String inbox_entity_type;
  final List<gb_inbox> lst_gb_inbox_entity;

  @override
  State<gbInboxEntity_page> createState() => _gbInboxEntityPageState();
}

class _gbInboxEntityPageState extends State<gbInboxEntity_page> {
  late TextEditingController _searchController;
  late List<gb_inbox> _filteredInboxList;
  // Declaración del Idioma.
  gbLanguage gb_lang = new gbLanguage();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredInboxList = widget.lst_gb_inbox_entity;

    _searchController.addListener(() {
      final query = _searchController.text.toLowerCase();
      setState(() {
        _filteredInboxList = widget.lst_gb_inbox_entity
            .where((item) => item.value!.toLowerCase().contains(query))
            .toList();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.inbox_entity_label),
        backgroundColor: const Color(0xFFd4dff4),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: gb_lang.keyword["lang_gb_search"],
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredInboxList.length,
              itemBuilder: (context, index) {
                final item = _filteredInboxList[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 18,
                      backgroundColor: widget.inbox_entity_type == 'FND'
                          ? const Color(0xffabd4ff)
                          : const Color(0xfff2f2f3),
                      backgroundImage: AssetImage(
                        'assets/img/gb_icon_${widget.inbox_entity_type}.png',
                      ),
                    ),
                    title: Text(
                      item.value!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF2e3061),
                      ),
                    ),
                    onTap: () {
                      if (widget.inbox_entity_type == "IBX-MRQ") {
                        String str = item.id!;
                        String start = 'RQI-';
                        final startIndex = str.indexOf(start);
                        String result = str.substring(startIndex + start.length);

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => gbInboxRequest_page(
                              label: item.value!,
                              trequest_instance_id: result,
                            ),
                          ),
                        );
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => gbInboxEntityAttribute_page(
                              tentity_label: item.value!,
                              tentity_type: item.gb_type!,
                              tentity_id: item.id!,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}