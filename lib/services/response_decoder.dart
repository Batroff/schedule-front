
import 'dart:convert';

import '../models/group.dart';

class ResponseGroup {
  String errorMsg;
  Group group;

  ResponseGroup(this.errorMsg, this.group);

  ResponseGroup.fromJson(Map<String, dynamic> json) :
      errorMsg = json['errorMsg'],
      group = Group.fromJson(json['group']);

  static ResponseGroup deserialize(json) {
    Map<String, dynamic> jsonDecoded = jsonDecode(json);
    return ResponseGroup.fromJson(jsonDecoded);
  }
}

class ResponseGroupList {
  String errorMsg;
  Map<String, bool> groupList;


  ResponseGroupList(this.errorMsg, this.groupList);

  ResponseGroupList.fromJson(Map<String, dynamic> json) :
      errorMsg = json['errorMsg'],
      groupList = Map<String, bool>.from(json['groupList']);

  static ResponseGroupList deserialize(json) {
    Map<String, dynamic> jsonDecoded = jsonDecode(json);
    return ResponseGroupList.fromJson(jsonDecoded);
  }
}