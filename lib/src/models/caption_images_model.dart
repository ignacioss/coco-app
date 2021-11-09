import 'package:coco_app/src/app/api_consts.dart';

class CaptionImagesModel {
  int? _image_id;
  String? _caption;

  CaptionImagesModel(result) {
    _image_id = result['image_id'];
    _caption = result['caption'];
  }

  String get caption => _caption!;
  int get image_id => _image_id!;
}
