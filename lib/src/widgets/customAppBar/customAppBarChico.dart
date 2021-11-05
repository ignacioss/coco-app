import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:coco_app/src/utils/app_navigator.dart';
import 'package:coco_app/src/widgets/appLoadingSkeleton/app_loading_skeleton.dart';

class CustomAppBarChico extends StatefulWidget implements PreferredSizeWidget {
  final String? titulo;
  final bool? buscar;
  final bool? forzarVolverHome;
  final bool? esChat;
  final bool? atras;
  final String? imagen;
  final String? nombre;

  CustomAppBarChico({
    Key? key,
    this.titulo,
    this.buscar = false,
    this.atras = true,
    this.forzarVolverHome = false,
    this.esChat = false,
    this.imagen,
    this.nombre,
  }) : super(key: key);

  @override
  final Size preferredSize = Size.fromHeight(60);

  @override
  _CustomAppBarChicoState createState() => _CustomAppBarChicoState();
}

class _CustomAppBarChicoState extends State<CustomAppBarChico> {
  bool buscar = false;
  late String formBuscar;
  late FocusNode formBuscarFocusNode;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Material(
        color: Colors.white,
        child: SafeArea(
          top: true,
          child: widget.esChat == false
              ? Container(
                  margin: EdgeInsets.only(
                    left: 5,
                    right: 5,
                  ),
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 60,
                    child: Row(
                      children: <Widget>[
                        widget.atras == true
                            ? Container(
                                child: IconButton(
                                  alignment: Alignment.centerLeft,
                                  onPressed: () {
                                    if (widget.forzarVolverHome == true) {
                                      AppNavigator.goToHome(context);
                                    } else {
                                      Navigator.pop(context);
                                    }
                                  },
                                  icon: Icon(Icons.arrow_back, size: 30),
                                  color: Theme.of(context).primaryColor,
                                ),
                              )
                            : Container(
                                height: 40,
                              ),
                        buscar == false
                            ? Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Text(
                                    widget.titulo!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: "Gotham"),
                                  ),
                                ),
                              )
                            : Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  alignment: Alignment.center,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).canvasColor,
                                    borderRadius:
                                        new BorderRadius.circular(30.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                    ),
                                    child: TextFormField(
                                      focusNode: formBuscarFocusNode,
                                      autofocus: true,
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontFamily: "Gotham"),
                                      decoration: InputDecoration(
                                        fillColor: Colors.transparent,
                                        hintText: "Buscar",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        widget.buscar!
                            ? Container(
                                child: IconButton(
                                  alignment: Alignment.centerLeft,
                                  onPressed: () {
                                    setState(() {
                                      if (buscar) {
                                        buscar = false;
                                      } else {
                                        buscar = true;
                                      }
                                    });
                                  },
                                  icon: buscar
                                      ? Icon(Icons.close, size: 30)
                                      : Icon(Icons.search, size: 30),
                                  color: Theme.of(context).primaryColor,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                )
              : Container(
                  margin: EdgeInsets.only(
                    left: 5,
                    right: 5,
                  ),
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 60,
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: IconButton(
                            alignment: Alignment.centerLeft,
                            onPressed: () {
                              if (widget.forzarVolverHome!) {
                                AppNavigator.goToHome(context);
                              } else {
                                Navigator.pop(context);
                              }
                            },
                            icon: Icon(Icons.arrow_back, size: 30),
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(50)),
                                  child: ClipOval(
                                    child: widget.imagen != null
                                        ? TransitionToImage(
                                            image: AdvancedNetworkImage(
                                              widget.imagen,
                                              cacheRule: CacheRule(
                                                  maxAge:
                                                      const Duration(days: 30)),
                                              useDiskCache: true,
                                              timeoutDuration:
                                                  Duration(seconds: 5),
                                              retryLimit: 2,
                                            ),
                                            loadingWidget: AppLoadingSkeleton(),
                                            placeholder: AppLoadingSkeleton(),
                                            fit: BoxFit.cover,
                                          )
                                        : TransitionToImage(
                                            image: AdvancedNetworkImage(
                                              "https://cdn4.iconfinder.com/data/icons/small-n-flat/24/user-alt-512.png",
                                              cacheRule: CacheRule(
                                                  maxAge:
                                                      const Duration(days: 30)),
                                              useDiskCache: true,
                                              timeoutDuration:
                                                  Duration(seconds: 5),
                                              retryLimit: 2,
                                            ),
                                            color: Colors.grey,
                                            loadingWidget: AppLoadingSkeleton(),
                                            placeholder: AppLoadingSkeleton(),
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        widget.titulo!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: "Gotham"),
                                      ),
                                      widget.nombre != null
                                          ? Text(
                                              widget.nombre!,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .accentColor,
                                                  fontFamily: "Gotham"),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 20,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
