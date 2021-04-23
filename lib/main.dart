import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:schedule/notes.dart';
import 'http_client.dart';
import 'group.dart';
import 'dart:io';
import 'notes.dart';
import 'response_decoder.dart';
import 'dart:math' as math;

void main() {
  runApp(MaterialApp(
      initialRoute: '/',
      routes: {
        '/':(BuildContext context) => MainScreen(),
        '/second':(BuildContext context) => SecondScreen(),
        '/third':(BuildContext context) => ThirdScreen(),
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

class ThirdScreen extends StatefulWidget{
  @override
  _ThirdScreenState createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          alignment: Alignment.topCenter,
          color: Color.fromRGBO(38, 38, 38, 1),
          height: MediaQuery.of(context).size.height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:<Widget> [
              Text(
                "Назад",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 16,
                ),),
              Container(
                child:Text(
                  " 23 апреля",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),),
              Text(
                "Далее",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],),

        ),

        Positioned(
          top: 100,
          child: Container(
            height: MediaQuery.of(context).size.height - 160,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Color.fromRGBO(38, 38, 38, 1),

            ),
            child: Column(
              children: [
                Container(
                  color: Color.fromRGBO(23, 23, 23, 1),
                  margin: EdgeInsets.only(top: 15, bottom: 30),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildDateColumn("M", 1, false),
                      buildDateColumn("T", 2, false),
                      buildDateColumn("W", 3, false),
                      buildDateColumn("T", 4, true),
                      buildDateColumn("F", 5, false),
                      buildDateColumn("S", 6, false),
                      buildDateColumn("S", 7, false),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        buildTaskListItem(),
                        Container(
                          width: 277,
                          height: 1,
                          color: Colors.white,
                        ),
                        buildTaskListItem()
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Container buildTaskListItem() {
    return Container(
        margin: EdgeInsets.only(top: 16),
        width: 343,
        height: 77,
        child: Stack(
          children:[
            Positioned(
              left: 66,
              top: 0,
              child: Text(
                "Название предмета",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.topRight,
                child: Text(
                  "ЛК/П",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Color.fromRGBO(189, 189, 189, 1),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 66,
              top: 40,
              child: SizedBox(
                width: 269,
                child: Text(
                  "ФИО преподавателя",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 277,
                  height: 1,
                ),
              ),
            ),
            Positioned(
              left: 9,
              top: 1,
              child: Text(
                "Каб.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 39,
              child: Text(
                "Время",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 30,
              child: Container(
                width: 45,
                height: 1,
              ),
            ),
            Positioned(
              left: 235,
              top: -2,
              child: Container(
                width: 20,
                height: 20,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:[
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(42),
                        color: Color(0xff232323),
                      ),
                      padding: const EdgeInsets.only(left: 7, right: 6, ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:[
                          Text(
                            "?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));

  }

  Container buildDateColumn(String weekDay, int date, bool isActive) {
    return Container(
        decoration: isActive
            ? BoxDecoration(
            color: Color.fromRGBO(38, 38, 38, 1), borderRadius: BorderRadius.circular(10))
            : BoxDecoration(),
        height: 55,
        width: 35,

        child: TextButton(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                weekDay,
                style: TextStyle(color: Colors.white, fontSize: 11),
              ),
              Text(
                date.toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold, fontSize: 11),
              ),
            ],
          ),
        ));
  }
}


