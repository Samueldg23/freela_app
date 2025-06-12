import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../models/usuario.dart';
import '../models/pedido.dart';
import 'login.dart';

class PerfilClienteScreen extends StatefulWidget {
  final int userId;
  const PerfilClienteScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<PerfilClienteScreen> createState() => _PerfilClienteScreenState();
}

class _PerfilClienteScreenState extends State<PerfilClienteScreen> {
  final ApiService _api = ApiService();
  bool _loading = true;
  Usuario? _cliente;
  List<Pedido> _pedidos = [];
  String? _error;
  Set<int> _expandedPedidos = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final cliente = await _api.getUsuarioPorId(widget.userId);
      final pedidos = await _api.getPedidosCliente();
      setState(() {
        _cliente = cliente;
        _pedidos = pedidos;
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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null || _cliente == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Perfil Cliente'),
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
                    backgroundImage:
                        _cliente!.fotoPerfil.isNotEmpty
                            ? NetworkImage(_cliente!.fotoPerfil)
                            : const AssetImage('assets/Logo.jpeg')
                                as ImageProvider,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _cliente!.nome,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'E-mail: ${_cliente!.email}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        Text(
                          'Telefone: ${_cliente!.telefone}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        Text(
                          'CPF: ${_cliente!.cpf}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        Text(
                          'Endereço: ${_cliente!.endereco}',
                          style: const TextStyle(color: Colors.white70),
                        ),
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
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 400),
          child: Container(
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
                  'Meus Pedidos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                if (_pedidos.isEmpty)
                  const Text('Nenhum pedido encontrado.')
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _pedidos.length,
                    itemBuilder: (context, index) {
                      final pedido = _pedidos[index];
                      final isExpanded = _expandedPedidos.contains(pedido.id);
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(
                            color: Color(0xFFB6E388),
                            width: 1.5,
                          ),
                        ),
                        child: ExpansionTile(
                          title: Text(pedido.servico.nome),
                          subtitle: Text('Status: ${pedido.status.name}'),
                          trailing: Icon(
                            isExpanded ? Icons.expand_less : Icons.expand_more,
                          ),
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
                                  Text(
                                    'Descrição: ${pedido.servico.descricao}',
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Valor: R\$ ${pedido.servico.valor.toStringAsFixed(2)}',
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Tempo restante: ${_tempoRestante(pedido.dataPedido)}',
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Solicitado em: ${DateFormat('dd/MM/yyyy – HH:mm').format(pedido.dataPedido)}',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.logout_sharp),
                    label: const Text('Sair'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFF004D40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
