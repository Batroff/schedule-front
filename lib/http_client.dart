import 'dart:convert';
import 'dart:io';
import 'dart:async';

// final _host = InternetAddress.loopbackIPv4.host;
final _host = '10.0.2.2';
final _port = 8080;
HttpClient client = HttpClient();

void main() {
  request("БСБО-01-20");
}

Future<String> request(String group) async {
  final _path = '/?group=$group';
  final request = await client.get(_host, _port, _path);
  final response = await request.close();

  print(response.statusCode);
  print(response.headers.contentType);
  var json = '';
  await utf8.decoder.bind(response).forEach((element) => json += element);

  print(json);
  return json;
}