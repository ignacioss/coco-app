import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:coco_app/src/widgets/appLoadingSkeleton/app_loading_skeleton.dart';

class CardProductoGrande extends StatefulWidget {
  final String? imagen;
  final String? titulo;
  final String? precio;
  final String? descripcion;
  CardProductoGrande({this.imagen, this.precio, this.titulo, this.descripcion});

  @override
  _CardProductoGrandeState createState() => _CardProductoGrandeState();
}

class _CardProductoGrandeState extends State<CardProductoGrande> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 0.5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ], color: Colors.white, borderRadius: BorderRadius.circular(5)),
        margin: EdgeInsets.only(left: 70, right: 70, top: 50, bottom: 50),
        height: 350,
        child: Column(
          children: <Widget>[
            Container(
              child: Container(
                //padding: EdgeInsets.only(bottom: 80),
                //margin: EdgeInsets.only(bottom: 100),
                height: 230,
                width: double.infinity,
                //padding: EdgeInsets.all(value),
                //alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 0.5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5))),
                child: ClipRRect(
                  child: widget.imagen != null
                      ? TransitionToImage(
                          image: AdvancedNetworkImage(
                            widget.imagen,
                            cacheRule:
                                CacheRule(maxAge: const Duration(days: 30)),
                            useDiskCache: true,
                            timeoutDuration: Duration(seconds: 5),
                            retryLimit: 2,
                          ),
                          placeholder: AppLoadingSkeleton(),
                          loadingWidget: AppLoadingSkeleton(),
                          fit: BoxFit.fill,
                        )
                      : Image.asset(
                          'lib/assets/imagenes/logo.png',
                          fit: BoxFit.cover,
                        ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                ),
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    padding:
                        EdgeInsets.only(left: 10, top: 10, bottom: 5, right: 5),
                    width: double.infinity,
                    color: Colors.white,
                    child: Text(
                      widget.titulo!,
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontFamily: "Gotham"),
                    ),
                  ),
                  Container(
                    height: 5,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    padding: EdgeInsets.only(left: 10, bottom: 5, right: 5),
                    width: double.infinity,
                    child: Text("\$" + widget.precio!,
                        style: TextStyle(
                            color: Color(0xFF21BA86),
                            fontFamily: "Gotham",
                            fontSize: 18)),
                  ),
                  Container(
                    height: 5,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    padding: EdgeInsets.only(left: 10, bottom: 5, right: 5),
                    width: double.infinity,
                    child: Text(widget.descripcion!,
                        style: TextStyle(
                            color: Colors.grey[400], fontFamily: "Gotham")),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
