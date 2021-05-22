import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:schedule/models/group.dart';
import 'package:schedule/services/http_client.dart';
import 'package:schedule/services/save.dart';
import 'package:schedule/services/response_decoder.dart';

class SecondScreen extends StatefulWidget {
  @override
  SecondScreenSearch createState() => SecondScreenSearch();
}

class SecondScreenSearch extends State<SecondScreen> {
  Map<String, bool> _subgroupList;

  List<String> _groupList = [];

  List<String> _groupListForDisplay = [];

  String groupName;
  
  Future<Map<String, bool>> fetchGroupList() async {
    //var res = await new Client("192.168.1.149:8080").requestJson(method: "GET", location: "/api/groupList/");
    var directory = await getExternalStorageDirectory();
    var file = File('${directory.path}/groupList.txt');
    String res = await file.readAsString();
    var resDecoded = ResponseGroupList.deserialize(res);
    Map<String, bool> groupList = resDecoded.groupList;
    print(groupList);
    return groupList;
  }

  Future<String> fetchGroupJson([String subgroup = ""]) async {
    var res;
    if (subgroup == "") {
      var directory = await getExternalStorageDirectory();
       var file = File('${directory.path}/group.txt');
       print(directory.path);
       String res = await file.readAsString();
      var resDecoded = ResponseGroup.deserialize(res);
      String groupJson = jsonEncode(resDecoded.group.toJson());
      return groupJson;
     // res = await new Client("192.168.1.149:8080").requestJson(
       //   method: "GET",
         // location: "/api/group/",
          //query: {
           // "name": groupName
          //});
    } else {
      res = await new Client("192.168.1.149:8080").requestJson(
          method: "GET",
          location: "/api/group/",
          query: {
            "name": groupName,
            "subgroup": subgroup,
          });
    }
    // var directory = await getExternalStorageDirectory();
    // var file = File('${directory.path}/group.txt');
    // print(directory.path);
    // String res = await file.readAsString();
    //var resDecoded = ResponseGroup.deserialize(res);
    //String groupJson = jsonEncode(resDecoded.group.toJson());
    //return groupJson;
  }

  @override
  void initState() {
    fetchGroupList().then((groupList) {
      setState(() {
        _subgroupList = groupList;
        _groupList = groupList.keys.toList();
        print(_groupList);
        _groupListForDisplay = _groupList;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(38, 38, 38, 1),
          title: Text('Выбор группы',
             style: GoogleFonts.ubuntu()),

        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return index == 0 ? _searchBar() : _listItem(index-1);
          },
          itemCount: _groupListForDisplay.length+1,
        )
    );
  }

  _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
            hintText: 'Введите название группы'
        ),
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            _groupListForDisplay = _groupList.where((name) {
              return name.toLowerCase().contains(text);
            }).toList();
          });
        },
      ),
    );
  }

  _listItem(index) {
    if (!_subgroupList[_groupListForDisplay[index]]){
      return Card(
      color: Color.fromRGBO(38, 38, 38, 1),
      child: Padding(
        padding: const EdgeInsets.only(top: 32.0, bottom: 32.0, left: 16.0, right: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
                _groupListForDisplay[index],
                style: GoogleFonts.ubuntu(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold
                )
            ),
            SizedBox(width: 125),
            groupButton(index)
          ],
        ),
      ),
    );}
    else{
      return Card(
        color: Color.fromRGBO(38, 38, 38, 1),
        child: Padding(
          padding: const EdgeInsets.only(top: 32.0, bottom: 32.0, left: 16.0, right: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _groupListForDisplay[index],
                style: GoogleFonts.ubuntu(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold
                )
              ),
              SizedBox(width: 100),
              Row(
                children: <Widget>[
                 subGroupsButton(index, "1"),
                  SizedBox(width: 15),
                  subGroupsButton(index, "2")
                ],
              )
            ],
          ),
        ),
      );}
    }


  ElevatedButton groupButton(index){
    return ElevatedButton(
      child: ElevatedButton.icon(
        icon: Icon( Icons.arrow_forward),
        label: Text(''),
      onPressed: () async{
        groupName = _groupListForDisplay[index];
        var groupJson = await fetchGroupJson();
        await saveGroup(groupJson);
        Navigator.pushNamed(context, '/third');
      },
      style: ElevatedButton.styleFrom(
        primary: Color.fromRGBO(38, 38, 38, 1),
        side: BorderSide(color: Colors.white, width: 1),
      )));
  }


  ElevatedButton subGroupsButton(index, String subGroup){
    return ElevatedButton(
      child: Text(subGroup),
      onPressed: () async{
        groupName = _groupListForDisplay[index];
        var groupJson = await fetchGroupJson(subGroup);
        await saveGroup(groupJson);
        Navigator.pushNamed(context, '/third');
      },
      style: ElevatedButton.styleFrom(
        primary: Color.fromRGBO(38, 38, 38, 1),
        side: BorderSide(color: Colors.white, width: 1),
        textStyle: GoogleFonts.ubuntu(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold
        ),
      ));

  }
  }



