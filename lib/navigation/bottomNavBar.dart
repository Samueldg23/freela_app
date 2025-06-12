import 'package:flutter/material.dart';
import 'package:freela_flutter/screens/home.dart';
import 'package:freela_flutter/screens/perfilCliente.dart';
import 'package:freela_flutter/screens/perfilPrestador.dart';
import '../services/api_service.dart';
import '../models/usuario.dart';

class BottomNavBar extends StatefulWidget {
  final int userId;
  const BottomNavBar({Key? key, required this.userId}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final ApiService _api = ApiService();
  bool _loading = true;
  Usuario? _usuario;
  String? _erro;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _initUser();
  }

  Future<void> _initUser() async {
    try {
      final user = await _api.getUsuarioPorId(widget.userId);
      setState(() {
        _usuario = user;
        _loading = false;
      });
    } catch (_) {
      setState(() {
        _erro = 'Erro ao carregar dados do usuário.';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_erro != null || _usuario == null) {
      return Scaffold(
        body: Center(
          child: Text(
            _erro ?? 'Usuário não encontrado.',
            style: const TextStyle(color: Colors.redAccent),
          ),
        ),
      );
    }

    final isCliente = _usuario!.tipoUsuario == TipoUsuario.CLIENTE;
    final pages = <Widget>[
      HomeScreen(userId: widget.userId),
      isCliente
          ? PerfilClienteScreen(userId: widget.userId)
          : PerfilPrestadorScreen(userId: widget.userId),
    ];

    final items = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
      BottomNavigationBarItem(
        icon: Icon(isCliente ? Icons.person : Icons.work),
        label: isCliente ? 'Perfil' : 'Prestador',
      ),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1E2A30),
        selectedItemColor: const Color(0xFFB6E388),
        unselectedItemColor: Colors.white70,
        currentIndex: _currentIndex,
        items: items,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
