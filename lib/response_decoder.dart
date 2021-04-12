
import 'dart:convert';

import 'group.dart';

class Response {
  String errorMsg;
  Group group;

  Response(this.errorMsg, this.group);

  Response.fromJson(Map<String, dynamic> json) :
      errorMsg = json['ErrorMsg'],
      group = Group.fromJson(json['Group']);
}

Response deserialize(json) {
  Map<String, dynamic> jsonDecoded = jsonDecode(json);
  return Response.fromJson(jsonDecoded);
}