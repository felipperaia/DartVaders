import 'package:flutter/material.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  String? profileImageUrl;
  late ParseUser currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    currentUser = await ParseUser.currentUser() as ParseUser;

    setState(() {
      nameController.text = currentUser.get<String>('firstName') ?? '';
      lastNameController.text = currentUser.get<String>('lastName') ?? '';
      emailController.text = currentUser.get<String>('email') ?? '';
      birthDateController.text = currentUser.get<String>('birthDate') ?? '';
      profileImageUrl = currentUser.get<String>('profileImage') ?? '';
    });
    }

  Future<void> _saveUserProfile() async {
    currentUser.set('firstName', nameController.text);
    currentUser.set('lastName', lastNameController.text);
    currentUser.set('birthDate', birthDateController.text);

    ParseResponse response = await currentUser.save();

    if (response.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Perfil atualizado com sucesso.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar perfil: ${response.error?.message}')),
      );
    }
  }

  Future<void> _updateProfileImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      ParseFileBase parseFile = ParseFile(File(image.path));
      ParseResponse response = await parseFile.save();

      if (response.success) {
        final fileUrl = parseFile.url!;
        currentUser.set('profileImage', fileUrl);

        await currentUser.save();
        setState(() {
          profileImageUrl = fileUrl;
        });
      }
    }
  }

  Future<void> _selectBirthDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        birthDateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  Future<void> _showEditDialog({required String title, required TextEditingController controller, bool obscureText = false}) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(color: Colors.white)),
          backgroundColor: Color(0xFF1E1E1E),
          content: TextField(
            controller: controller,
            obscureText: obscureText,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[800],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              hintText: 'Digite $title',
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                setState(() {});
                Navigator.pop(context);
                if (title != 'Senha') _saveUserProfile();
              },
              child: Text('Salvar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.grey[800],
                      backgroundImage: profileImageUrl != null
                          ? NetworkImage(profileImageUrl!)
                          : null,
                      child: profileImageUrl == null
                          ? Icon(Icons.person, size: 70, color: Colors.white)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _updateProfileImage,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.black.withOpacity(0.7),
                          child: Icon(Icons.edit, color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                '${nameController.text} ${lastNameController.text}',
                style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              _buildInfoField('Nome', nameController.text, onEdit: () {
                _showEditDialog(title: 'Nome', controller: nameController);
              }),
              SizedBox(height: 16),
              _buildInfoField('Sobrenome', lastNameController.text, onEdit: () {
                _showEditDialog(title: 'Sobrenome', controller: lastNameController);
              }),
              SizedBox(height: 16),
              _buildInfoField('E-mail', emailController.text, isEditable: false),
              SizedBox(height: 16),
              _buildInfoField('Data de Nascimento', birthDateController.text, onEdit: _selectBirthDate),
              SizedBox(height: 16),
              _buildInfoField('Senha', '********', onEdit: () {
                _showEditDialog(title: 'Senha', controller: TextEditingController(), obscureText: true);
              }),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveUserProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text('SALVAR ALTERAÇÕES', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoField(String label, String value, {VoidCallback? onEdit, bool isEditable = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: isEditable ? onEdit : null,
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                if (isEditable)
                  Icon(Icons.edit, color: Colors.white70, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
