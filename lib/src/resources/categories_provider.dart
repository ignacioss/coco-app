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

  Future<GetDatosModel> getAll() async {
    String url = "$APIURL/other/cocoexplorer.js";

    final response = await client.get(url);

    if (response.statusCode == 200) {
      // listen for response

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



      return GetDatosModel.fromDecodedJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load get');
    }
  }
}
