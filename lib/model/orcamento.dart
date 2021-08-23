class Orcamento {
  final int? id;
  final String? name;
  final String? detail;
  final String? image;

  Orcamento({this.id, this.name, this.detail, this.image});

  factory Orcamento.fromJson(Map<String, dynamic> json) {
    return Orcamento(
      id: json['id'],
      name: json['name'],
      detail: json['detail'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'detail': detail,
    'image': image,
  };
}