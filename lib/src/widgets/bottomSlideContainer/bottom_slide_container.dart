import 'package:flutter/material.dart';
import 'package:coco_app/src/utils/app_icons.dart';

const int CHILD_STATE_TOP = 1;
const int CHILD_STATE_BOTTOM = 0;

class BottomSlideContainer extends StatefulWidget {
  final Widget child;
  final double containerHeight;
  final EdgeInsets padding;

  BottomSlideContainer({
    required this.child,
    this.containerHeight = 200,
    this.padding = const EdgeInsets.all(0),
  });

  @override
  _BottomSlideContainerState createState() => new _BottomSlideContainerState();
}

class _BottomSlideContainerState extends State<BottomSlideContainer>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  double _childPosition = 0;
  int _childState = CHILD_STATE_BOTTOM;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    Tween<double> movimiento =
        Tween<double>(begin: 0, end: widget.containerHeight);

    _animation = movimiento.animate(
      _animationController,
    );

    _animation.addListener(() {
      _childPosition = _animation.value;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double calcularPosicionFlecha() {
    // si esta animando, devolver el valor de la animacion
    // si no esta animando, es porque se esta arrastrando, devolver el valor
    // de posicion
    if (_animationController.isAnimating) {
      return _animation.value;
    }

    return _childPosition;
  }

  double calcularPosicionChild() {
    // si esta animando, devolver el valor de la animacion
    // si no esta animando, es porque se esta arrastrando, devolver el valor
    // de posicion
    if (_animationController.isAnimating) {
      return -widget.containerHeight + _animation.value;
    }

    return -widget.containerHeight + _childPosition;
  }

  void animateFromTap() {
    if (_childPosition != widget.containerHeight) {
      _animationController.forward();
      _childState = CHILD_STATE_TOP;
    } else {
      _animationController.reverse();
      _childState = CHILD_STATE_BOTTOM;
    }
  }

  void animateFromDragEnd({required double positionInLogicalPixels}) {
    // Función para sacar la posicion del componente *en la animacion*
    // como es una función lineal, se saca dividiendo.
    // Si fuera una curva, aquí se pondría F(x)
    // donde X es positionInLogicalPixels y F(x) va entre 0 y 1.
    double dragRelativePosition =
        positionInLogicalPixels / widget.containerHeight;

    if (_animationController.isAnimating) {
      return;
    }

    if (_childState == CHILD_STATE_BOTTOM) {
      if (dragRelativePosition > 0.2) {
        _animationController.forward(from: dragRelativePosition);
        _childState = CHILD_STATE_TOP;
      } else {
        _animationController.reverse(from: dragRelativePosition);
        _childState = CHILD_STATE_BOTTOM;
      }
    } else {
      if (dragRelativePosition > 0.8) {
        _animationController.forward(from: dragRelativePosition);
        _childState = CHILD_STATE_TOP;
      } else {
        _animationController.reverse(from: dragRelativePosition);
        _childState = CHILD_STATE_BOTTOM;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_childState == CHILD_STATE_TOP) {
          _animationController.reverse();
          _childState = CHILD_STATE_BOTTOM;
          return false;
        } else {
          return true;
        }
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Stack(
            children: <Widget>[
              // 1: Boton de "flecha" superior para animar al tocar
              Positioned(
                bottom: calcularPosicionFlecha(),
                left: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    animateFromTap();
                  },
                  onVerticalDragUpdate: (details) {
                    // si se hace drag para arriba, la aceleracion es negativa
                    // invertir para manejar mas facilmente el alto del contenedor
                    final double velocidad = (details.primaryDelta! * -1);

                    // no arrastrar si se esta reproduciendo una animacion
                    if (_animationController.isAnimating) {
                      return;
                    }

                    // Limitar el movimiento del drag a los limites superior
                    // e inferior
                    if (_childPosition + velocidad > 0 &&
                        _childPosition + velocidad < widget.containerHeight) {
                      setState(() {
                        _childPosition = _childPosition + velocidad;
                      });
                    }
                  },
                  onVerticalDragEnd: (details) {
                    animateFromDragEnd(
                      positionInLogicalPixels: _childPosition,
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.only(bottom: 30),
                    child: Icon(
                      _childState == CHILD_STATE_TOP
                          ? AppIcons.angle_down
                          : AppIcons.angle_up,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ),
              ),
              // 2: contenido principal
              Positioned(
                bottom: calcularPosicionChild(),
                left: 0,
                right: 0,
                child: Container(
                  height: widget.containerHeight,
                  width: double.infinity,
                  padding: widget.padding,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: FractionalOffset.bottomCenter,
                          end: FractionalOffset.topCenter,
                          colors: [Colors.black, Colors.transparent])),
                  child: widget.child,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
