import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../models/usuario.dart';
import '../models/pedido.dart';
import 'login.dart';

class PerfilPrestadorScreen extends StatefulWidget {
  final int userId;
  const PerfilPrestadorScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<PerfilPrestadorScreen> createState() => _PerfilPrestadorScreenState();
}

class _PerfilPrestadorScreenState extends State<PerfilPrestadorScreen> {
  final ApiService _api = ApiService();

  bool _loading = true;
  Usuario? _prestador;
  List<Pedido> _servicosRealizados = [];
  String? _error;
  Set<int> _expandedPedidos = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final prestador = await _api.getUsuarioPorId(widget.userId);
      final servicos = await _api.getPedidosPrestador();
      setState(() {
        _prestador = prestador;
        _servicosRealizados = servicos;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Erro ao carregar dados.';
        _loading = false;
      });
    }
  }

  String _tempoRestante(DateTime data) {
    final agora = DateTime.now();
    final diferenca = data.difference(agora);
    if (diferenca.isNegative) return 'Prazo encerrado';
    final dias = diferenca.inDays;
    final horas = diferenca.inHours % 24;
    return '$dias dias e $horas horas restantes';
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null || _prestador == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Perfil Prestador'),
          backgroundColor: const Color(0xFF004D40),
        ),
        body: Center(
          child: Text(
            _error ?? 'Usuário não encontrado.',
            style: const TextStyle(color: Colors.redAccent),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1E2A30),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(165.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF004D40), Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 50.0,
                left: 20.0,
                right: 20.0,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: _prestador!.fotoPerfil.isNotEmpty
                        ? NetworkImage(_prestador!.fotoPerfil)
                        : const AssetImage('assets/Logo.jpeg') as ImageProvider,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _prestador!.nome,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text('E-mail: ${_prestador!.email}', style: const TextStyle(color: Colors.white70)),
                        Text('Telefone: ${_prestador!.telefone}', style: const TextStyle(color: Colors.white70)),
                        Text('CPF: ${_prestador!.cpf}', style: const TextStyle(color: Colors.white70)),
                        Text('Endereço: ${_prestador!.endereco}', style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: const Color(0xFFB6E388), width: 1.5),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Meus Serviços',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  if (_servicosRealizados.isEmpty)
                    const Text('Nenhum serviço encontrado.')
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _servicosRealizados.length,
                      itemBuilder: (context, index) {
                        final pedido = _servicosRealizados[index];
                        final isExpanded = _expandedPedidos.contains(pedido.id);
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: const BorderSide(color: Color(0xFFB6E388), width: 1.5),
                          ),
                          child: ExpansionTile(
                            title: Text(pedido.servico.nome),
                            subtitle: Text('Status: ${pedido.status.name}'),
                            trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                            initiallyExpanded: isExpanded,
                            onExpansionChanged: (expanded) {
                              setState(() {
                                if (expanded) {
                                  _expandedPedidos.add(pedido.id);
                                } else {
                                  _expandedPedidos.remove(pedido.id);
                                }
                              });
                            },
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Descrição: ${pedido.servico.descricao}'),
                                    const SizedBox(height: 6),
                                    Text('Valor: R\$ ${pedido.servico.valor.toStringAsFixed(2)}'),
                                    const SizedBox(height: 6),
                                    Text('Tempo restante: ${_tempoRestante(pedido.dataPedido)}'),
                                    const SizedBox(height: 6),
                                    Text('Solicitado em: ${DateFormat('dd/MM/yyyy – HH:mm').format(pedido.dataPedido)}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text('Sair'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF004D40),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
