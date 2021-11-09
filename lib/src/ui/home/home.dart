import 'dart:convert';

import 'package:coco_app/src/blocs/home_bloc.dart';
import 'package:coco_app/src/models/caption_images_model.dart';
import 'package:coco_app/src/models/category_model.dart';
import 'package:coco_app/src/models/images_model.dart';
import 'package:coco_app/src/models/instance_image_model.dart';
import 'package:coco_app/src/widgets/categoryIcon/categoryIcon.dart';
import 'package:coco_app/src/widgets/loadingOverlay/loading_overlay.dart';
import 'package:coco_app/src/widgets/paginationManager/pagination_list.dart';
import 'package:flutter/material.dart';
import 'package:textfield_tags/textfield_tags.dart';



class HomeScreen extends StatefulWidget {
  HomeScreen();

  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class SelectableWidget extends StatefulWidget {
  final _HomeScreenState viewModel;

  SelectableWidget(this.viewModel);

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TextEditingController _controller;
  late HomeBloc bloc;
  late List<dynamic> blocDataGetImagesByCats;
  late List<int> blocDataImagesGet;
  final FocusNode myFocusNode = FocusNode();

  late String queryType;
  late List<ImageModel> blocDataImages;
  late List<InstanceImageModel> blocDataImagesInstance;
  late List<CaptionImagesModel> blocDataImagesCaption;
  late String listaApi;
  List<String> listaElementos = [];
  List<dynamic> listaCategories = [];
  late List<CategoryModel> allCategories;
  late List<String> allCategoriesName;
  late List<String> catNames;
  late List<dynamic> superCats;
  late List<dynamic> iconsSelected;
  late List<dynamic> imIdList;
  late Map<String, dynamic> categories;
  late dynamic idToCat;
  late List<String> supeCats;
  late dynamic catToId;
  late Map<String, dynamic> arrays;
  bool allLoaded = false;
  bool allLoadedImages = false;
  int amountPerPage = 5;
  int numberPage = 0;
  late int categorySelected;

  ScrollController _scrollController = new ScrollController();

  List<CategoryModel> itemsSelected = [];

  @override
  void initState() {
    super.initState();
    categorySelected = 0;
    bloc = new HomeBloc();
    _controller = new TextEditingController();
    arrays = new Map<String, dynamic>();
    blocDataImages = [];
    blocDataImagesGet = [];
    blocDataImagesInstance = [];
    blocDataImagesCaption = [];
    allCategories = [];
    allCategoriesName = ['']; // It is necessary to adapt the widget of the textfield_tags library

    bloc.getTodosFetcher.listen((data) {
      listaApi = data.substring(0, data.indexOf('function'));
      listaApi = listaApi.replaceAll("\n", "");
      listaElementos = listaApi.split(";");
      listaElementos.forEach((e) {
        if (e != "") {
          int indexIgual = e.indexOf("=");

          String name = e; // Get name
          name = name.substring(0, indexIgual - 1);
          name = name.replaceAll("var", "");
          name = name.trim();

          String tmpValores = e; // Get values
          tmpValores = tmpValores.substring(indexIgual + 1, tmpValores.length);
          tmpValores = tmpValores.replaceAll(" ", "");
          tmpValores = tmpValores.replaceAll("'", "\"");

          if (tmpValores.contains("{1:")) {
            final regex = RegExp(r'([0-9]*[:])+');
            tmpValores = tmpValores.replaceAllMapped(regex, (match) {
              return "\"${match.group(0)}\"";
            });
            tmpValores = tmpValores.replaceAll(":\"\"", "\":\"");
            tmpValores = tmpValores.replaceAll("\"\"", "\"");
          }
          dynamic valores = jsonDecode(tmpValores);
          arrays[name] = valores;
        }
      });
      arrays.keys.forEach((element) {
        if (element == 'iconsSelected') {
          iconsSelected = arrays[element];
        } else if (element == 'imIdList') {
          imIdList = arrays[element];
        } else if (element == 'categories') {
          categories = arrays[element];
        } else if (element == 'superCats') {
          superCats = arrays[element];
        } else if (element == 'catToId') {
          catToId = arrays[element];
        } else if (element == 'idToCat') {
          idToCat = arrays[element];
        }
      });
      var j = 0;
      for (var i = 0; i < superCats.length; i++) {
        categories[superCats[i]]!.forEach((element) {
          final category = CategoryModel(element);
          allCategories.add(category);
          j++;
        });
      }
      setState(() {
        allLoaded = true;
      });
    });

    bloc.postGetDataFromCategoriesFetcher.listen((data) async {
      if (data.length > 0) {
        if (queryType == "getImagesByCats") {
          blocDataGetImagesByCats = data;
          var amount = amountPerPage;
          if (blocDataGetImagesByCats.length > amountPerPage) {
            amount = blocDataGetImagesByCats.length;
          }
          for (var i = 0; i < amount; i++) {
            blocDataImagesGet.add(blocDataGetImagesByCats[i]);
          }
          queryType = "getImages";
          await bloc.postGetDataImage(blocDataImagesGet, queryType);
        } else if (queryType == "getImages") {
          blocDataImages = data.map((e) => ImageModel(e)).toList();
          queryType = "getInstances";
          await bloc.postGetDataImage(blocDataImagesGet, queryType);
        } else if (queryType == "getInstances") {
          blocDataImagesInstance = data.map((e) => InstanceImageModel(e)).toList();
          queryType = "getCaptions";
          await bloc.postGetDataImage(blocDataImagesGet, queryType);
        } else if (queryType == "getCaptions") {
          blocDataImagesCaption = data.map((e) => CaptionImagesModel(e)).toList();
          setState(() {
            allLoadedImages = true;
            //       LoadingOverlay.of(context)!.setIsLoading(true);
          });
        }
      }
    });

    bloc.getAll();
  }

  @override
  void dispose() {
    //aqui va el dispose
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Center(
          child: SizedBox(
            height: 40,
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'COCO Explorer',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
            child: allLoaded == true
                ? Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 10, left: 10, right: 5, bottom: 5),
                  decoration: BoxDecoration(
                    //  border: new Border.all(color: Color(0xffE91E63), width: 1),
                    color: Colors.white,
                    borderRadius: new BorderRadius.circular(5),
                  ),
                  child: TextFieldTags(
                    myFocusNode: myFocusNode,
                    initialTags: allCategoriesName,
                    textSeparators: [" ", ".", ","],
                    tagsStyler: TagsStyler(
                      tagTextStyle: TextStyle(color: Colors.black),
                      tagDecoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      tagCancelIcon: Icon(Icons.cancel, size: 16.0, color: Theme.of(context).primaryColor),
                      tagPadding: const EdgeInsets.all(10.0),
                    ),
                    textFieldStyler: TextFieldStyler(
                      hintText: "Categories...",
                      hintStyle: TextStyle(color: Colors.grey),
                      textStyle: TextStyle(color: Colors.black),
                      isDense: false,
                      icon: Icon(Icons.search),
                      contentPadding: EdgeInsets.all(0),
                      textFieldFocusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 3.0),
                      ),
                      textFieldBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 3.0),
                      ),
                    ),
                    onDelete: (tag) {
                      allCategoriesName.remove(tag);
                    },
                    onTag: (tag) {
                      allCategoriesName.add(tag);
                    },
                    validator: (String tag) {
                      if (tag.length > 15) {
                        return "hey that is too much";
                      } else if (tag.isEmpty) {
                        return "enter something";
                      }

                      return null;
                    },
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final category in superCats)
                          categories[category] != null
                              ? Container(
                            width: 150,
                            child: GridView.count(
                              crossAxisCount: 2,
                              physics: const NeverScrollableScrollPhysics(),
                              //quita scroll del Grid
                              childAspectRatio: (10 / 10),
                              controller: new ScrollController(keepScrollOffset: false),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              children: List.generate(categories[category].length, (index) {
                                final cate = CategoryModel(categories[category][index]);
                                var select = false;
                                return Container(
                                  child: CategoryIcon(
                                      nombre: cate.name,
                                      id: cate.id,
                                      imagen: cate.image,
                                      selected: select,
                                      onUsarEmisora: () {
                                        print("click " + cate.name);
                                        setState(() {
                                          select = true;
                                          String name = cate.name;
                                          allCategoriesName.add(name);
                                          // allCategories.add(cate);
                                          print(allCategoriesName);
                                        });
                                        FocusScope.of(context).unfocus();
                                        FocusScope.of(context).requestFocus(myFocusNode);
                                      }),
                                );
                              }),
                            ),
                          )
                              : Container()
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 15,
                ),
                allLoadedImages == true
                    ? SingleChildScrollView(
                  child: Container(
                    child: _buildLista(),
                  ),
                )
                    : Container(),
                Container(
                  height: 15,
                ),
                Container(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () async {
                    // LoadingOverlay.of(context)!.setIsLoading(true);
                    blocDataImagesCaption = [];
                    if (allCategoriesName.contains('')) {
                      // To delete Empty element
                      allCategoriesName.removeAt(allCategoriesName.indexOf(''));
                    }
                    var categoryIds = [];
                    allCategoriesName.forEach((x) {
                      categoryIds.add(catToId[x]);
                    });
                    queryType = "getImagesByCats";
                    await bloc.postGetData(categoryIds, queryType);
                  },
                  child: Container(
                    color: Colors.grey,
                    child: Text("traer datos"),
                  ),
                )
              ],
            )
                : Container()),
      ),
    );
  }

  Widget _buildLista() {
    return PaginationList(
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 8),
      stream: bloc.postGetDataFromCategoriesFetcher,
      blocData: blocDataImages,
      scrollController: _scrollController,
      onGetPagina: (nroPagina) {
        var amount = amountPerPage;
        if (blocDataGetImagesByCats.length > amountPerPage) {
          amount = blocDataGetImagesByCats.length;
        }
        for (var i = 0; i < amount + nroPagina; i++) {
          blocDataImagesGet.add(blocDataGetImagesByCats[i]);
        }
        queryType = "getImages";
        bloc.postGetDataImage(blocDataImagesGet, queryType);
      },
      separator: Container(
        height: 5,
      ),
      itemBuilder: (context, position)  {
        ImageModel item = blocDataImages[position];

        var imagesCategory = [];
        List<InstanceImageModel> imageFotIconsCategory = [];
        for (int i = 0; i < blocDataImagesInstance.length; i++) {
          var e = blocDataImagesInstance[i];

          if (e.image_id == item.id) {
            imagesCategory.add(e);
            bool exist = false;
            /* for (int j = 0; j < imageFotIconsCategory.length; j++) {
              if (imageFotIconsCategory[j].category_id == e.category_id ) exist = true;
            }
            if (!exist) imageFotIconsCategory.add(e);*/
          }
        }

        var captions = [];
        for (int i = 0; i < blocDataImagesCaption.length; i++) {
          var e = blocDataImagesCaption[i];
          if (e.image_id == item.id) captions.add(e);
        }

        return Container(
          margin: EdgeInsets.only(bottom: 15),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.transparent, width: 3),
                      image: DecorationImage(image: NetworkImage('https://cocodataset.org/images/cocoicons/url.jpg'), fit: BoxFit.cover),
                    ),
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.transparent, width: 3),
                      image:
                      DecorationImage(image: NetworkImage('https://cocodataset.org/images/cocoicons/sentences.jpg'), fit: BoxFit.cover),
                    ),
                  ),
                     for (var image in imageFotIconsCategory)
                    GestureDetector(
                      onTap: () {
                        categorySelected = image.category_id;
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.transparent, width: 3),
                          image: DecorationImage(
                              image: NetworkImage('https://cocodataset.org/images/cocoicons/' + image.image_id.toString() + '.jpg'),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.transparent, width: 3),
                      image: DecorationImage(image: NetworkImage('https://cocodataset.org/images/cocoicons/blank.jpg'), fit: BoxFit.cover),
                    ),
                  ),
                ],
              ),
              /* FittedBox(
                child: SizedBox(
                  child: CustomPaint(
                    painter: MyPainter('https://cocodataset.org/images/cocoicons/' + image.toString() + '.jpg'),
                  ),
                ),
              ),*/
              Container(
                color: Colors.green,
                height: 15,
              ),

             Center(
               child:  Stack(
                 children: [
                   //Image.network(item.coco_url, fit: BoxFit.fill),
                   CustomPaint(
                     painter: MyPainter(category: categorySelected, image: item.coco_url),
                   )
                 ],
               ),
             )
            ],
          ),
        );
      },
    );
  }

}

class MyPainter extends CustomPainter {
  MyPainter({required this.category, required this.image});

  final int category;
  final String image;

  @override
  Future<void> paint(Canvas canvas, Size size) async {

    /*Image imageCategoryUrl = new Image.network(image);
    final Image imageCategory= new Image(image: imageCategoryUrl,);
    imageCategory = imageCategoryUrl as Image;


    canvas.drawImage(imageCategoryUrl, Offset.zero, Paint());*/
    Paint paint = Paint();
    paint
      ..color = Color(0xff000000)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0;

    Paint paint1 = Paint();
    paint1
      ..color = Color(0xffff0000)
      ..style = PaintingStyle.fill
      ..strokeWidth = 0;

    double width = size.width;
    double height = size.height;
    var as = Offset(width / 4, 0);
    print(as);

    Path path = Path();
    path.addPolygon([Offset.zero, Offset(width / 4, 0), Offset(width, height), Offset(width - (width / 4), height)], true);
    Path path2 = Path();
    path2.addPolygon([Offset(width, 0), Offset(width - (width / 4), 0), Offset(0, height), Offset(0 + (width / 4), height)], true);

    canvas.drawPath(path, paint1);
    canvas.drawPath(path2, paint1);
    // canvas.drawPath(path, paint); //border
    // canvas.drawPath(path2, paint); //border
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
