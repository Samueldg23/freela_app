import 'usuario.dart';

enum Categoria {
  ELETRICISTA,
  ENCANADOR,
  PEDREIRO,
  PINTOR,
  MONTADOR_MOVEIS,
  TECNICO_REFRIGERACAO,
  REPAROS_ELETRONICOS,
  JARDINAGEM,
  DETETIZACAO,
  MECANICO,
  MOTORISTA,
  FUNILARIA_PINTURA,
  LAVAGEM_CARROS,
  CHAVEIRO,
  CABELEIREIRO,
  BARBEIRO,
  MANICURE_PEDICURE,
  TRANCISTA,
  MAQUIADOR,
  DESIGNER_SOBRANCELHAS,
  DEPILACAO,
  MASSAGISTA,
  PERSONAL_TRAINER,
  DIARISTA,
  COZINHEIRO,
  BABA,
  CUIDADOR_IDOSOS,
  SUPORTE_TECNICO,
  DESENVOLVIMENTO_SITES,
}

class Servico {
  final int id;
  final String nome;
  final String descricao;
  final Categoria categoria;
  final double valor;
  final Usuario prestador;

  Servico({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.categoria,
    required this.valor,
    required this.prestador,
  });

  factory Servico.fromJson(Map<String, dynamic> json) {
    return Servico(
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'],
      categoria: Categoria.values.byName(json['categoria']),
      valor: (json['valor'] as num).toDouble(),
      prestador: Usuario.fromJson(json['prestador']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'categoria': categoria.name,
      'valor': valor,
      'prestador': prestador.toJson(),
    };
  }

  factory Servico.fromDbMap(Map<String, dynamic> map) {
    return Servico(
      id: map['id'],
      nome: map['nome'],
      descricao: map['descricao'],
      categoria: Categoria.values.byName(map['categoria']),
      valor: (map['valor'] as num).toDouble(),
      prestador: Usuario.vazio(
        id: map['prestadorId'],
        tipoUsuario: TipoUsuario.PRESTADOR,
      ),
    );
  }

  Map<String, dynamic> toMapForDb() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'categoria': categoria.name,
      'valor': valor,
      'prestadorId': prestador.id,
    };
  }
}
