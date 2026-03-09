class MaterialItem {
  int? id;
  int? listaId;
  String descricao;
  double quantidade;
  String unidade;

  MaterialItem({
    this.id,
    this.listaId,
    required this.descricao,
    required this.quantidade,
    required this.unidade,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lista_id': listaId,
      'descricao': descricao,
      'quantidade': quantidade,
      'unidade': unidade,
    };
  }

  factory MaterialItem.fromMap(Map<String, dynamic> map) {
    return MaterialItem(
      id: map['id'],
      listaId: map['lista_id'],
      descricao: map['descricao'],
      quantidade: map['quantidade'],
      unidade: map['unidade'],
    );
  }
}
