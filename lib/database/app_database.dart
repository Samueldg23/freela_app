import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../models/usuario.dart';
import '../models/servico.dart';
import '../models/pedido.dart';
import '../models/avaliacao.dart';

class BancoDadosApp {
  static final BancoDadosApp _instancia = BancoDadosApp._interno();
  factory BancoDadosApp() => _instancia;
  BancoDadosApp._interno();

  static Database? _banco;

  Future<Database> get banco async {
    if (_banco != null) return _banco!;
    _banco = await _inicializarBanco();
    return _banco!;
  }

  Future<Database> _inicializarBanco() async {
    Directory diretorio = await getApplicationDocumentsDirectory();
    String caminho = join(diretorio.path, 'freela_app.db');
    return await openDatabase(
      caminho,
      version: 1,
      onCreate: _aoCriar,
    );
  }

  Future<void> _aoCriar(Database db, int versao) async {
    await db.execute('''
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY,
        nome TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        telefone TEXT,
        fotoPerfil TEXT,
        cpf TEXT,
        senha TEXT NOT NULL,
        endereco TEXT,
        tipoUsuario TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE servicos (
        id INTEGER PRIMARY KEY,
        nome TEXT NOT NULL,
        descricao TEXT,
        categoria TEXT NOT NULL,
        valor REAL NOT NULL,
        prestadorId INTEGER NOT NULL,
        FOREIGN KEY (prestadorId) REFERENCES usuarios (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE pedidos (
        id INTEGER PRIMARY KEY,
        servicoId INTEGER NOT NULL,
        clienteId INTEGER NOT NULL,
        prestadorId INTEGER NOT NULL,
        status TEXT NOT NULL,
        dataPedido TEXT NOT NULL,
        dataConclusao TEXT,
        FOREIGN KEY (servicoId) REFERENCES servicos (id),
        FOREIGN KEY (clienteId) REFERENCES usuarios (id),
        FOREIGN KEY (prestadorId) REFERENCES usuarios (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE avaliacoes (
        id INTEGER PRIMARY KEY,
        comentario TEXT,
        nota INTEGER NOT NULL,
        dataAvaliacao TEXT NOT NULL,
        pedidoId INTEGER UNIQUE,
        FOREIGN KEY (pedidoId) REFERENCES pedidos (id) ON DELETE CASCADE
      )
    ''');
  }

  // ================= USUÁRIO =================

  Future<int> salvarUsuario(Usuario usuario) async {
    final db = await banco;
    return await db.insert(
      'usuarios',
      usuario.toMapForDb(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Usuario?> buscarUsuarioPorId(int id) async {
    final db = await banco;
    final resultado = await db.query(
      'usuarios',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (resultado.isNotEmpty) {
      return Usuario.fromDbMap(resultado.first);
    }
    return null;
  }

  Future<List<Usuario>> listarUsuarios() async {
    final db = await banco;
    final resultado = await db.query('usuarios');
    return resultado.map((mapa) => Usuario.fromDbMap(mapa)).toList();
  }

  // ================= SERVIÇO =================

  Future<int> salvarServico(Servico servico) async {
    final db = await banco;
    return await db.insert(
      'servicos',
      servico.toMapForDb(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Servico>> listarServicos() async {
    final db = await banco;
    final resultado = await db.query('servicos');
    return resultado.map((mapa) => Servico.fromDbMap(mapa)).toList();
  }

  // ================= PEDIDO =================

  Future<int> salvarPedido(Pedido pedido) async {
    final db = await banco;
    return await db.insert(
      'pedidos',
      pedido.toMapForDb(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Pedido>> listarPedidos() async {
    final db = await banco;
    final resultado = await db.query('pedidos');
    return resultado.map((mapa) => Pedido.fromDbMap(mapa)).toList();
  }

  // ================= AVALIAÇÃO =================

  Future<int> salvarAvaliacao(Avaliacao avaliacao) async {
    final db = await banco;
    return await db.insert(
      'avaliacoes',
      avaliacao.toMapForDb(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Avaliacao>> listarAvaliacoes() async {
    final db = await banco;
    final resultado = await db.query('avaliacoes');
    return resultado.map((mapa) => Avaliacao.fromDbMap(mapa)).toList();
  }

  // ================= GERAL =================

  Future<void> limparTudo() async {
    final db = await banco;
    await db.delete('avaliacoes');
    await db.delete('pedidos');
    await db.delete('servicos');
    await db.delete('usuarios');
  }
}
