import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task2/FetchModel.dart';
import 'package:task2/DatabaseList.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
        builder: (BuildContext context) => FetchModel(),
        child: HomePage(title: "Sigma Task 2"),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List dataItemList = [];
  bool isLoading = false;

  BuildContext scaffoldContext;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    scaffoldContext = context;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.open_in_new),
            tooltip: 'Open DB',
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DatabaseList()));
            },
          ), //IconButton
        ], //<Widget>[]
      ),
      body: getBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('fetching ...'),
            duration: Duration(seconds: 1),
          ));
          Provider.of<FetchModel>(context).retrieveData();
        },
        tooltip: 'Fetch',
        child: Icon(Icons.refresh),
      ),
    );
  }

  Widget getBody() {
    return Consumer<FetchModel>(builder: (context, fetchModel, child) {
      if (fetchModel.dataItemList.contains(null) ||
          fetchModel.dataItemList.length < 0 ||
          fetchModel.isLoading) {
        return Center(child: CircularProgressIndicator());
      }
      return ListView.builder(
          itemCount: fetchModel.dataItemList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(2.0),
              child: CustomCard(fetchModel.dataItemList[index]),
            );
          });
    });
  }

  Widget CustomCard(dataItemList) {
    var displayName = dataItemList['displayName'];
    var description = dataItemList['description'];
    var meta = dataItemList['meta'];

    // print("NAME" + displayName);
    // print("META" + meta);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "$displayName",
                    style: TextStyle(
                        color: Colors.pinkAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 10),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$meta",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "$description",
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Spaces",
                      style: TextStyle(
                          color: Colors.pinkAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
