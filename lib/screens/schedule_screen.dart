import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule/models/group.dart';
import 'package:schedule/services/save.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:async';
import 'package:jiffy/jiffy.dart';


class Data {
  static Group group;
}

class ThirdScreen extends StatefulWidget {

  @override
  _ThirdScreenState createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {

  CalendarController _calendarController;
  int weekDay = 1;
  StreamController<int> _days;
  String dayCurrent;




  void dayChange(int){
    weekDay = _calendarController.selectedDay.weekday;
    _days.add(weekDay);

  }


  @override
  void initState() {
    readGroup().then((value) {
      Data.group = value;
    });
    super.initState();
    _calendarController = CalendarController();
    _days = new StreamController<int>();
    _days.add(1);
  }



  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }


  String dayFormat(){
    switch(_calendarController.focusedDay.weekday) {
      case 1:
        dayCurrent = "ПОНЕДЕЛЬНИК";
        break;
        case 2:
        dayCurrent = "ВТОРНИК";
        break;
      case 3:
        dayCurrent = "СРЕДА";
        break;
      case 4:
        dayCurrent = "ЧЕТВЕРГ";
        break;
      case 5:
        dayCurrent = "ПЯТНИЦА";
        break;
      case 6:
        dayCurrent = "СУББОТА";
        break;
      }
      return dayCurrent;
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
      body: Column(children: [
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
                onDaySelected: (date,events, holidays){
                  setState(() {
                    dayChange(_calendarController.selectedDay.weekday);

                  });
                }

              ),
              Expanded(
                child:StreamBuilder(
                    stream: _days.stream,
                    builder: (context, snapshot){
                      return ListView.builder(
                      itemCount: Data.group.days[dayFormat()].length,
                      itemBuilder: (context, index) {

                            return lessonBar(
                              Data.group.days[dayFormat()][index].cabinet,
                              Data.group.days[dayFormat()][index].teacherName,
                              Data.group.days[dayFormat()][index].numberLesson
                                  .toString(),
                              Data.group.days[dayFormat()][index].typeOfLesson,
                              Data.group.days[dayFormat()][index].subject);


                        });
                }
              )
              )
  ]));}






Row lessonBar(String cabinet, String teacherName, String numberOfLesson,
    String lessonType, String subject) {
    if (subject.length > 35){
      String fullSubject = subject;
      subject = subject.substring(0, 35);
      subject = subject.substring(0, 34) + ".";
    }
  return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            width:35,
            margin: EdgeInsets.only(left: 10),
            padding: EdgeInsets.only(top: 20, bottom: 10),
            child: Text(cabinet,
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  color: Colors.white,
                ))),
        SizedBox(
            width: 35,
            height: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
            )),
        Container(
          width: 35,
          margin: EdgeInsets.only(left: 10),
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
            child: Text(
                subject,
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
    Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 5, right: 10, top: 20),
          child: Text(
              lessonType.toUpperCase(), style: TextStyle(color: Colors.white)),
        ),
        Container(
          padding: EdgeInsets.only(left: 5, right: 10, top: 10),
          child:IconButton(
            onPressed: (){},
            icon: Icon(
              Icons.remove_red_eye,
              color: Colors.white,
            ),
            iconSize: 10.0,
          )
        )
      ],
    )

  ]);
}
}