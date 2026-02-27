class OrcamentoModel {
  final int? id;
  final String numero;
  final String cliente;
  final String data;
  final double total;
  final double desconto;

  OrcamentoModel({
    this.id,
    required this.numero,
    required this.cliente,
    required this.data,
    required this.total,
    required this.desconto,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'numero': numero,
      'cliente': cliente,
      'data': data,
      'total': total,
      'desconto': desconto,
    };
  }

  factory OrcamentoModel.fromMap(Map<String, dynamic> map) {
    return OrcamentoModel(
      id: map['id'],
      numero: map['numero'],
      cliente: map['cliente'],
      data: map['data'],
      total: map['total'],
      desconto: map['desconto'],
    );
  }
}
