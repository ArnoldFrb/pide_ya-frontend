class Direction {
  final String directionKey;
  final String name;
  final String direction;
  final String estado;
  final String userkey;

  Direction({
    this.directionKey,
    this.name,
    this.direction,
    this.estado,
    this.userkey,
  });

  factory Direction.fromJson(Map<String, dynamic> json) {
    return Direction(
      directionKey: json['directionKey'],
      name: json['name'],
      direction: json['direction'],
      estado: json['estado'],
      userkey: json['userkey'],
    );
  }
}
