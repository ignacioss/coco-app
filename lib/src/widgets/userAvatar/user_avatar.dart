import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:coco_app/src/app/api_consts.dart';

class UserAvatar extends StatefulWidget {
  final double height;
  final double width;
  final String? imagenUrl;

  UserAvatar({
    this.height = 50,
    this.width = 50,
    this.imagenUrl,
  });

  @override
  _UserAvatarState createState() => new _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  late String primeraUrl; // por si se actualiza
  bool cargandoNuevaImagen = false;
  bool isDisposed = false;

  @override
  void initState() {
    super.initState();

    primeraUrl = widget.imagenUrl!;
  }

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: widget.height,
          width: widget.width,
          child: ClipOval(
            child: Container(
              color: Colors.grey,
              child: (widget.imagenUrl != null &&
                      widget.imagenUrl != "" &&
                      widget.imagenUrl != "$APIURL/" &&
                      widget.imagenUrl != "$APIURL:8000/")
                  ? TransitionToImage(
                      image: AdvancedNetworkImage(
                        widget.imagenUrl,
                        fallbackAssetImage: 'lib/assets/imagenes/isotipo.png',
                        cacheRule: CacheRule(maxAge: const Duration(days: 7)),
                        useDiskCache: true,
                        timeoutDuration: Duration(seconds: 5),
                        retryLimit: 2,
                      ),
                      placeholder: CircularProgressIndicator(),
                      fit: BoxFit.cover,
                    )
                  : Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
