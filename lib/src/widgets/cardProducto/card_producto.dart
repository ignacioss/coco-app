import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:coco_app/src/widgets/appLoadingSkeleton/app_loading_skeleton.dart';

class CardProducto extends StatelessWidget {
  final int? id;
  final String? imagen;
  final String? titulo;
  final String? precio;
  final bool? favorito;
  final Function onPressed;

  CardProducto({
    this.id,
    this.imagen,
    this.precio,
    this.titulo,
    required this.onPressed,
    this.favorito,
  });



  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: onPressed(),
          child: Column(
            children: <Widget>[
              Expanded(
                child: imagen != null
                    ? TransitionToImage(
                        image: AdvancedNetworkImage(
                        imagen,
                          cacheRule:
                              CacheRule(maxAge: const Duration(days: 30)),
                          useDiskCache: true,
                          timeoutDuration: Duration(seconds: 15),
                          retryLimit: 2,
                        ),
                        loadingWidget: AppLoadingSkeleton(),
                        placeholder: AppLoadingSkeleton(),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.asset("lib/assets/imagenes/logo.png"),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      //height: MediaQuery.of(context).size.height / 24,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: EdgeInsets.only(left: 10, top: 5, right: 5),
                      width: double.infinity,
                      child: Text(
                        titulo!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 12,
                          fontFamily: "Gotham",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  favorito == true
                      ? Container(
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                        )
                      : Container(),
                ],
              ),
              Container(
                padding:
                    EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
                alignment: Alignment.bottomLeft,
                child: Text(
                  precio!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Color(0xFF85909D),
                      fontFamily: "Gotham",
                      fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
