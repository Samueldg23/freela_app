import 'servico.dart';
import 'usuario.dart';
import 'avaliacao.dart';

enum Status { PENDENTE, ACEITO, EM_ANDAMENTO, FINALIZADO, REJEITADO, CANCELADO }

class Pedido {
  final int id;
  final Servico servico;
  final Usuario cliente;
  final Usuario prestador;
  final Status status;
  final DateTime dataPedido;
  final DateTime? dataConclusao;
  final Avaliacao? avaliacao;

  Pedido({
    required this.id,
    required this.servico,
    required this.cliente,
    required this.prestador,
    required this.status,
    required this.dataPedido,
    this.dataConclusao,
    this.avaliacao,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id'],
      servico: Servico.fromJson(json['servico']),
      cliente: Usuario.fromJson(json['cliente']),
      prestador: Usuario.fromJson(json['prestador']),
      status: Status.values.byName(json['status']),
      dataPedido: DateTime.parse(json['dataPedido']),
      dataConclusao:
          json['dataConclusao'] != null
              ? DateTime.parse(json['dataConclusao'])
              : null,
      avaliacao:
          json['avaliacao'] != null
              ? Avaliacao.fromJson(json['avaliacao'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'servico': servico.toJson(),
      'cliente': cliente.toJson(),
      'prestador': prestador.toJson(),
      'status': status.name,
      'dataPedido': dataPedido.toIso8601String(),
      'dataConclusao': dataConclusao?.toIso8601String(),
      'avaliacao': avaliacao?.toJson(),
    };
  }

  factory Pedido.fromDbMap(Map<String, dynamic> map) {
    return Pedido(
      id: map['id'],
      servico: Servico(
        id: map['servicoId'],
        nome: '',
        descricao: '',
        categoria: Categoria.ELETRICISTA,
        valor: 0.0,
        prestador: Usuario.vazio(),
      ),
      cliente: Usuario.vazio(
        id: map['clienteId'],
        tipoUsuario: TipoUsuario.CLIENTE,
      ),
      prestador: Usuario.vazio(
        id: map['prestadorId'],
        tipoUsuario: TipoUsuario.PRESTADOR,
      ),
      status: Status.values.byName(map['status']),
      dataPedido: DateTime.parse(map['dataPedido']),
      dataConclusao:
          map['dataConclusao'] != null
              ? DateTime.parse(map['dataConclusao'])
              : null,
      avaliacao: null,
    );
  }

  Map<String, dynamic> toMapForDb() {
    return {
      'id': id,
      'servicoId': servico.id,
      'clienteId': cliente.id,
      'prestadorId': prestador.id,
      'status': status.name,
      'dataPedido': dataPedido.toIso8601String(),
      'dataConclusao': dataConclusao?.toIso8601String(),
    };
  }
}
