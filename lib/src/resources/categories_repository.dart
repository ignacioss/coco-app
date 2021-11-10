import 'dart:async';
import 'package:coco_app/src/resources/categories_provider.dart';

class CategoriesRepository {
  final apiProvider = BannersProvider();

  Future<String> getAll({
    int pagina = 1,
  }) {
    return apiProvider.getAll();
  }

  Future<List<int>> postGetDataFromCategories({
    required Map<String, dynamic> data,
  }) {
    return apiProvider.postGetDataFromCategories(body: data,);
  }
  Future<List<dynamic>> postGetDataFromImages({
    required Map<String, dynamic> data,
  }) {
    return apiProvider.postGetDataFromImages(body: data,);
  }
}
