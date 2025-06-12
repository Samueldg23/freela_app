import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/usuario.dart';
import '../models/servico.dart';
import '../models/pedido.dart';
import '../models/avaliacao.dart';

class ApiService {
static const String _baseUrl = 'https://freela-api-29fi.onrender.com';

Future<String?> _getToken() async {
final prefs = await SharedPreferences.getInstance();
return prefs.getString('jwt');
}

Future<int?> _getStoredUserId() async {
final prefs = await SharedPreferences.getInstance();
return prefs.getInt('userId');
}

Future<Map<String, String>> _getHeaders() async {
final token = await _getToken();
return {
'Content-Type': 'application/json',
if (token != null) 'Authorization': 'Bearer $token',
};
}

Future<T> _get<T>(String path, T Function(dynamic) fromJson) async {
final resp = await http.get(
Uri.parse('$_baseUrl$path'),
headers: await _getHeaders(),
);
if (resp.statusCode == 200) {
return fromJson(jsonDecode(resp.body));
}
throw Exception('GET $path falhou: ${resp.statusCode}');
}

Future<List<T>> _getList<T>(String path, T Function(dynamic) fromJson) async {
final resp = await http.get(
Uri.parse('$_baseUrl$path'),
headers: await _getHeaders(),
);
if (resp.statusCode == 200) {
final List jsonList = jsonDecode(resp.body);
return jsonList.map((e) => fromJson(e)).toList();
}
throw Exception('GET $path falhou: ${resp.statusCode}');
}

Future<List<Usuario>> getUsuarios() =>
_getList('/usuarios', (e) => Usuario.fromJson(e));

Future<Usuario> getUsuarioPorId(int id) =>
_get('/usuarios/$id', (e) => Usuario.fromJson(e));

Future<List<Servico>> getServicos() =>
_getList('/servicos', (e) => Servico.fromJson(e));

Future<Servico> getServicoPorId(int id) =>
_get('/servicos/$id', (e) => Servico.fromJson(e));

Future<List<Servico>> getServicosPorCategoria(String categoria) =>
_getList('/servicos/categoria/$categoria', (e) => Servico.fromJson(e));

Future<List<Servico>> getServicosPorPrestador(int idPrestador) =>
_getList('/servicos/prestador/$idPrestador', (e) => Servico.fromJson(e));

Future<List<Servico>> buscarServicos(String termo) =>
_getList('/servicos/buscar?nome=$termo', (e) => Servico.fromJson(e));

Future<List<Pedido>> getPedidosCliente() async {
final id = await _getStoredUserId();
if (id == null) throw Exception('Usuário não autenticado');
return _getList('/pedidos/cliente/$id', (e) => Pedido.fromJson(e));
}

Future<List<Pedido>> getPedidosPrestador() async {
final id = await _getStoredUserId();
if (id == null) throw Exception('Usuário não autenticado');
return _getList('/pedidos/prestador/$id', (e) => Pedido.fromJson(e));
}

Future<Pedido> getPedidoPorId(int id) =>
_get('/pedidos/$id', (e) => Pedido.fromJson(e));

Future<List<Pedido>> getTodosPedidos() =>
_getList('/pedidos', (e) => Pedido.fromJson(e));

Future<List<Avaliacao>> getAvaliacoesPrestador(int idPrestador) =>
_getList('/avaliacoes/prestador/$idPrestador', (e) => Avaliacao.fromJson(e));

Future<Avaliacao> getAvaliacaoPorId(int id) =>
_get('/avaliacoes/$id', (e) => Avaliacao.fromJson(e));

Future<List<Avaliacao>> getAvaliacoesPorPedido(int idPedido) =>
_getList('/avaliacoes/pedido/$idPedido', (e) => Avaliacao.fromJson(e));

Future<List<Avaliacao>> getAvaliacoesPorNota(int nota) =>
_getList('/avaliacoes/nota/$nota', (e) => Avaliacao.fromJson(e));

Future<Usuario> login(String email, String senha) async {
  final url = Uri.parse(
    '$_baseUrl/usuarios/login?email=$email&senha=$senha'
  );
  final resp = await http.get(url);
  if (resp.statusCode != 200) {
    throw Exception('Email ou senha inválidos');
  }
  final Map<String, dynamic> json = jsonDecode(resp.body);
  return Usuario.fromJson(json);
}

}