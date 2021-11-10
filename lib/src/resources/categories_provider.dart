import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart';
import 'package:coco_app/src/app/api_consts.dart';

class BannersProvider {
  Client client = Client();

  Future<String> getAll() async {
    String url = "$APIURL/other/cocoexplorer.js";

    final response = await client.get(url);

    if (response.statusCode == 200) {
      // listen for response
      final str = response.body.toString();

      return str;
    } else {
      throw Exception('Failed to load get');
    }
  }


  Future<List<int>> postGetDataFromCategories({
   required Map<String, dynamic> body,
  }) async {
    String url;

    url = "$APIURL_BIGQUERY";

    String listaIds = "";
    for (int id in body["category_ids"]) {
      listaIds = listaIds + "category_ids%5B%5D=" + id.toString() + "&";
    }
    listaIds = listaIds.substring(0, listaIds.length - 1);

      List<int> bodyBytes = utf8.encode(listaIds +"&querytype=" + body["querytype"]); // utf8 e
    Request request = new Request("POST", Uri.parse(url));
    // it's polite to send the body length to the server
    request.headers['Content-Length'] = bodyBytes.length.toString();
    request.headers['Content-Type'] = "application/x-www-form-urlencoded; charset=UTF-8";
    // todo add other headers here
    request.body = listaIds +"&querytype=" + body["querytype"];

    final response = await request.send();

    if (response.statusCode == 200) {
      // listen for response
      var responseJson = await response.stream.transform(utf8.decoder).first;
      responseJson = responseJson.replaceAll(" ", "");

      responseJson = responseJson.replaceAll("[", "");
      responseJson = responseJson.replaceAll("]", "");
      var arrayResult= responseJson.split(",");
      if(arrayResult.contains('')){ // To delete Empty element
        arrayResult.removeAt(arrayResult.indexOf(''));
      }
      List <int> result =[];
      arrayResult.forEach((e) {
        result.add( int.parse(e));
      });
      //var result = jsonMap["genre_ids"].cast<int>();
      return result;
    } else {
      // Si el error tiene un formato reconocible, devolverlo
      try {
        var responseJson = await response.stream.transform(utf8.decoder).first;
        return [];
      } catch (e) {
        throw Exception('Failed to load post');
      }
    }
  }



  Future<List<dynamic>> postGetDataFromImages({
   required Map<String, dynamic> body,
  }) async {
    String url;

    url = "$APIURL_BIGQUERY";

    String listaIds = "";
    for (int id in body["image_ids"]) {
      listaIds = listaIds + "image_ids%5B%5D=" + id.toString() + "&";
    }
    listaIds = listaIds.substring(0, listaIds.length - 1);

    List<int> bodyBytes = utf8.encode(listaIds + "&querytype=" + body["querytype"]); // utf8 encode
    Request request = new Request("POST", Uri.parse(url));
    // it's polite to send the body length to the server
    request.headers['Content-Length'] = bodyBytes.length.toString();
    request.headers['Content-Type'] = "application/x-www-form-urlencoded; charset=UTF-8";
    // todo add other headers here
    request.bodyBytes = bodyBytes;
    request.body = listaIds + "&querytype=" + body["querytype"];

    final response = await request.send();

    if (response.statusCode == 200) {
      // listen for response
      var responseJson;
      dynamic result;
      responseJson = await response.stream
          .transform(utf8.decoder)
          .transform(LineSplitter()).first;
      result = jsonDecode(responseJson);
      return result;
    } else {
      // Si el error tiene un formato reconocible, devolverlo
      try {
        var responseJson = await response.stream.transform(utf8.decoder).first;
        return [];
      } catch (e) {
        throw Exception('Failed to load post');
      }
    }
  }


}
