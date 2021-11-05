import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';

import 'package:coco_app/src/widgets/paginationManager/index.dart';

class PaginationGrid extends StatefulWidget {
  final Function(int) onGetPagina;
  final Stream stream;
  final List<dynamic> blocData;
  final Function(BuildContext, int) itemBuilder;
  final EdgeInsets padding;
  final SliverGridDelegateWithFixedCrossAxisCount gridDelegate;
  final ScrollController? scrollController;

  PaginationGrid({
    required this.stream,
    required this.onGetPagina,
    required this.blocData,
    required this.itemBuilder,
    required this.gridDelegate,
    this.scrollController,
    this.padding = EdgeInsets.zero,
  });

  @override
  _PaginationGridState createState() => _PaginationGridState();
}

class _PaginationGridState extends State<PaginationGrid> {
  // Bloc
  late ScrollController _scrollController;

  // Estados de UI
  bool isLoadingPagination = false;
  bool isLoadingRefresh = false;
  int currentPage = 1;
  late Completer<Null> cargandoRefresh;
  late StreamSubscription blocStreamOnPageLoadedSub;

  @override
  void initState() {
    super.initState();

    //Controllers
    if (widget.scrollController != null) {
      _scrollController = widget.scrollController!;
    } else {
      _scrollController = new ScrollController();
    }

    //
    _scrollController.addListener(paginationScrollListener);

    // Definir paginacion
    blocStreamOnPageLoadedSub = widget.stream.listen(onPageLoadedListener);
  }

  @override
  void dispose() {
    // listener de este widget
    if (blocStreamOnPageLoadedSub != null) {
      blocStreamOnPageLoadedSub.cancel();
    }

    // solo eliminar controlldor cuando se haya creado localmente
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int itemCount = widget.blocData.length;

    return RefreshIndicator(
      onRefresh: _onRefrescar,
      child: SingleChildScrollView(
        controller: widget.scrollController == null ? _scrollController : null,
        physics: widget.scrollController == null
            ? AlwaysScrollableScrollPhysics()
            : NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            GridView.builder(
              padding: widget.padding,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: widget.gridDelegate,
              itemBuilder: (context, position) {
                return widget.itemBuilder(context, position);
              },
              itemCount: itemCount,
            ),
            (isLoadingPagination)
                ? Container(
                    height: 60,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  Future<Null> _onRefrescar() {
    cargandoRefresh = new Completer<Null>();
    widget.onGetPagina(1);
    currentPage = 1;

    return cargandoRefresh.future;
  }

  void paginationScrollListener() {
    var posicionMaxima = _scrollController.position.maxScrollExtent;
    var posicionActual = _scrollController.offset;
    var posicionOutOfRange = _scrollController.position.outOfRange;
    var direccion = _scrollController.position.userScrollDirection;

    if (posicionActual > posicionMaxima - 50 &&
        !posicionOutOfRange &&
        direccion == ScrollDirection.reverse) {
      onLoadPage(currentPage + 1);
    }
  }

  void onLoadPage(nroPagina) {
    if (!isLoadingPagination) {
      setState(() {
        isLoadingPagination = true;
      });

      widget.onGetPagina(nroPagina);
    }
  }

  void onPageLoadedListener(data) {
    try {
      // Solo procesar si este componente es el que mando la solicitud
      if (data.estadoPeticion.estado == 1 && isLoadingPagination) {
        isLoadingPagination = false;

        List datos = data.datos;
        bool nuevasFilasAgregadas = false;

        for (dynamic filaNueva in datos) {
          bool existe = false;

          for (dynamic fila in widget.blocData) {
            if (fila["id"] == filaNueva["id"]) {
              existe = true;
            }
          }

          if (!existe) {
            nuevasFilasAgregadas = true;
            widget.blocData.add(filaNueva);
          }
        }

        if (nuevasFilasAgregadas) {
          currentPage += 1;
        }
      }
    } catch (e) {
      print(e.toString());
    }

    // Detener refresh
    if (cargandoRefresh != null && !cargandoRefresh.isCompleted) {
      cargandoRefresh.complete();
    }
  }
}
