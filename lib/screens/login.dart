import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:freela_flutter/screens/cadastro.dart';
import '../navigation/bottomNavBar.dart';
import '../models/usuario.dart';
import '../services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final ApiService _api = ApiService();
  bool _loading = false;
  String? _mensagemErro;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _fazerLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _mensagemErro = null;
    });

    final url = Uri.parse(
      'https://freela-api-29fi.onrender.com/usuarios/login'
      '?email=${_emailController.text.trim()}&senha=${_senhaController.text}',
    );

    try {
      final resp = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (resp.statusCode != 200) {
        setState(() => _mensagemErro = 'Email ou senha inválidos');
        return;
      }

      final body = resp.body.trim();
      final prefs = await SharedPreferences.getInstance();
      int userId;

      if (body.startsWith('{')) {
        final json = jsonDecode(body);
        final usuario = Usuario.fromJson(json['usuario']);
        await prefs.setString('jwt', json['token']);
        userId = usuario.id;
      } else {
        final usuarios = await _api.getUsuarios();
        final email = _emailController.text.trim();
        final usuario = usuarios.firstWhere((u) => u.email == email);
        userId = usuario.id;
      }

      await prefs.setInt('userId', userId);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => BottomNavBar(userId: userId)),
      );
    } catch (_) {
      setState(() => _mensagemErro = 'Erro ao fazer login');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  InputDecoration _inputDecoration(String label) {
    const primary = Color(0xFF89CFF0);
    const focus = Color(0xFFB6E388);
    const error = Colors.redAccent;
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: primary),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: primary),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: focus, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: error),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: error, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2A30),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset('assets/Logo1.png', height: 150),
                const SizedBox(height: 30),
                Text(
                  'Bem-vindo!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Faça login para continuar',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 24),
                if (_mensagemErro != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      _mensagemErro!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ),
                TextFormField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'E-mail é obrigatório';
                    if (!v.contains('@') || !v.contains('.')) return 'E-mail inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _senhaController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Senha'),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Senha é obrigatória';
                    if (v.length < 6) return 'Mínimo 6 caracteres';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _loading ? null : _fazerLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB6E388),
                    foregroundColor: const Color(0xFF1E2A30),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _loading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Color(0xFF1E2A30),
                          ),
                        )
                      : const Text('Entrar'),
                ),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  ),
                  child: const Text(
                    'Não tem uma conta? Cadastre-se',
                    style: TextStyle(color: Color(0xFF89CFF0)),
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
