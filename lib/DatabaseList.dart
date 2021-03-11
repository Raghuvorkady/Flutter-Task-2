import 'package:flutter/material.dart';
import 'package:task2/UserModel.dart';
import 'package:task2/utils/db_helper.dart';

class DatabaseList extends StatefulWidget {
  @override
  _DatabaseListState createState() => _DatabaseListState();
}

class _DatabaseListState extends State<DatabaseList> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  int count = 0;
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Records in the DB"),
      ),
      body: userModelList.length == 0
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: EdgeInsets.all(8),
              child: ListView.builder(
                  itemCount: userModelList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Text("DisplayName: " +
                                  userModelList[index].displayName),
                              SizedBox(
                                height: 5,
                              ),
                              Text("Meta: " + userModelList[index].meta),
                              SizedBox(
                                height: 5,
                              ),
                              Text("Description: " +
                                  userModelList[index].description),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
    );
  }
}
