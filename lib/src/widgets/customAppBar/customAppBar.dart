import 'package:flutter/material.dart';
import 'package:coco_app/src/utils/app_navigator.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? titulo;
  final Widget? prepend;
  final Widget? append;
  final bool? volverVisible;
  final Function onVolver;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  final Size preferredSize = Size.fromHeight(110);

  CustomAppBar({
    this.titulo = "",
    this.prepend,
    this.append,
    this.volverVisible = true,
    this.scaffoldKey,
    required this.onVolver,
  });

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {


  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: AppBarShape(),
      child: Material(
        color: Colors.transparent,
        child: SafeArea(
          top: true,
          child: Container(
            margin: EdgeInsets.only(
              left: 5,
              right: 5,
            ),
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: 15),
              height: 60,
              child: Row(
                children: <Widget>[
                  widget.volverVisible!
                      ? Container(
                          margin: EdgeInsets.only(right: 10),
                          child: BackButton(
                            color: Colors.white,
                            onPressed: () {
                              if (widget.onVolver != null) {
                                widget.onVolver();
                              } else {
                                Navigator.pop(context);
                              }
                            },
                          ),
                        )
                      : Container(
                          margin: EdgeInsets.only(right: 20),
                          child: IconButton(
                            icon: Icon(
                              Icons.menu,
                              color: Colors.white,
                              size: 26,
                            ),
                            onPressed: () {
                              widget.scaffoldKey!.currentState!.openDrawer();
                            },
                          ),
                        ),
                  widget.prepend != null
                      ? Container(
                          margin: EdgeInsets.only(right: 10),
                          child: widget.prepend,
                        )
                      : Container(),
                  Expanded(
                    child: Text(
                      widget.titulo!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  widget.append != null
                      ? Container(
                          margin: EdgeInsets.only(left: 10),
                          child: widget.append,
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AppBarShape extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.style = PaintingStyle.fill;

    final Gradient gradient = new LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [
        Color(0xFF911f6a),
        Color(0xFFe43537),
      ],
    );
    Rect rect = new Rect.fromPoints(
      new Offset(0.0, 0),
      new Offset(size.width, size.height),
    );

    paint.shader = gradient.createShader(rect);

    var path = Path();

    path.moveTo(0, 0);
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
      0,
      size.height - 20,
      30,
      size.height - 20,
    );
    path.lineTo(size.width - 30, size.height - 20);
    path.quadraticBezierTo(
      size.width,
      size.height - 20,
      size.width,
      size.height,
    );
    path.lineTo(size.width, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
