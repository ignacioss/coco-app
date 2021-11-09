import 'package:coco_app/src/app/api_consts.dart';

class ImageModel {
  int? _id;
  String? _coco_url;
  String? _flickr_url;

  ImageModel(result) {
    _id = result['id'];
    _coco_url = result['coco_url'];
    _flickr_url = result['flickr_url'];
  }

  String get coco_url => _coco_url!;
  String get flickr_url => _flickr_url!;
  int get id => _id!;
}
