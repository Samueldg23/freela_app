enum TipoUsuario { CLIENTE, PRESTADOR }

class Usuario {
  final int id;
  final String nome;
  final String email;
  final String telefone;
  final String fotoPerfil;
  final String cpf;
  final String senha;
  final String endereco;
  final TipoUsuario tipoUsuario;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.fotoPerfil,
    required this.cpf,
    required this.senha,
    required this.endereco,
    required this.tipoUsuario,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      telefone: json['telefone'],
      fotoPerfil: json['fotoPerfil'],
      cpf: json['cpf'],
      senha: json['senha'],
      endereco: json['endereco'],
      tipoUsuario: TipoUsuario.values.byName(json['tipoUsuario']),
    );
  }
  factory Usuario.vazio({
    int id = 0,
    TipoUsuario tipoUsuario = TipoUsuario.CLIENTE,
  }) {
    return Usuario(
      id: id,
      nome: '',
      email: '',
      telefone: '',
      fotoPerfil: '',
      cpf: '',
      senha: '',
      endereco: '',
      tipoUsuario: tipoUsuario,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'fotoPerfil': fotoPerfil,
      'cpf': cpf,
      'senha': senha,
      'endereco': endereco,
      'tipoUsuario': tipoUsuario.name,
    };
  }

  Map<String, dynamic> toMapForDb() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
      'telefone': telefone,
      'fotoPerfil': fotoPerfil,
      'cpf': cpf,
      'endereco': endereco,
      'tipoUsuario': tipoUsuario.name,
    };
  }

  factory Usuario.fromDbMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'] as int,
      nome: map['nome'] as String,
      email: map['email'] as String,
      senha: map['senha'] as String,
      telefone: map['telefone'] as String,
      fotoPerfil: map['fotoPerfil'] as String,
      cpf: map['cpf'] as String,
      endereco: map['endereco'] as String,
      tipoUsuario: TipoUsuario.values.byName(map['tipoUsuario'] as String),
    );
  }
}
