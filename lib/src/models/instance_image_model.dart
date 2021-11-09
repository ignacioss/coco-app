import 'package:coco_app/src/app/api_consts.dart';

class InstanceImageModel {
  int? _image_id;
  dynamic? _segmentation;
  int? _category_id;

  InstanceImageModel(result) {
    _image_id = result['image_id'];
    _segmentation = result['segmentation'];
    _category_id = result['category_id'];
  }

  int get category_id => _category_id!;
  dynamic get segmentation => _segmentation!;
  int get image_id => _image_id!;
}
