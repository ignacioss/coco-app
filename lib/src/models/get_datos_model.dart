import 'package:coco_app/src/utils/api_estado_peticion.dart';
import 'package:coco_app/src/utils/api_estado_pagina.dart';
import 'dart:convert';


class GetDatosModel {
  ApiEstadoPeticion? _estadoPeticion;
  Map<String, dynamic>? _datos;

  GetDatosModel.fromDecodedJson(Map<String, dynamic> parsedJson) {
    _estadoPeticion = ApiEstadoPeticion(parsedJson);

    Map<String, dynamic> resultado;

    try {
      resultado = parsedJson["datos"]["datos"];
    } catch (e) {
      // hubo un error al traer de la API. Dejar que el front lo procese
      return;
    }

    _datos = resultado;
  }

  Map<String, dynamic> get datos => _datos!;
  ApiEstadoPeticion get estadoPeticion => _estadoPeticion!;
}
