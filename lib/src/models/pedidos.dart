class Pedidos {
  final String sid;
  final String fecha;
  final String costo;
  final String estado;
  final String detalle;
  final String cid;
  final String pid;

  Pedidos({
    this.sid,
    this.fecha,
    this.costo,
    this.estado,
    this.detalle,
    this.cid,
    this.pid,

  });

  factory Pedidos.fromJson(Map<String, dynamic> json) {
    return Pedidos(
      sid: json['sid'],
      fecha: json['fecha'],
      costo: json['costo'],
      estado: json['estado'],
      detalle: json['detalle'],
      cid: json['cid'],
      pid: json['pid'],
    );
  }
}
