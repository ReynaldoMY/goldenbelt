import 'package:flutter/material.dart';
import 'package:goldenbelt/src/_models/gb_trequest_model.dart';

class gbInboxRequest_AttributeTable_page extends StatefulWidget {
  final gb_trequest_element element;
  final Function(List<Map<String, String>>) onChanged;

  const gbInboxRequest_AttributeTable_page({
    Key? key,
    required this.element,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<gbInboxRequest_AttributeTable_page> createState() => _gbInboxRequest_AttributeTable();
}

class _gbInboxRequest_AttributeTable extends State<gbInboxRequest_AttributeTable_page> {
  late List<Map<String, String>> rows;

  @override
  void initState() {
    super.initState();
    rows = widget.element.rows?.map((e) => Map<String, String>.from(e)).toList() ?? [];
  }

  void _updateCell(int rowIndex, String key, String value) {
    setState(() {
      rows[rowIndex][key] = value;
      widget.onChanged(rows);
    });
  }

  void _addRow() {
    final newRow = {
      for (var col in widget.element.cols!) col.key!: '',
    };
    setState(() {
      rows.add(newRow);
      widget.onChanged(rows);
    });
  }

  void _removeRow(int index) {
    setState(() {
      rows.removeAt(index);
      widget.onChanged(rows);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cols = widget.element.cols ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Table(
            border: TableBorder.all(color: Colors.grey),
            columnWidths: {
              for (int i = 0; i < cols.length; i++) i: const IntrinsicColumnWidth(),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              // Header
              TableRow(
                decoration: const BoxDecoration(color: Color(0xFFE0E0E0)),
                children: [
                  ...cols.map((col) => Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(col.title ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                  )),
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(''),
                  )
                ],
              ),
              // Data rows
              for (int i = 0; i < rows.length; i++)
                TableRow(
                  children: [
                    for (var col in cols)
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: _buildEditableCell(i, col.key!),
                      ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 18),
                      onPressed: () => _removeRow(i),
                    ),
                  ],
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: _addRow,
          icon: const Icon(Icons.add),
          label: const Text('Agregar fila'),
        )
      ],
    );
  }

  Widget _buildEditableCell(int rowIndex, String colKey) {
    final value = rows[rowIndex][colKey] ?? '';
    final col = widget.element.cols!.firstWhere((c) => c.key == colKey);
    final lkpList = col.att_lkp;

    if (lkpList != null && lkpList.isNotEmpty) {
      return DropdownButtonFormField<String>(
        value: lkpList.any((l) => l.lkp_id == value) ? value : null,
        isExpanded: true,
        items: lkpList
            .map((lkp) => DropdownMenuItem(
          value: lkp.lkp_id!,
          child: Text(lkp.lkp_label!),
        ))
            .toList(),
        onChanged: (newVal) {
          if (newVal != null) _updateCell(rowIndex, colKey, newVal);
        },
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 8),
          border: OutlineInputBorder(),
        ),
      );
    } else {
      return TextFormField(
        initialValue: value,
        onChanged: (val) => _updateCell(rowIndex, colKey, val),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 8),
          border: OutlineInputBorder(),
        ),
      );
    }
  }
}