import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:goldenbelt/src/_env/gbEnvironment.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ImageLoader {

  static Future<ImageProvider> loadImage(String imageUrl) async {
    final headers = {'Referer': gbEnvironment.ses_gb_url + '/'};

    try {
      final response = await http.get(Uri.parse(imageUrl), headers: headers);
      if (response.statusCode == 200) {
        return MemoryImage(response.bodyBytes);
      } else {
        throw Exception('Failed to load image: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load image: $e');
    }
  }

  static Future<String> loadImageBase64(String imageUrl) async  {
    final headers = {'Referer': gbEnvironment.ses_gb_url + '/'};

    try {
      final response = await http.get(Uri.parse(imageUrl), headers: headers);
      if (response.statusCode == 200) {
        final Uint8List bytes = response.bodyBytes;
        final String base64Image = base64Encode(bytes);
        return base64Image;
      } else {
        throw Exception('Failed to load image: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load image: $e');
    }
  }

  List<String> extractUrls(String text) {
    RegExp regex = RegExp(
        r'https?:\/\/(?:www\.)?[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*(?:\/[\w#!:.?+=&%@!\-/]*)?');
    Iterable<Match> matches = regex.allMatches(text);
    List<String> urls = [];
    for (Match match in matches) {
      urls.add(match.group(0)!);
    }
    return urls;
  }
}



class gbFileHandler {

  Future<String> getLocalFilePath(String filename) async {
    Directory? dir;

    try {
      if (Platform.isIOS) {
        dir = await getApplicationDocumentsDirectory(); // for iOS

      } else {
        dir = Directory('/storage/emulated/0/Download/'); // for android
        if (!await dir.exists()) dir = (await getExternalStorageDirectory())!;
      }
    } catch (err) {
      print("Cannot get download folder path $err");
    }
    return "${dir?.path}/$filename";
  }

}