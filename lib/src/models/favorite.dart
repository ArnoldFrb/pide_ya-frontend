class Favorite {
  final String favoritekey;
  final String clientekey;
  final String tiendakey;

  Favorite({
    this.favoritekey,
    this.clientekey,
    this.tiendakey,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      favoritekey: json['favoritekey'],
      clientekey: json['clientekey'],
      tiendakey: json['tiendakey'],
    );
  }
}
