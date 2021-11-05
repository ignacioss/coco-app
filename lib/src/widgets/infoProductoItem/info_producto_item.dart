import 'package:flutter/material.dart';

class InfoItem extends StatelessWidget {
  final Function onPressed;
  final String titulo;
  final String texto;

  const InfoItem({Key? key, this.texto = "", this.titulo = "",required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            titulo,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).accentColor,
            ),
          ),
          Container(
            height: 10,
          ),
          Text(texto),
        ],
      ),
    );
  }
}
