import 'package:coco_app/src/models/get_datos_model.dart';
import 'package:coco_app/src/resources/categories_repository.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc {
  final _categoriesRepository = CategoriesRepository();
  bool isDisposed = false;

  final _getAllCategoriesFetcher = PublishSubject<String>();
  final _postGetDataFromCategoriesFetcher = PublishSubject<List<dynamic>>();

  getAll() async {
    String itemModel = await _categoriesRepository.getAll();
    if (!isDisposed) {
      _getAllCategoriesFetcher.sink.add(itemModel);
    }
  }

  postGetData(dynamic array_ids, String querytype) async {
    List<int> itemModel = await _categoriesRepository.postGetDataFromCategories(
      data: {
        "category_ids": array_ids,
        "querytype":querytype
      },
    );
    if (!isDisposed) {
      _postGetDataFromCategoriesFetcher.sink.add(itemModel);
    }
  }

  postGetDataImage(dynamic array_ids, String querytype) async {
    List<dynamic> itemModel = await _categoriesRepository.postGetDataFromImages(
      data: {
        "image_ids": array_ids,
        "querytype":querytype
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
  Stream<List<dynamic>> get postGetDataFromCategoriesFetcher => _postGetDataFromCategoriesFetcher.stream;
}
