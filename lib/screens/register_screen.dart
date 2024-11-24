import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  DateTime? selectedDate;

  // Função de registro no Parse
  Future<void> _registerUser() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String firstName = nameController.text.trim();
    String lastName = lastNameController.text.trim();
    String birthDate = birthDateController.text.trim();

    // Validações de campos
    if (firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty || birthDate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Preencha todos os campos!')));
      return;
    }

    final user = ParseUser(email, password, email)
      ..set('firstName', firstName)
      ..set('lastName', lastName)
      ..set('birthDate', birthDate);

    final response = await user.signUp();

    if (response.success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Usuário cadastrado com sucesso!')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro no cadastro: ${response.error?.message}')),
      );
    }
  }

  // Função para abrir o seletor de data
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        // Atualiza o controlador com a data formatada no formato 'yyyy-MM-dd'
        birthDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('lib/images/logo.png', height: 32),
            SizedBox(width: 8),
            Text('Manager Auto', style: TextStyle(color: Colors.black87)),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView( // Adicionando o SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Cadastre-se",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            _buildInputField(nameController, 'Nome'),
            _buildInputField(lastNameController, 'Sobrenome'),
            _buildInputField(emailController, 'E-mail'),
            _buildDatePicker(),
            _buildInputField(passwordController, 'Senha', obscureText: true),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _registerUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Cadastrar', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String label, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.black87,
          labelStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black87),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: _selectDate,
      child: AbsorbPointer(
        child: TextField(
          controller: birthDateController,
          decoration: InputDecoration(
            labelText: 'Data de Nascimento',
            filled: true,
            fillColor: Colors.black87,
            labelStyle: TextStyle(color: Colors.white),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black87),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
