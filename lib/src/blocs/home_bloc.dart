
import 'package:coco_app/src/models/get_datos_model.dart';
import 'package:coco_app/src/resources/categories_repository.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc {
  final _categoriesRepository = CategoriesRepository();
  bool isDisposed = false;

  final _getAllCategoriesFetcher = PublishSubject<GetDatosModel>();

  getAll() async {
    GetDatosModel itemModel = await _categoriesRepository.getAll();
    if (!isDisposed) {
      _getAllCategoriesFetcher.sink.add(itemModel);
    }
  }

  dispose() {
    _getAllCategoriesFetcher.close();
    isDisposed = true;
  }

  Stream<GetDatosModel> get getTodosFetcher => _getAllCategoriesFetcher.stream;
}
