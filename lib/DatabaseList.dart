import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task2/UserModel.dart';
import 'package:task2/utils/db_helper.dart';

class DatabaseList extends StatefulWidget {
  @override
  _DatabaseListState createState() => _DatabaseListState();
}

class _DatabaseListState extends State<DatabaseList> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  UserModel userModel;
  List<UserModel> userModelList = [];

  @override
  void initState() {
    super.initState();
    this.fetchCount();
  }

  fetchCount() async {
    final allRows = await databaseHelper.queryAllRows();
    setState(() {
      for (int i = 0; i < allRows.length; i++) {
        var row = allRows[i];
        userModel =
            new UserModel(row['displayName'], row['meta'], row['description']);
        userModelList.add(userModel);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return getBody();
  }

  Widget getBody() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Records in the DB"),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: DataTable(
            dataRowHeight: 100,
            sortColumnIndex: 0,
            sortAscending: true,
            columnSpacing: 20,
            showBottomBorder: true,
            headingTextStyle: TextStyle(
                color: Colors.brown, fontWeight: FontWeight.bold, fontSize: 18),
            columns: const <DataColumn>[
              DataColumn(label: Text("DisplayName")),
              DataColumn(label: Text("Meta")),
              DataColumn(label: Text("Description")),
            ],
            rows: userModelList
                .map((item) => DataRow(cells: <DataCell>[
                      DataCell(Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(item.displayName),
                      )),
                      DataCell(Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: SingleChildScrollView(child: Text(item.meta)),
                      )),
                      DataCell(Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: SingleChildScrollView(
                            child: Text(item.description)),
                      )),
                    ]))
                .toList(),
          ),
        ),
      ),
    );
  }
}
