import 'package:flutter/material.dart';
import 'package:schedule/screens/group_search_screen.dart';
import 'package:schedule/screens/schedule_screen.dart';
import 'package:schedule/screens/welcome_screen.dart';
import 'services/http_client.dart';
import 'models/group.dart';
import 'services/response_decoder.dart';


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




