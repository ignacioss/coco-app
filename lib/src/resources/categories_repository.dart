import 'dart:async';
import 'package:coco_app/src/models/get_datos_model.dart';
import 'package:flutter/foundation.dart';
import 'package:coco_app/src/models/get_simple_model.dart';
import 'package:coco_app/src/resources/categories_provider.dart';

class CategoriesRepository {
  final apiProvider = BannersProvider();

  Future<GetDatosModel> getAll({
    int pagina = 1,
  }) {
    return apiProvider.getAll();
  }
}
