import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:schedule/models/group.dart';
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

  CalendarController _calendarController;
  final groupStream = StreamController<Group>();




  @override
  void initState() {
    readGroup().then((value) {
      Data.group = value;
    });
    super.initState();
    _calendarController = CalendarController();

  }

  @override
  void dispose() {
    _calendarController.dispose();
    groupStream.close();
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
      body: StreamBuilder(
        stream: groupStream.stream,
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {return CircularProgressIndicator();}
            DateTime selectedDate = _calendarController.selectedDay;
            final selectedDays = Data.group.days[selectedDate];
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
                  child: ListView.builder(
                      itemCount: selectedDays.length,
                      itemBuilder: (context, index) {
                        return lessonBar(
                            selectedDays[index].cabinet,
                            selectedDays[index].teacherName,
                            selectedDays[index].numberLesson
                                .toString(),
                            selectedDays[index].typeOfLesson,
                            selectedDays[index].subject);
                      }))
            ]);
          }

      )
    );
  }
}

Row lessonBar(String cabinet, String teacherName, String numberOfLesson,
    String lessonType, String subject) {
  return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Column(
      children: [
        Container(
            padding: EdgeInsets.only(top: 20, bottom: 10),
            child: Text(cabinet,
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  color: Colors.white,
                ))),
        SizedBox(
            width: 30,
            height: 1,
            child: Container(
              padding: EdgeInsets.only(left: 15, right: 15),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
            )),
        Container(
          padding: EdgeInsets.only(bottom: 20, top: 10),
          child: Text(numberOfLesson,
              textDirection: TextDirection.ltr,
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
            padding: EdgeInsets.only(left: 15, right: 5, top: 20, bottom: 15),
            child: Text(subject,
                style: TextStyle(
                  color: Colors.white,
                ))),
        SizedBox(height: 10),
        Container(
            padding: EdgeInsets.only(left: 15, right: 20),
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
      padding: EdgeInsets.only(right: 10, top: 20),
      child: Text(lessonType.toUpperCase(), style: TextStyle(color: Colors.white)),
    )
  ]);
}