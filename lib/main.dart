import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app_1/notes.dart';
import 'package:http/http.dart' as http;



void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/':(BuildContext context) => MainScreen(),
      '/second':(BuildContext context) => SecondScreen()
    }
  ));
}


class MainScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color.fromRGBO(38, 38, 38, 1),
      body: Column(
        children: <Widget>[
          Expanded(

            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  alignment: FractionalOffset(0.5, 0.9),
                  image: AssetImage("images/logo.png"),
                )
              ),
            ),
          ),
             Expanded(
              child: Container(
                alignment: FractionalOffset(0.5, 0.05),
                child: Text('Расписание МИРЭА',
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize:24,
                  )
                ),
              ),),
          Container(
            margin: EdgeInsets.only(bottom: 50),
            child: ElevatedButton(
                onPressed: (){Navigator.pushNamed(context, '/second');},
                child: Text('Далее'),
                style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 75, vertical: 20),
                    textStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    )
                )
            ),
          )
        ]
      )
    );
  }
}

class SecondScreen extends StatefulWidget {
  @override
  SecondScreenSearch createState() => SecondScreenSearch();
}

class SecondScreenSearch extends State<SecondScreen> {
  List<Note> _notes = List<Note>();
  List<Note> _notesForDisplay = List<Note>();

  Future<List<Note>> fetchNotes() async {
    var url = '';
    var response = await http.get(url);

    var notes = List<Note>();


    return notes;
  }

  @override
  void initState() {
    fetchNotes().then((value) {
      setState(() {
        _notes.addAll(value);
        _notesForDisplay = _notes;
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
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return index == 0 ? _searchBar() : _listItem(index-1);
          },
          itemCount: _notesForDisplay.length+1,
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
            _notesForDisplay = _notes.where((note) {
              var noteTitle = note.title.toLowerCase();
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
              _notesForDisplay[index].title,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold
              ),
            ),
            Text(
              _notesForDisplay[index].text,
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
