import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:coco_app/src/utils/app_navigator.dart';
import 'package:coco_app/src/widgets/appLoadingSkeleton/app_loading_skeleton.dart';

class CardProductoChico extends StatefulWidget {
  final String? imagen;
  final String? titulo;
  final String? precio;
  final int? id;
  CardProductoChico({this.imagen, this.precio, this.titulo, this.id});

  @override
  _CardProductoChicoState createState() => _CardProductoChicoState();
}

class _CardProductoChicoState extends State<CardProductoChico> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
       // AppNavigator.goToDetallesProducto(context);
      },
      child: Container(
        margin: EdgeInsets.only(
          top: 10,
          bottom: 10,
          right: 15,
        ),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 0.5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ], color: Colors.white, borderRadius: BorderRadius.circular(5)),
        width: 150,
        height: 200,
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              height: 140,
              width: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                child: TransitionToImage(
                  image: AdvancedNetworkImage(
                    widget.imagen,
                    cacheRule: CacheRule(maxAge: const Duration(days: 30)),
                    useDiskCache: true,
                    timeoutDuration: Duration(seconds: 5),
                    retryLimit: 2,
                  ),
                  loadingWidget: AppLoadingSkeleton(),
                  placeholder: AppLoadingSkeleton(),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 5),
              width: double.infinity,
              color: Colors.white,
              child: Text(
                widget.titulo!,
                maxLines: 2,
                style: TextStyle(
                    color: Color(0xFF85909D),
                    fontFamily: "Gotham",
                    fontSize: 12),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              padding: EdgeInsets.only(left: 10, right: 5),
              width: double.infinity,
              child: Text(
                widget.precio!,
                style: TextStyle(
                    color: Color(0xFF85909D),
                    fontFamily: "Gotham",
                    fontSize: 12),
              ),
            ),
            Container(
              height: 4,
            )
          ],
        ),
      ),
    );
  }
}
