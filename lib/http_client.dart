import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'response_decoder.dart';

// DEBUG ENTRY POINT
void main() async {
  // var res = await new Client("127.0.0.1:8080").requestJson(method: "GET", location: "/api/group/", query: {"group": "БСGБО-01-20"});
  // var resDecoded = ResponseGroup.deserialize(res);
  //
  // var group = resDecoded.group;
  // if (group != null) {
  //   group.showInfo();
  // } else {
  //   print("group is null");
  // }
  var res = await new Client("127.0.0.1:8080").requestJson(method: "GET", location: "/api/groupList");
  var resDecoded = ResponseGroupList.deserialize(res);
  print(resDecoded.groupList);
}

class Client {
  HttpClient client = HttpClient();
  String baseUrl;

  Client(String baseUrl) {
    this.baseUrl = baseUrl;
  }

  /// `request` takes `(method, location, {query})` params.
  /// Returns HttpClientResponse
  Future<HttpClientResponse> request({String method="GET", String location="", Map<String, dynamic> query}) async {
    var uri = new Uri.http(this.baseUrl, location, query);
    final request = await client.openUrl(method, uri);

    final response = await request.close();

    if (response.statusCode == 200) {
      return response;
    } else return response;//если статус код не 200 в теле ответа есть сообщение об ошибке
    throw HttpException("Expected 200 status code, got ${response.statusCode} caused by ${response.reasonPhrase}");
  }

  /// `request` takes `(method, location, {query})` params.
  /// Returns json
  Future<String> requestJson({String method="GET", String location="", Map<String, dynamic> query}) async {
    var response = await request(method: method, location: location, query: query);

    var json = '';
    await utf8.decoder.bind(response).forEach((element) => json += element);
    return json;
  }
}

