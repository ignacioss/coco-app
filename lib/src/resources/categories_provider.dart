import 'dart:convert';
import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:coco_app/src/models/get_datos_model.dart';
import 'package:http/http.dart';
import 'package:flutter/foundation.dart';
import 'package:coco_app/src/app/api_consts.dart';
import 'package:coco_app/src/models/get_simple_model.dart';

class BannersProvider {
  Client client = Client();

  Future<String> getAll() async {
    String url = "$APIURL/other/cocoexplorer.js";

    final response = await client.get(url);

    if (response.statusCode == 200) {
      // listen for response
      final str = response.body.toString();
/*
      final str = response.body.toString();
      const start = "categories =";
      const end = ";";

      final startIndex = str.indexOf(start);
      final endIndex = str.indexOf(end, startIndex + start.length);
      final finall=str.substring(startIndex + start.length, endIndex);
      print(str.substring(startIndex + start.length, endIndex));
      final arre = finall;
      //final list = json.decode(finall);
      List<String> stringList = finall.split("},");
      final listw = json.decode(finall) as List;
      final arr = finall as List;
      print(arr);
*/
      return str;
    } else {
      throw Exception('Failed to load get');
    }
  }


  Future<GetDatosModel> postGetDataFromCategories({
   required Map<String, dynamic> body,
  }) async {
    String url;

    url = "$APIURL_BIGQUERY";

    var request = new MultipartRequest("POST", Uri.parse(url));

    //request.headers.addAll({'Content-type': 'application/javascript; charset=utf-8'});

    body.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    request.headers.addAll({'Content-type': 'application/javascript'});

    final response = await request.send();

    if (response.statusCode == 200) {
      // listen for response
      var responseJson = await response.stream.transform(utf8.decoder).first;
      return GetDatosModel.fromDecodedJson(json.decode(responseJson));
    } else {
      // Si el error tiene un formato reconocible, devolverlo
      try {
        var responseJson = await response.stream.transform(utf8.decoder).first;
        return GetDatosModel.fromDecodedJson(json.decode(responseJson));
      } catch (e) {
        throw Exception('Failed to load post');
      }
    }
  }


}
