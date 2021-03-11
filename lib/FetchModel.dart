import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class FetchModel extends ChangeNotifier {
  List dataItemList = [];
  bool isLoading = false;
  int count = 0;

  retrieveData() async {
    isLoading = true;
    var url = "https://sigmatenant.com/mobile/tags";
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var items = json.decode(response.body)['tags'][count];
      dataItemList.add(items);
      isLoading = false;
    } else {
      dataItemList = [];
      isLoading = false;
    }
    count++;
    notifyListeners();
  }
}
