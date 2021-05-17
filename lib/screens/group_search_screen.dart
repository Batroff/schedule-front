import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
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
  List<String> _groupList = [];

  List<String> _groupListForDisplay = [];
  
  Future<Map<String, bool>> fetchGroupList() async {
    //var res = await new Client("192.168.1.45:8080").requestJson(method: "GET", location: "/api/groupList/");
    var directory = await getExternalStorageDirectory();
    var file = File('${directory.path}/groupList.txt');
    String res = await file.readAsString();
    var resDecoded = ResponseGroupList.deserialize(res);
    Map<String, bool> groupList = resDecoded.groupList;
    print(groupList);
    return groupList;
  }

  Future<String> fetchGroupJson() async {
    //var res = await new Client("192.168.1.45:8080").requestJson(method: "GET", location: "/api/group/", query: {"name": "БСБО-05-19"});//надо подтянуть из поля с номером группы саму группу в query
    var directory = await getExternalStorageDirectory();
    var file = File('${directory.path}/group.txt');
    print(directory.path);
    String res = await file.readAsString();
    var resDecoded = ResponseGroup.deserialize(res);
    String groupJson = jsonEncode(resDecoded.group.toJson());
    return groupJson;
  }

  @override
  void initState() {
    fetchGroupList().then((groupList) {
      setState(() {
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
          title: Text('Выбор группы'),
          actions: <Widget>[
            IconButton(
              onPressed: () async{
                var groupJson = await fetchGroupJson();
                await saveGroup(groupJson);
                Navigator.pushNamed(context, '/third');
                },
              icon: Icon(Icons.arrow_forward),
            )
          ],
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
    return Card(
      color: Color.fromRGBO(38, 38, 38, 1),
      child: Padding(
        padding: const EdgeInsets.only(top: 32.0, bottom: 32.0, left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              _groupListForDisplay[index],
              style: TextStyle(
                color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ),
    );
  }
}