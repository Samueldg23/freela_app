import 'pedido.dart';

class Avaliacao {
  final int id;
  final String comentario;
  final int nota;
  final Pedido? pedido;
  final DateTime dataAvaliacao;

  Avaliacao({
    required this.id,
    required this.comentario,
    required this.nota,
    this.pedido,
    required this.dataAvaliacao,
  });

  factory Avaliacao.fromJson(Map<String, dynamic> json) {
    return Avaliacao(
      id: json['id'],
      comentario: json['comentario'],
      nota: json['nota'],
      dataAvaliacao: DateTime.parse(json['dataAvaliacao']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'comentario': comentario,
      'nota': nota,
      'dataAvaliacao': dataAvaliacao.toIso8601String(),
    };
  }

  factory Avaliacao.fromDbMap(Map<String, dynamic> map) {
    return Avaliacao(
      id: map['id'],
      comentario: map['comentario'],
      nota: map['nota'],
      dataAvaliacao: DateTime.parse(map['dataAvaliacao']),
      pedido: null, 
    );
  }

  Map<String, dynamic> toMapForDb() {
    return {
      'id': id,
      'comentario': comentario,
      'nota': nota,
      'dataAvaliacao': dataAvaliacao.toIso8601String(),
      'pedidoId': pedido?.id,
    };
  }
}
