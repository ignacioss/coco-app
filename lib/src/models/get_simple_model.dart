import 'package:coco_app/src/utils/api_estado_peticion.dart';
import 'package:coco_app/src/utils/api_estado_pagina.dart';


class GetSimpleModel {
  ApiEstadoPeticion? _estadoPeticion;
  ApiEstadoPagina? _estadoPagina;

  List<dynamic>? _datos;

  GetSimpleModel.fromDecodedJson(Map<String, dynamic> parsedJson) {
    _estadoPeticion = ApiEstadoPeticion(parsedJson);
    _estadoPagina = ApiEstadoPagina(parsedJson);

    List<dynamic> resultado;

    try {
      resultado = parsedJson["datos"]["datos"];
    } catch (e) {
      // hubo un error al traer de la API. Dejar que el front lo procese
      return;
    }

    _datos = resultado;
  }

  List<dynamic> get datos => _datos!;
  ApiEstadoPeticion get estadoPeticion => _estadoPeticion!;
  ApiEstadoPagina get estadoPagina => _estadoPagina!;
}
