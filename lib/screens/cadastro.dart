import 'package:flutter/material.dart';
import 'login.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

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
    final userTypes = ['CLIENTE', 'PRESTADOR'];
    String selectedType = userTypes[0];

    return Scaffold(
      backgroundColor: const Color(0xFF1E2A30),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset('assets/Logo1.png', height: 150),
              const SizedBox(height: 30),
              Text(
                'Cadastro de Usuário',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Nome completo'),
              ),
              const SizedBox(height: 16),
              TextField(
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration('E-mail'),
              ),
              const SizedBox(height: 16),
              TextField(
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.phone,
                decoration: _inputDecoration('Telefone'),
              ),
              const SizedBox(height: 16),
              TextField(
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.text,
                decoration: _inputDecoration('Endereço'),
              ),
              const SizedBox(height: 16),
              TextField(
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.text,
                decoration: _inputDecoration('CPF'),
              ),
              const SizedBox(height: 16),
              TextField(
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Senha'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedType,
                dropdownColor: const Color(0xFF1E2A30),
                decoration: _inputDecoration('Tipo de usuário'),
                style: const TextStyle(color: Colors.white),
                items: userTypes.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {},
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB6E388),
                  foregroundColor: const Color(0xFF1E2A30),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Cadastrar'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                ),
                child: const Text(
                  'Já tem uma conta? Faça login',
                  style: TextStyle(color: Color(0xFF89CFF0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
