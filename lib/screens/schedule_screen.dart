import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule/models/group.dart';
import 'package:schedule/services/http_client.dart';
import 'package:schedule/services/response_decoder.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ThirdScreen extends StatefulWidget{
  @override
  _ThirdScreenState createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {

  List<Lesson> lessons = [
    Lesson('410', 'Беклемишев', '1', 'П', 'Math'),
    Lesson('410', 'АНТОНОВА', '1', 'П', 'Math'),
    Lesson('410', 'ЧИСТЯКОВА', '1', 'П', 'Math'),
    Lesson('410', 'ШАМИЛЬ', '1', 'П', 'Math')
  ];
  CalendarController _calendarController;

  @override
  void initState(){
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void dispose(){
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
          title: Text("Расписание", style:TextStyle(
            color: Colors.white
          ), ),
        ),
        body: Column(
          children: [
            TableCalendar(
                calendarController: _calendarController,
                initialCalendarFormat: CalendarFormat.week,
              startingDayOfWeek: StartingDayOfWeek.monday,
              formatAnimation: FormatAnimation.slide,
              headerStyle: HeaderStyle(
                centerHeaderTitle: true,
                formatButtonVisible: true,
                formatButtonTextStyle: TextStyle(
                  color: Colors.white
                ),
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 18
                ),
                leftChevronIcon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 14,),
                rightChevronIcon: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14,),
                leftChevronMargin: EdgeInsets.only(left: 10),
                rightChevronMargin: EdgeInsets.only(right:10),
              ),
             calendarStyle: CalendarStyle(
               weekdayStyle: TextStyle(
                 color: Colors.white
               ),
               weekendStyle: TextStyle(
                 color: Colors.white
               )
             ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekendStyle: TextStyle(
                  color: Colors.white),
                weekdayStyle: TextStyle(
                  color: Colors.white)
                ),
              ),
            Expanded(
                child: ListView.builder(
                  itemCount: lessons.length,
                  itemBuilder: (context, index){
                    return lessonBar(lessons[index].cabinet, lessons[index].teacherName, lessons[index].numberOfLesson, lessons[index].lessonType, lessons[index].subject);
                  })
            )
          ]
        ),
      );
    }
}

Row lessonBar(String cabinet, String teacherName, String numberOfLesson, String lessonType, String subject){
  return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
                padding: EdgeInsets.only(left:20, right:20, top:20, bottom: 10),
                child:Text(cabinet, style: TextStyle(
                  color: Colors.white,)
                )
            ),
            SizedBox(width: 30, height: 1, child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
            )),
            Container(
              padding: EdgeInsets.only(left:20, right: 20, bottom: 20, top: 10),
              child: Text(numberOfLesson, style: TextStyle(
                color: Colors.white,
              )),
            )

          ],
        ),
        SizedBox(height: 10,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.only(left:20, right:20, top: 20, bottom: 15),
                child: Text(subject, style: TextStyle(
                  color: Colors.white,
                ))
            ),
            SizedBox(height: 10),
            Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Text(teacherName, style: TextStyle(
                  color: Colors.white,
                ))
            )
          ],

        ),
        Expanded(
          child: Container(),
        ),
        Container(
          padding: EdgeInsets.only(right:20, top: 20),
          child: Text(lessonType, style: TextStyle(
              color: Colors.white
          )),
        )
      ]
  );
}

class Lesson{
  final String cabinet;
  final String teacherName;
  final String numberOfLesson;
  final String lessonType;
  final String subject;

  Lesson(this.cabinet, this.teacherName, this.numberOfLesson, this.lessonType, this.subject);

}