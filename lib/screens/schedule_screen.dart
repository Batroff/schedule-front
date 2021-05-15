import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:schedule/models/group.dart';
import 'package:schedule/services/http_client.dart';
import 'package:schedule/services/response_decoder.dart';
import 'package:schedule/services/save.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:async';

class Data {
  static Group group;
}

class ThirdScreen extends StatefulWidget {
  @override
  _ThirdScreenState createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  Future<Group> fetchGroup() async {
    var res = await new Client("10.0.2.2:8080").requestJson(
        method: "GET", location: "/api/group/", query: {"name": "БСБО-05-19"});
    var resDecoded = ResponseGroup.deserialize(res);
    var group = resDecoded.group;
    return group;
  }

  Future<Group> futureGroup;
  CalendarController _calendarController;

  @override
  void initState() {
    readGroup().then((value) {
      Data.group = value;
    });
    Data.group.showInfo();
    super.initState();
    _calendarController = CalendarController();
    futureGroup = fetchGroup();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(38, 38, 38, 1),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Расписание",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<Group>(
        future: futureGroup,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            snapshot.data.showInfo();
            Data.group = snapshot.data;
            Group group = snapshot.data;
            return Column(children: [
              TableCalendar(
                calendarController: _calendarController,
                initialCalendarFormat: CalendarFormat.week,
                startingDayOfWeek: StartingDayOfWeek.monday,
                formatAnimation: FormatAnimation.slide,
                headerStyle: HeaderStyle(
                  centerHeaderTitle: true,
                  formatButtonVisible: true,
                  formatButtonTextStyle: TextStyle(color: Colors.white),
                  titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
                  leftChevronIcon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 14,
                  ),
                  rightChevronIcon: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 14,
                  ),
                  leftChevronMargin: EdgeInsets.only(left: 10),
                  rightChevronMargin: EdgeInsets.only(right: 10),
                ),
                calendarStyle: CalendarStyle(
                    weekdayStyle: TextStyle(color: Colors.white),
                    weekendStyle: TextStyle(color: Colors.white)),
                daysOfWeekStyle: DaysOfWeekStyle(
                    weekendStyle: TextStyle(color: Colors.white),
                    weekdayStyle: TextStyle(color: Colors.white)),
              ),
              Expanded(
                  // child: ListView.builder(
                  //   itemCount: lessons.length,
                  //   itemBuilder: (context, index){
                  //     return lessonBar(lessons[index].cabinet, lessons[index].teacherName, lessons[index].numberOfLesson, lessons[index].lessonType, lessons[index].subject);
                  //   })
                  child: ListView.builder(
                      itemCount: group.days["ПЯТНИЦА"].length,
                      itemBuilder: (context, index) {
                        return lessonBar(
                            group.days["ПЯТНИЦА"][index].cabinet,
                            group.days["ПЯТНИЦА"][index].teacherName,
                            group.days["ПЯТНИЦА"][index].numberLesson
                                .toString(),
                            group.days["ПЯТНИЦА"][index].typeOfLesson,
                            group.days["ПЯТНИЦА"][index].subject);
                      }))
            ]);
          } else {
            return Column();
          }
        },
      ),
    );
  }
}

Row lessonBar(String cabinet, String teacherName, String numberOfLesson,
    String lessonType, String subject) {
  return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Column(
      children: [
        Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
            child: Text(cabinet,
                style: TextStyle(
                  color: Colors.white,
                ))),
        SizedBox(
            width: 30,
            height: 1,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
            )),
        Container(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
          child: Text(numberOfLesson,
              style: TextStyle(
                color: Colors.white,
              )),
        )
      ],
    ),
    SizedBox(
      height: 10,
    ),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 15),
            child: Text(subject,
                style: TextStyle(
                  color: Colors.white,
                ))),
        SizedBox(height: 10),
        Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Text(teacherName,
                style: TextStyle(
                  color: Colors.white,
                )))
      ],
    ),
    Expanded(
      child: Container(),
    ),
    Container(
      padding: EdgeInsets.only(right: 20, top: 20),
      child: Text(lessonType, style: TextStyle(color: Colors.white)),
    )
  ]);
}