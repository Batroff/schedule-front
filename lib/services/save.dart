import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:path_provider/path_provider.dart';

import 'package:schedule/models/group.dart';

saveGroup(String text) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/group.json');
  await file.writeAsString(text);
  print('saved');
}

Future<Group> readGroup() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/group.json');
    String text = await file.readAsString();
    var group = Group.fromJson(jsonDecode(text));
    return group;
  } catch (e) {
    print("File read error");
    return null;
  }
}