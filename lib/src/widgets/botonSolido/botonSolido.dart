import 'package:flutter/material.dart';

class BotonSolido extends StatelessWidget {
  final Function onPressed;
  final Widget? child;
  final Color? color;
  final Widget? prepend;
  final Widget? append;
  final EdgeInsets? padding;

  const BotonSolido({
    required this.onPressed,
    this.padding,
    this.child,
    this.color = Colors.black,
    this.prepend,
    this.append,
  });

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      padding: padding ?? EdgeInsets.all(15),
      fillColor: color,
      onPressed: onPressed(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      child: Container(
        child: Row(
          children: <Widget>[
            prepend ?? Container(),
            Expanded(
              child: child!,
            ),
            append ?? Container(),
          ],
        ),
      ),
    );
  }
}
