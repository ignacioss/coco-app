class ApiEstadoPeticion {
  late int _estado;
  late String _mensaje;
  late dynamic _excepcion;

  ApiEstadoPeticion(result) {
    if (result['estado'].runtimeType.toString() == "String") {
      _estado = int.parse(result['estado']);
    } else {
      _estado = result['estado'];
    }
    _mensaje = result['mensaje'];
    _excepcion = result['excepcion'];
  }

  int get estado => _estado;

  String get mensaje => _mensaje;

  dynamic get excepcion => _excepcion;
}
