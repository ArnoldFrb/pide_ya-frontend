class Pedido {
  final String pid;

  Pedido({
    this.pid,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      pid: json['pid']
    );
  }
}
