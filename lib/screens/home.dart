import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/servico.dart';
import '../models/usuario.dart';

class HomeScreen extends StatefulWidget {
  final int userId;
  const HomeScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _api = ApiService();
  bool _loadingUser = true;
  bool _loadingServices = true;
  Usuario? _usuario;
  String? _erroUser;
  String? _erroServices;

  static const List<Categoria> _allCategories = [
    Categoria.REPAROS_ELETRONICOS,
    Categoria.PEDREIRO,
    Categoria.MECANICO,
    Categoria.ENCANADOR,
    Categoria.ELETRICISTA,
    Categoria.DIARISTA,
  ];

  Categoria? _selectedCategory;
  List<Servico> _servicesToShow = [];

  static const Map<Categoria, Map<String, String>> _categoryData = {
    Categoria.DIARISTA: {'label': 'Diarista', 'asset': 'assets/diarista.png'},
    Categoria.ELETRICISTA: {'label': 'Eletricista', 'asset': 'assets/eletricista.png'},
    Categoria.ENCANADOR: {'label': 'Encanador', 'asset': 'assets/encanador.png'},
    Categoria.MECANICO: {'label': 'Mecânico', 'asset': 'assets/mecanico.png'},
    Categoria.PEDREIRO: {'label': 'Pedreiro', 'asset': 'assets/pedreiro.png'},
    Categoria.REPAROS_ELETRONICOS: {'label': 'Reparos', 'asset': 'assets/reparos.png'},
  };

  @override
  void initState() {
    super.initState();
    _selectedCategory = null;
    _fetchUser();
    _fetchServices();
  }

  Future<void> _fetchUser() async {
    try {
      final user = await _api.getUsuarioPorId(widget.userId);
      setState(() {
        _usuario = user;
        _loadingUser = false;
      });
    } catch (_) {
      setState(() {
        _erroUser = 'Erro ao carregar usuário.';
        _loadingUser = false;
      });
    }
  }

  Future<void> _fetchServices() async {
    setState(() {
      _loadingServices = true;
      _erroServices = null;
    });
    try {
      final services = _selectedCategory == null
          ? await _api.getServicos()
          : await _api.getServicosPorCategoria(_selectedCategory!.name);
      setState(() {
        _servicesToShow = services;
        _loadingServices = false;
      });
    } catch (_) {
      setState(() {
        _erroServices = 'Erro ao carregar serviços.';
        _loadingServices = false;
      });
    }
  }

  void _onCategoryTap(Categoria? cat) {
    setState(() {
      _selectedCategory = cat;
    });
    _fetchServices();
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingUser) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_erroUser != null || _usuario == null) {
      return Scaffold(
        body: Center(
          child: Text(
            _erroUser ?? 'Usuário não encontrado.',
            style: const TextStyle(color: Colors.redAccent),
          ),
        ),
      );
    }

    final displayCategories = <Categoria?>[null, ..._allCategories];

    return Scaffold(
      backgroundColor: const Color(0xFF1E2A30),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(140),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF004D40), Color(0xFF1E2A30)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: _usuario!.fotoPerfil.isNotEmpty
                              ? NetworkImage(_usuario!.fotoPerfil)
                              : const AssetImage('assets/Logo.jpeg') as ImageProvider,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Olá,', style: TextStyle(color: Colors.white, fontSize: 16)),
                            Text(
                              _usuario!.nome,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.message, color: Colors.white, size: 28),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: displayCategories.length,
              itemBuilder: (context, index) {
                final cat = displayCategories[index];
                final isSelected = cat == _selectedCategory;
                final label = cat == null ? 'Todos' : _categoryData[cat]!['label']!;
                final asset = cat == null ? 'assets/todos.png' : _categoryData[cat]!['asset']!;
                return GestureDetector(
                  onTap: () => _onCategoryTap(cat),
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? Colors.greenAccent : Colors.white12,
                        width: 1.5,
                      ),
                      color: isSelected ? Colors.green.withOpacity(0.1) : Colors.transparent,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(asset, width: 40, height: 40),
                        const SizedBox(height: 8),
                        Text(
                          label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isSelected ? Colors.greenAccent : Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: _loadingServices
                ? const Center(child: CircularProgressIndicator())
                : _erroServices != null
                    ? Center(
                        child: Text(
                          _erroServices!,
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _servicesToShow.length,
                        itemBuilder: (context, idx) {
                          final s = _servicesToShow[idx];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  s.nome,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  s.descricao,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'R\$ ${s.valor.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.greenAccent,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}