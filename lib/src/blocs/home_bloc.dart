import 'package:coco_app/src/models/get_datos_model.dart';
import 'package:coco_app/src/resources/categories_repository.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc {
  final _categoriesRepository = CategoriesRepository();
  bool isDisposed = false;

  final _getAllCategoriesFetcher = PublishSubject<String>();
  final _postGetDataFromCategoriesFetcher = PublishSubject<GetDatosModel>();

  getAll() async {
    String itemModel = await _categoriesRepository.getAll();
    if (!isDisposed) {
      _getAllCategoriesFetcher.sink.add(itemModel);
    }
  }

  postGetDataFromCategories(dynamic category_ids) async {
    GetDatosModel itemModel = await _categoriesRepository.postGetDataFromCategories(
      data: {
        "category_ids": category_ids,
        "querytype":"getImagesByCats"
      },
    );
    if (!isDisposed) {
      _postGetDataFromCategoriesFetcher.sink.add(itemModel);
    }
  }

  dispose() {
    _getAllCategoriesFetcher.close();
    _postGetDataFromCategoriesFetcher.close();
    isDisposed = true;
  }

  Stream<String> get getTodosFetcher => _getAllCategoriesFetcher.stream;
  Stream<GetDatosModel> get postGetDataFromCategoriesFetcher => _postGetDataFromCategoriesFetcher.stream;
}
