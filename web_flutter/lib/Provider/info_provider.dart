import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

class InfoProvider extends ChangeNotifier {
  InfoProvider();

  Future<List<String>> getInfo() async {
    var url = "https://script.google.com/macros/s/AKfycby9edqhDO5SIa_rUwd7yBMgeV88_fHh9RyUN7Clj3V6GpJhGD-kuAR4UIQiXdAIOz3W/exec";

    var response = await http.get(Uri.parse(url));

    List<String> info = [];

    info.addAll(response.body.replaceAll("[","").replaceAll("]","").split(","));

    notifyListeners();

    return info;
  }
}
