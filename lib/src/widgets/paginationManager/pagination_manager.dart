import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PaginationManager {
  final ScrollController? scrollController;
  final Stream? stream;
  final List? blocData;
  final Function(int)? onLoadPage;

  int currentPage = 1;
  late Function scrollListener;
  bool isLoadingPage = false;
  late StreamSubscription blocStreamSub;

  PaginationManager({
     this.scrollController,
     this.stream,
     this.blocData,
     this.onLoadPage,
  }) {
    scrollListener = () {
      var posicionMaxima = scrollController!.position.maxScrollExtent;
      var posicionActual = scrollController!.offset;
      var posicionOutOfRange = scrollController!.position.outOfRange;
      var direccion = scrollController!.position.userScrollDirection;

      if (posicionActual > posicionMaxima - 50 &&
          !posicionOutOfRange &&
          direccion == ScrollDirection.reverse) {
        isLoadingPage = true;
        onLoadPage!(currentPage + 1);
      }
    };

    blocStreamSub = stream!.listen((data) {
      try {
        // Solo procesar si este componente es el que mando la solicitud
        if (data.estadoPeticion.estado == 1 && isLoadingPage) {
          isLoadingPage = false;

          List datos = data.datos;
          bool nuevasFilasAgregadas = false;

          for (dynamic filaNueva in datos) {
            bool existe = false;

            for (dynamic fila in blocData!) {
              if (fila["id"] == filaNueva["id"]) {
                existe = true;
              }
            }

            if (!existe) {
              nuevasFilasAgregadas = true;
              blocData!.add(filaNueva);
            }
          }

          if (nuevasFilasAgregadas) {
            currentPage += 1;
          }
        }
      } catch (e) {
        print(e.toString());
      }
    });

    scrollController!.addListener(scrollListener());
  }

  void dispose() {
    if (scrollController != null && scrollListener != null) {
      scrollController!.removeListener(scrollListener());
    }
    if (blocStreamSub != null) {
      blocStreamSub.cancel();
    }
  }
}
