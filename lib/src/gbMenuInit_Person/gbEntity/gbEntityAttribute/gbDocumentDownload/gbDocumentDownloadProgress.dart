import 'package:flutter/material.dart';
import 'package:goldenbelt/src/gbMenuInit_Person/gbEntity/gbEntityAttribute/gbDocumentDownload/gbDocumentDownload_page.dart';

class DownloadProgressDialog extends StatefulWidget {
  const DownloadProgressDialog(
      { Key? key,
        required this.filename,
        required this.url
      }): super(key: key);

  final String filename;
  final String url;

  @override
  State<DownloadProgressDialog> createState() => _DownloadProgressDialogState();
}

class _DownloadProgressDialogState extends State<DownloadProgressDialog> {
  double progress = 0.0;

  @override
  void initState() {
    _startDownload();
    super.initState();
  }

  void _startDownload() {
    FileDownload().startDownloading(widget.filename, widget.url, context, (receivedBytes, totalBytes) {
      setState(() {
        progress = receivedBytes / totalBytes;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String downloadingProgress = (progress * 100).toInt().toString();
    return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: const Text(
                "Downloading",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey,
              color: Colors.green,
              minHeight: 10,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                "$downloadingProgress %",
              ),
            )
          ],
        ));
  }
}