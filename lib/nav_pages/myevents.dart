import 'dart:convert';

import 'package:credenz20/constants/API.dart';
import 'package:credenz20/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MyEvents extends StatefulWidget {
  @override
  _MyEventsState createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {

  final storage=FlutterSecureStorage();
  List eventList;
  bool load=true;

  getEvents()async{
    String username=await storage.read(key: 'username');
    String accToken=await storage.read(key: "accToken");
    if(username!=null && accToken!=null){
      String url=baseUrl+username+'/present';
      Map<String,String>headers={
        "Authorization":"Bearer $accToken"
      };
      http.Response response=await http.get(url,headers: headers);
      if(response.statusCode==200){
        setState(() {
          eventList=jsonDecode(response.body) as List;
          load=false;
        });
      }
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEvents();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: drawerBackgroundColor,
        title: Text("My Events"),
      ),
      body: load==true?Container(
        child: loader,
        color: Colors.white,
      ):ListView.builder(itemBuilder: (BuildContext context,int pos){
        return ListTile(
          title: Text("Event Name:- ${eventList[pos]['event_username'].toString().toUpperCase()}"),
          subtitle: Text("Password:- ${eventList[pos]['random_pw']}"),
        );
      },
      itemCount: eventList.length,),
    );
  }
}
