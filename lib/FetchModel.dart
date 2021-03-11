import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:task2/UserModel.dart';
import 'package:task2/utils/db_helper.dart';

class FetchModel extends ChangeNotifier {
  List dataItemList = [];
  bool isLoading = false;
  int count = 0;

  DatabaseHelper databaseHelper = DatabaseHelper();

  retrieveData() async {
    isLoading = true;
    var url = "https://sigmatenant.com/mobile/tags";
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var items = json.decode(response.body)['tags'][count];
      dataItemList.add(items);
      isLoading = false;

      UserModel userModel =
          UserModel(items['displayName'], items['meta'], items['description']);
      var res = databaseHelper.insertNote(userModel);
      print("DB: $res");
    } else {
      dataItemList = [];
      isLoading = false;
    }
    count++;
    notifyListeners();
  }
}
