import 'package:flutter/material.dart';

class BotonBorde extends StatelessWidget {
  final Function onPressed;
  final Widget? child;
  final Color? color;
  final Widget? prepend;
  final Widget? append;

  const BotonBorde({
    required this.onPressed,
    this.child,
    this.color = Colors.white,
    this.prepend,
    this.append,
  });

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed(),
      padding: EdgeInsets.all(15),
      fillColor: Colors.transparent,
      elevation: 0,
      disabledElevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      hoverElevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
        side: BorderSide(color: color!, width: 1),
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
