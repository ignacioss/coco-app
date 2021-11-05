import 'package:flutter/material.dart';

class CustomAppBarNegocio extends StatefulWidget
    implements PreferredSizeWidget {
  @override
  final Size preferredSize = Size.fromHeight(110);

  CustomAppBarNegocio();

  @override
  _CustomAppBarNegocioState createState() => _CustomAppBarNegocioState();
}

class _CustomAppBarNegocioState extends State<CustomAppBarNegocio> {


  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Material(
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
                Expanded(
                  child: Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(left: 20),
                    child: RawMaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      constraints: BoxConstraints.tightFor(
                        width: 50,
                        height: 50,
                      ),
                      fillColor: Colors.black.withOpacity(0.5),
                      elevation: 0,
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.only(right: 20),
                    child: RawMaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      constraints: BoxConstraints.tightFor(
                        width: 50,
                        height: 50,
                      ),
                      fillColor: Colors.black.withOpacity(0.5),
                      elevation: 0,
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
