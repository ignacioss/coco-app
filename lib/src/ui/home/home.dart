import 'dart:async';
import 'dart:convert';

import 'package:coco_app/src/blocs/home_bloc.dart';
import 'package:coco_app/src/models/caption_images_model.dart';
import 'package:coco_app/src/models/category_model.dart';
import 'package:coco_app/src/models/images_model.dart';
import 'package:coco_app/src/models/instance_image_model.dart';
import 'package:coco_app/src/widgets/categoryIcon/categoryIcon.dart';
import 'package:coco_app/src/widgets/loadingOverlay/loading_overlay.dart';
import 'package:coco_app/src/widgets/paginationManager/pagination_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'dart:ui' as ui show Image;
import 'package:url_launcher/url_launcher.dart';

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
  late ui.Image imageSelected;
  late List<dynamic> arraySegmentation;

  ScrollController _scrollController = new ScrollController();

  ChangeNotifier _repaint = ChangeNotifier();

  List<CategoryModel> itemsSelected = [];

  @override
  void initState() {
    super.initState();
    categorySelected = -1;

    bloc = new HomeBloc();
    _controller = new TextEditingController();
    arrays = new Map<String, dynamic>();

    blocDataImages = [];
    blocDataImagesGet = [];
    blocDataImagesInstance = [];
    blocDataImagesCaption = [];
    allCategories = [];
    arraySegmentation = [];
    allCategoriesName = ['']; // It is necessary to adapt the widget of the textfield_tags library

    bloc.getTodosFetcher.listen((data) {
      listaApi = data.substring(0, data.indexOf('function'));
      listaApi = listaApi.replaceAll("\n", "");
      listaElementos = listaApi.split(";");

      // Get diferents arrays
      listaElementos.forEach((e) {
        if (e != "") {
          int indexIgual = e.indexOf("=");

          // Get name
          String name = e;
          name = name.substring(0, indexIgual - 1);
          name = name.replaceAll("var", "");
          name = name.trim();

          // Get values
          String tmpValores = e;
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

          /// Save all arrays in map [arrays]
          arrays[name] = valores;
        }
      });

      // Separate arrays
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
          bloc.postGetDataImage(blocDataImagesGet, queryType);
        } else if (queryType == "getImages") {
          blocDataImages = data.map((e) => ImageModel(e)).toList();
          queryType = "getInstances";
          bloc.postGetDataImage(blocDataImagesGet, queryType);
        } else if (queryType == "getInstances") {
          blocDataImagesInstance = data.map((e) => InstanceImageModel(e)).toList();
          queryType = "getCaptions";
          bloc.postGetDataImage(blocDataImagesGet, queryType);
        } else if (queryType == "getCaptions") {
          blocDataImagesCaption = data.map((e) => CaptionImagesModel(e)).toList();
        }
        if (blocDataGetImagesByCats.isNotEmpty &&
            blocDataImages.isNotEmpty &&
            blocDataImagesInstance.isNotEmpty &&
            blocDataImagesCaption.isNotEmpty) {
          setState(() {
            allLoadedImages = true;
            LoadingOverlay.of(context)!.setIsLoading(false);
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
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width - 75,
                              padding: EdgeInsets.only(top: 15, left: 10, right: 5, bottom: 5),
                              decoration: BoxDecoration(
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
                                  cursorColor: Colors.white,
                                  hintText: "Categories...",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  textStyle: TextStyle(color: Colors.black),
                                  isDense: false,
                                  contentPadding: EdgeInsets.all(0),
                                  textFieldFocusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black, width: 3.0),
                                  ),
                                  textFieldBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black, width: 3.0),
                                  ),
                                ),
                                onDelete: (tag) {
                                  if (tag != '') allCategoriesName.remove(tag);
                                  if(allCategoriesName.length == 0){
                                    setState(() {
                                      allCategoriesName= [''];
                                    });
                                  }

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
                            Container(
                              width: 15,
                            ),
                            GestureDetector(
                              onTap: () async {
                                LoadingOverlay.of(context)!.setIsLoading(true);
                                blocDataGetImagesByCats = [];
                                blocDataImages = [];
                                blocDataImagesInstance = [];
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
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).canvasColor,
                                    borderRadius: new BorderRadius.circular(5),
                                  ),
                                  child: Icon(
                                    Icons.search,
                                    color: Theme.of(context).primaryColor,
                                  )),
                            )
                          ],
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
                                                    setState(() {
                                                      select = true;
                                                      allCategoriesName.add(cate.name);
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
        height: 15,
      ),
      itemBuilder: (context, position) {
        ImageModel item = blocDataImages[position];

        var imagesCategory = [];
        List<InstanceImageModel> imageFotIconsCategory = [];
        var segmentation = new Map<String, dynamic>();
        for (int i = 0; i < blocDataImagesInstance.length; i++) {
          var e = blocDataImagesInstance[i];

          if (e.image_id == item.id) {
            imagesCategory.add(e);
            bool exist = false;

            for (int j = 0; j < imageFotIconsCategory.length; j++) {
              if (imageFotIconsCategory[j].category_id == e.category_id) {
                exist = true;
              }
            }
            if (!exist) {
              imageFotIconsCategory.add(e);
            }
          }
        }

        var viewSentencesArray = [];
        var captions = [];
        for (int i = 0; i < blocDataImagesCaption.length; i++) {
          var e = blocDataImagesCaption[i];
          if (e.image_id == item.id) {
            captions.add(e);
            viewSentencesArray.add(e.caption);
          }
        }

        // Convert Image.network to Image
        final Image imageUi = Image.network(
          item.coco_url,
          width: MediaQuery.of(context).size.width,
        );
        final completer = Completer<ui.Image>();
        imageUi.image
            .resolve(const ImageConfiguration())
            .addListener(ImageStreamListener((ImageInfo info, bool syncCall) => completer.complete(info.image)));

        var viewUrlsArray = [];
        viewUrlsArray.add('http://cocodataset.org/#explore?id=' + item.id.toString());
        viewUrlsArray.add(item.flickr_url);

        

        return Container(
            margin: EdgeInsets.only(bottom: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              //viewUrls = false;
                            });
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.transparent, width: 3),
                              image: DecorationImage(
                                  image: NetworkImage('https://cocodataset.org/images/cocoicons/url.jpg'), fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                           //   viewSentences != viewSentences;
                            });
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.transparent, width: 3),
                              image: DecorationImage(
                                  image: NetworkImage('https://cocodataset.org/images/cocoicons/sentences.jpg'), fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        for (var image in imageFotIconsCategory)
                          GestureDetector(
                            onTap: () {
                              categorySelected = image.category_id;
                              arraySegmentation = [];
                              for (int i = 0; i < blocDataImagesInstance.length; i++) {
                                var e = blocDataImagesInstance[i];
                                if (e.category_id == image.category_id && e.image_id == image.image_id) {
                                  arraySegmentation.add(e.segmentation);
                                }
                              }
                              setState(() {
                                // Notify to repaint CustomPaint
                                _repaint.notifyListeners();
                              });
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.transparent, width: 3),
                                image: DecorationImage(
                                    image:
                                        NetworkImage('https://cocodataset.org/images/cocoicons/' + image.category_id.toString() + '.jpg'),
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ),
                        GestureDetector(
                          onTap: () {
                            // Clear Seggments
                            arraySegmentation = [];
                            setState(() {
                              // Notify to repaint CustomPaint
                              _repaint.notifyListeners();
                            });
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.transparent, width: 3),
                              image: DecorationImage(
                                  image: NetworkImage('https://cocodataset.org/images/cocoicons/blank.jpg'), fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
               for(var link in viewUrlsArray)

                Container(
                  margin: EdgeInsets.only(bottom: 2),
                  child:  GestureDetector(
                      child: new Text(
                        link,
                        style: TextStyle(color: Colors.blue),
                      ),
                      onTap: () => launch(link)),
                ),
                Container(height: 5),
                for(var caption in viewSentencesArray)
                  Container(
                    margin: EdgeInsets.only(bottom: 2),
                    child: Text(
                      caption,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                FutureBuilder<ui.Image>(
                    future: completer.future,
                    builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
                      if (snapshot.hasData) {
                        imageSelected = snapshot.data!;
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            height: snapshot.data!.height + 15,
                            width: MediaQuery.of(context).size.width + 300,
                            child: CustomPaint(
                              painter: MyPainter(
                                  category: categorySelected, imageC: snapshot.data, segmentation: arraySegmentation, repaint: _repaint),
                            ),
                          ),
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              ],
            ));
      },
    );
  }
}

class MyPainter extends CustomPainter {
  MyPainter({required this.category, required this.imageC, required this.segmentation, required this.repaint});

  final int category;
  final ui.Image? imageC;
  final List<dynamic>? segmentation;
  final ChangeNotifier? repaint;

  @override
  Future<void> paint(Canvas canvas, Size size) async {
    canvas.drawImage(imageC!, Offset.zero, Paint());

    Paint paint1 = Paint();
    paint1
      ..color = Color(0xffff0000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    if (category != -1) {
      for (final drag in segmentation!) {
        Path path = Path();
        // var polys = jsonDecode(drag['segmentation']);
        var polys = jsonDecode(drag);

        // loop over all polygons
        for (var k = 0; k < polys.length; k++) {
          var poly = polys[k];

          path.moveTo(poly[0], poly[1]);
          for (var m = 0; m < poly.length - 2; m += 2) {
            // let's draw!!!!
            path.lineTo(poly[m + 2], poly[m + 3]);
          }
          path.lineTo(poly[0], poly[1]);
        }

        canvas.drawPath(path, paint1);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
