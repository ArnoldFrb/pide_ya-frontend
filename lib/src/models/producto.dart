class Producto {
  final String producoKey;
  final String detalle;
  final String pid;
  final String producto;

  Producto({
    this.producoKey,
    this.detalle,
    this.pid,
    this.producto,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      producoKey: json['producoKey'],
      producto: json['producto'],
      detalle: json['detalle'],
      pid: json['pid']
    );
  }
}
