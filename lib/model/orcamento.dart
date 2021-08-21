class Orcamento {
  final int? id;
  final String? name;
  final String? detail;

  Orcamento({this.id, this.name, this.detail});

  factory Orcamento.fromJson(Map<String, dynamic> json) {
    return Orcamento(
      id: json['id'],
      name: json['name'],
      detail: json['detail'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'detail': detail,
  };
}