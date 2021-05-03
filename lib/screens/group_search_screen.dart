import 'package:flutter/material.dart';
import 'package:schedule/models/group.dart';
import 'package:schedule/services/http_client.dart';
import 'package:schedule/services/response_decoder.dart';

class SecondScreen extends StatefulWidget {
  @override
  SecondScreenSearch createState() => SecondScreenSearch();
}



class SecondScreenSearch extends State<SecondScreen> {
  // ignore: deprecated_member_use
  List<Group> _group = List<Group>();
  // ignore: deprecated_member_use
  List<Group> _groupsForDisplay = List<Group>();

  Future<List<Group>> fetchNotes() async {
    var res = await new Client("127.0.0.1:8080").requestJson(method: "GET", location: "", query: {"group": "БСБО-01-20"});
    var resDecoded = ResponseGroup.deserialize(res);

    var group = resDecoded.group;
    group.showInfo();
  }


  @override
  void initState() {
    fetchNotes().then((value) {
      setState(() {
        _group.addAll(value);
        _groupsForDisplay = _group;
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
              onPressed: (){Navigator.pushNamed(context, '/third');},
              icon: Icon(Icons.arrow_forward),
            )
          ],
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return index == 0 ? _searchBar() : _listItem(index-1);
          },
          itemCount: _groupsForDisplay.length+1,
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
            _groupsForDisplay = _group.where((note) {
              var noteTitle = note.name.toLowerCase();
              return noteTitle.contains(text);
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
              _groupsForDisplay[index].name,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold
              ),
            ),
            Text(
              _groupsForDisplay[index].name,
              style: TextStyle(
                  color: Colors.white
              ),
            ),
          ],
        ),
      ),
    );
  }
}