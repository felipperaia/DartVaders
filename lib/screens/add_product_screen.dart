import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/services.dart'; // Para usar a máscara de entrada

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String _brand = '';
  String _model = '';
  int _year = 0;
  String _color = '';
  String _plate = '';
  final String _status = 'active'; // Status inicial
  String _vehicleType = 'car'; // Tipo de veículo inicial
  File? _selectedImage;

  // Selecionar imagem do dispositivo
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Função para salvar o veículo no banco de dados
  Future<void> _submitProduct() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final vehicle = ParseObject('Vehicle')
        ..set('brand', _brand)
        ..set('model', _model)
        ..set('year', _year)
        ..set('color', _color)
        ..set('plate', _plate)
        ..set('status', _status)
        ..set('type', _vehicleType);

      if (_selectedImage != null) {
        final parseFile = ParseFile(_selectedImage!);
        await parseFile.save();
        vehicle.set('image', parseFile); // Vincula a imagem ao veículo
      }

      final response = await vehicle.save();

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Veículo adicionado com sucesso!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao adicionar veículo: ${response.error?.message}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Veículo',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(  // Corrigido para permitir rolagem
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _selectedImage != null
                      ? Image.file(
                    _selectedImage!,
                    fit: BoxFit.cover,
                  )
                      : Center(
                    child: Icon(
                      Icons.add_a_photo,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              DropdownButton<String>(
                value: _vehicleType,
                dropdownColor: Colors.grey[850],
                items: [
                  DropdownMenuItem(
                    value: 'car',
                    child: Text('Carro', style: TextStyle(color: Colors.white)),
                  ),
                  DropdownMenuItem(
                    value: 'motorcycle',
                    child: Text('Moto', style: TextStyle(color: Colors.white)),
                  ),
                  DropdownMenuItem(
                    value: 'truck',
                    child: Text('Caminhão', style: TextStyle(color: Colors.white)),
                  ),
                  DropdownMenuItem(
                    value: 'bus',
                    child: Text('Ônibus', style: TextStyle(color: Colors.white)),
                  ),
                ],
                onChanged: (newValue) {
                  setState(() {
                    _vehicleType = newValue!;
                  });
                },
              ),
              _buildTextFormField('Marca', onSaved: (value) => _brand = value!),
              _buildTextFormField('Modelo', onSaved: (value) => _model = value!),
              _buildTextFormField(
                'Ano',
                onSaved: (value) => _year = int.parse(value!),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)], // Máscara de 4 dígitos
              ),
              _buildTextFormField('Cor', onSaved: (value) => _color = value!),
              _buildTextFormField('Placa', onSaved: (value) => _plate = value!),
              SizedBox(height: 20),
              // Botão "Salvar" pequeno e centralizado
              Center(
                child: ElevatedButton(
                  onPressed: _submitProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Borda menos arredondada
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12), // Ajuste de tamanho
                  ),
                  child: Text('Salvar', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(String label,
      {required void Function(String?) onSaved,
        TextInputType keyboardType = TextInputType.text,
        List<TextInputFormatter>? inputFormatters}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white),
          filled: true,
          fillColor: Colors.grey[850],
        ),
        style: TextStyle(color: Colors.white),
        onSaved: onSaved,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters, // Aplica as máscaras
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor insira $label';
          }
          return null;
        },
      ),
    );
  }
}
