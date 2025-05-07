class ServingUnit {
  final String id;
  final String unitName;
  final String unitSymbol;

  ServingUnit({
    required this.id,
    required this.unitName,
    required this.unitSymbol,
  });

  factory ServingUnit.fromJson(Map<String, dynamic> json) {
    return ServingUnit(
      id: json['id'],
      unitName: json['unitName'],
      unitSymbol: json['unitSymbol'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'unitName': unitName,
      'unitSymbol': unitSymbol,
    };
  }
}
