import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';

import 'package:coco_app/src/widgets/paginationManager/index.dart';

class PaginationList extends StatefulWidget {
  final Function(int) onGetPagina;
  final Stream stream;
  final List<dynamic> blocData;
  final Function(BuildContext, int) itemBuilder;
  final EdgeInsets padding;
  final Widget? separator;
  final ScrollController? scrollController;

  PaginationList({
    required this.stream,
    required this.onGetPagina,
    required this.blocData,
    required this.itemBuilder,
    this.padding = EdgeInsets.zero,
    this.separator,
    this.scrollController,
  });

  @override
  _PaginationListState createState() => _PaginationListState();
}

class _PaginationListState extends State<PaginationList> {
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

    Timer(
        Duration(seconds: 0),
            () =>
            _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut),
      //lleva al final del scroll
    );

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


    if(_scrollController.hasClients){
      print(_scrollController.offset);
      var posicionActual = _scrollController.offset;
      var posicionMaxima = _scrollController.position.maxScrollExtent;
      var posicionOutOfRange = _scrollController.position.outOfRange;

      if (posicionActual > posicionMaxima - 200 &&
          !posicionOutOfRange) {

        _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut);
      }


    }

    return SingleChildScrollView(
      controller: widget.scrollController == null ? _scrollController : null,
      physics: widget.scrollController == null
          ? AlwaysScrollableScrollPhysics()
          : NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          (isLoadingPagination)
              ? Container(
            height: 60,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
              : Container(),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            reverse: false,
            padding: widget.padding,
            itemBuilder: (context, position) {

              return widget.itemBuilder(context, position);
            },
            separatorBuilder: (context, position) {
              if (widget.separator != null) {
                return widget.separator!;
              } else {
                return Container();
              }
            },
            itemCount: itemCount,
          ),
        ],
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

    if (posicionActual < 50 && !posicionOutOfRange) {

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
