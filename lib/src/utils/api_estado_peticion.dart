class ApiEstadoPeticion {
  int? _estado;
  String? _mensaje;
  dynamic _excepcion;

  ApiEstadoPeticion(result) {
    _estado = result['estado'];
    _mensaje = result['mensaje'];
    _excepcion = result['excepcion'];
  }

  int? get estado => _estado;
  String? get mensaje => _mensaje;
  dynamic get excepcion => _excepcion;
}
