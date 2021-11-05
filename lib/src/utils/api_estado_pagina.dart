class ApiEstadoPagina {
  int? _pagTotal;
  int? _pagActual;
  int? _pagTotalItems;

  List? _datos;

  ApiEstadoPagina(result) {
    _pagTotal = result['datos']['pagTotal'];
    _pagActual = result['datos']['pagActual'];
    _pagTotalItems = result['datos']['pagTotalItems'];
  }

  int? get pagTotal => _pagTotal;
  int? get pagActual => _pagActual;
  int? get pagTotalItems => _pagTotalItems;
  List? get datos => _datos;
}
