import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RequestProcessor {
  final String url;
  RequestProcessor({this.url});

  Future getData({@required String url}) async {
    try {
      http.Response res = await http.get(url);
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        print(res.statusCode);
      }
    } catch (e) {
      print(e);
      // return (e);
    }
  }

  Future postData({@required String url, @required Map data}) async {
    try {
      http.Response res = await http.post(url, body: data);
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return res.statusCode;
      }
    } catch (e) {
      print(e);
      return e;
    }
  }
}
