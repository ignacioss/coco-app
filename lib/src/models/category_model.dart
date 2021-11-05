import 'package:coco_app/src/app/api_consts.dart';

class CategoryModel {
  String? _supercategory;
  int? _id;
  String? _name;
  String? _image;

  CategoryModel(result) {
    _supercategory = result['supercategory'];
    _id = result['id'];
    _name = result['name'];
    _image = "$APIURL/images/cocoicons/"+result['id'].toString()+".jpg";
  }

  String get supercategory => _supercategory!;
  String get name => _name!;
  String get image => _image!;
  int get id => _id!;
}
