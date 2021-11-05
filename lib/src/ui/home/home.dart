import 'package:coco_app/src/blocs/home_bloc.dart';
import 'package:coco_app/src/models/category_model.dart';
import 'package:coco_app/src/widgets/categoryIcon/categoryIcon.dart';
import 'package:coco_app/src/widgets/customAppBar/customAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';


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
  late List<dynamic> blocData;

  late List<CategoryModel> allCategories;
  late List<String> allCategoriesName;
  late List<String> catNames;
  List<String> superCats = [
    'accessory',
    'vehicle',
    'outdoor',
    'animal',
    'sports',
    'kitchen',
    'food',
    'furniture',
    'electronic',
    'appliance',
    'indoor'
  ];

  List<CategoryModel> itemsSelected = [];
  var categories = {
    'outdoor': [
      {'supercategory': 'outdoor', 'id': 10, 'name': 'traffic light'},
      {'supercategory': 'outdoor', 'id': 11, 'name': 'fire hydrant'},
      {'supercategory': 'outdoor', 'id': 13, 'name': 'stop sign'},
      {'supercategory': 'outdoor', 'id': 14, 'name': 'parking meter'},
      {'supercategory': 'outdoor', 'id': 15, 'name': 'bench'}
    ],
    'food': [
      {'supercategory': 'food', 'id': 52, 'name': 'banana'},
      {'supercategory': 'food', 'id': 53, 'name': 'apple'},
      {'supercategory': 'food', 'id': 54, 'name': 'sandwich'},
      {'supercategory': 'food', 'id': 55, 'name': 'orange'},
      {'supercategory': 'food', 'id': 56, 'name': 'broccoli'},
      {'supercategory': 'food', 'id': 57, 'name': 'carrot'},
      {'supercategory': 'food', 'id': 58, 'name': 'hot dog'},
      {'supercategory': 'food', 'id': 59, 'name': 'pizza'},
      {'supercategory': 'food', 'id': 60, 'name': 'donut'},
      {'supercategory': 'food', 'id': 61, 'name': 'cake'}
    ],
    'indoor': [
      {'supercategory': 'indoor', 'id': 84, 'name': 'book'},
      {'supercategory': 'indoor', 'id': 85, 'name': 'clock'},
      {'supercategory': 'indoor', 'id': 86, 'name': 'vase'},
      {'supercategory': 'indoor', 'id': 87, 'name': 'scissors'},
      {'supercategory': 'indoor', 'id': 88, 'name': 'teddy bear'},
      {'supercategory': 'indoor', 'id': 89, 'name': 'hair drier'},
      {'supercategory': 'indoor', 'id': 90, 'name': 'toothbrush'}
    ],
    'appliance': [
      {'supercategory': 'appliance', 'id': 78, 'name': 'microwave'},
      {'supercategory': 'appliance', 'id': 79, 'name': 'oven'},
      {'supercategory': 'appliance', 'id': 80, 'name': 'toaster'},
      {'supercategory': 'appliance', 'id': 81, 'name': 'sink'},
      {'supercategory': 'appliance', 'id': 82, 'name': 'refrigerator'}
    ],
    'sports': [
      {'supercategory': 'sports', 'id': 34, 'name': 'frisbee'},
      {'supercategory': 'sports', 'id': 35, 'name': 'skis'},
      {'supercategory': 'sports', 'id': 36, 'name': 'snowboard'},
      {'supercategory': 'sports', 'id': 37, 'name': 'sports ball'},
      {'supercategory': 'sports', 'id': 38, 'name': 'kite'},
      {'supercategory': 'sports', 'id': 39, 'name': 'baseball bat'},
      {'supercategory': 'sports', 'id': 40, 'name': 'baseball glove'},
      {'supercategory': 'sports', 'id': 41, 'name': 'skateboard'},
      {'supercategory': 'sports', 'id': 42, 'name': 'surfboard'},
      {'supercategory': 'sports', 'id': 43, 'name': 'tennis racket'}
    ],
    'animal': [
      {'supercategory': 'animal', 'id': 16, 'name': 'bird'},
      {'supercategory': 'animal', 'id': 17, 'name': 'cat'},
      {'supercategory': 'animal', 'id': 18, 'name': 'dog'},
      {'supercategory': 'animal', 'id': 19, 'name': 'horse'},
      {'supercategory': 'animal', 'id': 20, 'name': 'sheep'},
      {'supercategory': 'animal', 'id': 21, 'name': 'cow'},
      {'supercategory': 'animal', 'id': 22, 'name': 'elephant'},
      {'supercategory': 'animal', 'id': 23, 'name': 'bear'},
      {'supercategory': 'animal', 'id': 24, 'name': 'zebra'},
      {'supercategory': 'animal', 'id': 25, 'name': 'giraffe'}
    ],
    'vehicle': [
      {'supercategory': 'vehicle', 'id': 2, 'name': 'bicycle'},
      {'supercategory': 'vehicle', 'id': 3, 'name': 'car'},
      {'supercategory': 'vehicle', 'id': 4, 'name': 'motorcycle'},
      {'supercategory': 'vehicle', 'id': 5, 'name': 'airplane'},
      {'supercategory': 'vehicle', 'id': 6, 'name': 'bus'},
      {'supercategory': 'vehicle', 'id': 7, 'name': 'train'},
      {'supercategory': 'vehicle', 'id': 8, 'name': 'truck'},
      {'supercategory': 'vehicle', 'id': 9, 'name': 'boat'}
    ],
    'furniture': [
      {'supercategory': 'furniture', 'id': 62, 'name': 'chair'},
      {'supercategory': 'furniture', 'id': 63, 'name': 'couch'},
      {'supercategory': 'furniture', 'id': 64, 'name': 'potted plant'},
      {'supercategory': 'furniture', 'id': 65, 'name': 'bed'},
      {'supercategory': 'furniture', 'id': 67, 'name': 'dining table'},
      {'supercategory': 'furniture', 'id': 70, 'name': 'toilet'}
    ],
    'accessory': [
      {'supercategory': 'person', 'id': 1, 'name': 'person'},
      {'supercategory': 'accessory', 'id': 27, 'name': 'backpack'},
      {'supercategory': 'accessory', 'id': 28, 'name': 'umbrella'},
      {'supercategory': 'accessory', 'id': 31, 'name': 'handbag'},
      {'supercategory': 'accessory', 'id': 32, 'name': 'tie'},
      {'supercategory': 'accessory', 'id': 33, 'name': 'suitcase'}
    ],
    'electronic': [
      {'supercategory': 'electronic', 'id': 72, 'name': 'tv'},
      {'supercategory': 'electronic', 'id': 73, 'name': 'laptop'},
      {'supercategory': 'electronic', 'id': 74, 'name': 'mouse'},
      {'supercategory': 'electronic', 'id': 75, 'name': 'remote'},
      {'supercategory': 'electronic', 'id': 76, 'name': 'keyboard'},
      {'supercategory': 'electronic', 'id': 77, 'name': 'cell phone'}
    ],
    'kitchen': [
      {'supercategory': 'kitchen', 'id': 44, 'name': 'bottle'},
      {'supercategory': 'kitchen', 'id': 46, 'name': 'wine glass'},
      {'supercategory': 'kitchen', 'id': 47, 'name': 'cup'},
      {'supercategory': 'kitchen', 'id': 48, 'name': 'fork'},
      {'supercategory': 'kitchen', 'id': 49, 'name': 'knife'},
      {'supercategory': 'kitchen', 'id': 50, 'name': 'spoon'},
      {'supercategory': 'kitchen', 'id': 51, 'name': 'bowl'}
    ]
  };

  @override
  void initState() {
    super.initState();

    bloc = new HomeBloc();
    _controller = new TextEditingController();


    allCategories = [];
    allCategoriesName = [];
    blocData = [];
    bloc.getTodosFetcher.listen((data) {
      if (data.estadoPeticion.estado == 1) {
        setState(() {
          blocData = data.datos as List;
        });
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

     catNames = [
      'person', 'bicycle', 'car', 'motorcycle', 'airplane', 'bus', 'train', 'truck', 'boat', 'traffic light', 'fire hydrant', 'stop sign', 'parking meter', 'bench', 'bird', 'cat', 'dog', 'horse', 'sheep', 'cow', 'elephant', 'bear', 'zebra', 'giraffe', 'backpack', 'umbrella', 'handbag', 'tie', 'suitcase', 'frisbee', 'skis', 'snowboard', 'sports ball', 'kite', 'baseball bat', 'baseball glove', 'skateboard', 'surfboard', 'tennis racket', 'bottle', 'wine glass', 'cup', 'fork', 'knife', 'spoon', 'bowl', 'banana', 'apple', 'sandwich', 'orange', 'broccoli', 'carrot', 'hot dog', 'pizza', 'donut', 'cake', 'chair', 'couch', 'potted plant', 'bed', 'dining table', 'toilet', 'tv', 'laptop', 'mouse', 'remote', 'keyboard', 'cell phone', 'microwave', 'oven', 'toaster', 'sink', 'refrigerator', 'book', 'clock', 'vase', 'scissors', 'teddy bear', 'hair drier', 'toothbrush'
    ];
    //bloc.getAll();
  }

  @override
  void dispose() {
    //aqui va el dispose
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
          child: Column(
            children: [
             /* Container(
                padding: EdgeInsets.only(top: 10, left: 10, right: 5, bottom: 5),
                decoration: BoxDecoration(
                  //  border: new Border.all(color: Color(0xffE91E63), width: 1),
                  color: Colors.white,
                  borderRadius: new BorderRadius.circular(5),
                ),
                child: TextFieldTags(

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
              ),*/
              Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.circular(30.0),
                ),
                child: TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: _controller,
                    onSubmitted: (val) {
                     //hacer lo que quieras
                      _controller.clear();
                    },
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      prefixIcon:
                      Icon(Icons.search, color: Colors.grey[400]),
                      suffixIcon: IconButton(
                        onPressed: () {
                          Future.microtask(() => _controller.clear());
                          Future.delayed(Duration(milliseconds: 50))
                              .then((_) {
                            FocusScope.of(context)
                                .requestFocus(FocusNode());
                          });
                        },
                        icon: Icon(Icons.close),
                      ),
                      hintText: "Buscar",
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      labelStyle: TextStyle(color: Colors.grey[400]),
                      prefixStyle: TextStyle(color: Colors.grey[400]),
                      suffixStyle: TextStyle(color: Colors.grey[400]),
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(
                            width: 0, color: Colors.transparent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(
                            width: 0, color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(
                            width: 0, color: Colors.transparent),
                      ),
                    ),
                  ),
                  suggestionsBoxDecoration: SuggestionsBoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white),
                  suggestionsCallback: (pattern) async {
                    // return await BackendService.getSuggestions(pattern);
                    return catNames;
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(
                        'asd' ,
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  },
                  loadingBuilder: (context) {
                    return Container(
                      height: 100,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    );
                  },
                  keepSuggestionsOnLoading: true,
                  onSuggestionSelected: (suggestion) {
                  // cuadno clickeas la suguerencia
                    _controller.clear();
                  },
                  noItemsFoundBuilder: (context) {
                    return Container(
                      height: 80,
                      child: Center(
                        child: Text(
                          "Sin sugerencias",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
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
                                  children: List.generate(categories[category]!.length, (index) {
                                    final cate = CategoryModel(categories[category]![index]);

                                    return Container(
                                      child: CategoryIcon(
                                          nombre: cate.name,
                                          id: cate.id,
                                          imagen: cate.image,
                                          onUsarEmisora: () {
                                            print("click "+ cate.name);
                                            setState(() {
                                              String name= cate.name;
                                              allCategoriesName.add(name);
                                              allCategories.add(cate);
                                              print(allCategoriesName);
                                            });
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
              Text(allCategoriesName.length.toString()),
              Container(
                height: 15,
              ),

            ],
          ),
        ),
      ),
    );
  }
}
