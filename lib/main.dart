import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'adddata.dart';
import 'details.dart';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
      
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  

   Future<List> getData() async{

  final response=await http.get("http://15.206.90.123/flutterservice/curd/getdata.php");
  return json.decode(response.body);

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("My Store"),
      ),

      floatingActionButton: new FloatingActionButton(
          onPressed: ()=>Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (BuildContext context)=>new AddData(),
            ),
          ),
          child: new Icon(Icons.add),
      ),
      body: new FutureBuilder<List>(
        future: getData(),
        builder: (context,snapshot){
          if(snapshot.hasError)
            print(snapshot.error);
          return snapshot.hasData
              ?new ItemList(list: snapshot.data,)
              :new Center(
                child: new CircularProgressIndicator(),
              );
        },
      ),
    );
  }
}
class ItemList extends StatelessWidget{

  final List list;
  ItemList({this.list});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new ListView.builder(
        itemCount: list==null?0:list.length,
      itemBuilder: (context,i){
          return new ListTile(
            title: new Text(list[i]['name']),
            subtitle: new Text(list[i]['email']),
            leading: new Icon(Icons.http),
            onTap:()=> Navigator.of(context).push(
              new MaterialPageRoute(
                  builder: (BuildContext context)=>new Details(list: list,index: i),

              )
            ),
          );
      },
    );
  }
}