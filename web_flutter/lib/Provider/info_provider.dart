import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

class InfoProvider extends ChangeNotifier {
  InfoProvider();

  Future<List<String>> getInfo() async {
    var url = "https://script.google.com/macros/s/AKfycbxtzTz8iUWREcv_FZdRTJD9l_DO-uQj-ae4iklQp9wLxCAlXVV1MerknXLdAOp7MTn2/exec";

    var response = await http.get(Uri.parse(url));

    List<String> info = [];

    info.addAll(response.body.replaceAll("[","").replaceAll("]","").split(","));

    notifyListeners();

    return info;
  }
}
