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

  Future<String> getURLTemplate() async {
    var url = "https://script.google.com/macros/s/AKfycbwg5kGYg55xQemJSGto7VYxBnauKY50JQ911QnDbj2RUFL3Kie2EuS4d66h3Jw_V7q0Bw/exec";
    var response = await http.get(Uri.parse(url));

    var urlTemplate = response.body.replaceAll("\"", "");

    notifyListeners();

    return urlTemplate;
  }
}
