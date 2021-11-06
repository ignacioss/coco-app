import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryIcon extends StatelessWidget {
  final String? nombre;
  final int? id;
  final String? imagen;
  final bool? selected;
  final Function onUsarEmisora;


  const CategoryIcon({this.nombre, this.id, this.imagen,this.selected,required this.onUsarEmisora});

  @override
  Widget build(BuildContext context) {
    dynamic colorGrisOscuro = 0xffDEDEDE;
    dynamic colorGrisClaro = 0xff1C1C1C;
    dynamic colorGrisTitulos = 0xffC6C6CA;
    bool activo = false;


    return GestureDetector(
      onTap: () {
        onUsarEmisora();
        colorGrisClaro =0xff39FC7A;

      },
      child: Container(
        margin: EdgeInsets.all(5),
        width:30,
        height: 30,
        decoration: BoxDecoration(
            border: Border.all(color: selected! ? Colors.green:Colors.transparent,width: 3),
          image: DecorationImage(image: NetworkImage(imagen!),
              fit: BoxFit.cover),
          color: Color(colorGrisClaro),
         // borderRadius: BorderRadius.circular(5),
          boxShadow: [ activo
              ? BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ): BoxShadow(
          )
          ],
        ),
      ),
    );
  }
}
