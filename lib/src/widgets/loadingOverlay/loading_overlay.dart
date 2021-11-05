import 'package:flutter/material.dart';

class LoadingOverlay extends StatefulWidget {
  final Widget child;

  LoadingOverlay({required this.child});

  _LoadingOverlayState createState() => _LoadingOverlayState();

  static _LoadingOverlayState? of(BuildContext context, {bool nullOk = false}) {
    assert(nullOk != null);
    assert(context != null);
    final _LoadingOverlayState? result =
        context.findAncestorStateOfType<_LoadingOverlayState>();
    if (nullOk || result != null) return result;
    throw FlutterError(
        'LoadingOverlay.of() called with a context that does not contain a LoadingOverlay.\n'
        '  $context');
  }
}

class _LoadingOverlayState extends State<LoadingOverlay> {
  bool isLoading = false;

  void setIsLoading(bool val) {
    setState(() {
      isLoading = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isLoading) {
          return false;
        }

        return true;
      },
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          widget.child,
          Visibility(
            visible: isLoading,
            child: Container(
              color: Colors.black38,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
