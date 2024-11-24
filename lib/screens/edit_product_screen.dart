import 'package:flutter/material.dart';
import 'dart:io';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:flutter/services.dart'; // Para máscara de entrada
import 'package:image_picker/image_picker.dart'; // Para selecionar imagem

class EditProductScreen extends StatefulWidget {
  final ParseObject vehicle;

  const EditProductScreen({super.key, required this.vehicle});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final TextEditingController brandController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController plateController = TextEditingController();

  final TextEditingController serviceDescriptionController = TextEditingController();
  final TextEditingController serviceDateController = TextEditingController();
  String? serviceStatus = 'Pendente';

  List<dynamic> services = [];
  ParseFile? vehicleImage;

  @override
  void initState() {
    super.initState();
    final vehicle = widget.vehicle;
    brandController.text = vehicle.get<String>('brand') ?? '';
    modelController.text = vehicle.get<String>('model') ?? '';
    yearController.text = vehicle.get<int>('year')?.toString() ?? '';
    colorController.text = vehicle.get<String>('color') ?? '';
    plateController.text = vehicle.get<String>('plate') ?? '';
    services = vehicle.get<List<dynamic>>('services') ?? [];
    vehicleImage = vehicle.get<ParseFile>('image');
  }

  // Função para adicionar um novo serviço
  void _addService() {
    final newService = {
      'description': serviceDescriptionController.text,
      'date': serviceDateController.text,
      'status': serviceStatus,
    };

    setState(() {
      services.add(newService);
      serviceDescriptionController.clear();
      serviceDateController.clear();
      serviceStatus = 'Pendente';
    });
  }

  // Função para atualizar os dados do veículo no banco
  Future<void> _updateProduct() async {
    widget.vehicle
      ..set('brand', brandController.text)
      ..set('model', modelController.text)
      ..set('year', int.tryParse(yearController.text) ?? 0)
      ..set('color', colorController.text)
      ..set('plate', plateController.text)
      ..set('services', services)
      ..set('image', vehicleImage); // Atualiza a imagem também

    final response = await widget.vehicle.save();

    if (response.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veículo atualizado com sucesso!')),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar o veículo: ${response.error?.message}')),
      );
    }
  }

  // Função simplificada para campo de texto
  Widget _buildTextFormField(String label, {required TextInputType keyboardType, List<TextInputFormatter>? inputFormatters, TextEditingController? controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white),
          filled: true,
          fillColor: Colors.grey[850],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  // Função para escolher uma nova imagem
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = ParseFile(File(pickedFile.path));
      setState(() {
        vehicleImage = file;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Veículo', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Exibe a imagem do veículo, se disponível
              GestureDetector(
                onTap: _pickImage,
                child: _buildVehicleImage(),
              ),
              SizedBox(height: 20),

              // Campos de edição do veículo
              _buildTextFormField('Marca', controller: brandController, keyboardType: TextInputType.text),
              _buildTextFormField('Modelo', controller: modelController, keyboardType: TextInputType.text),
              _buildTextFormField(
                'Ano',
                controller: yearController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4) // Limita a 4 caracteres
                ],
              ),
              _buildTextFormField('Cor', controller: colorController, keyboardType: TextInputType.text),
              _buildTextFormField('Placa', controller: plateController, keyboardType: TextInputType.text),

              // Divisória entre as seções
              Divider(color: Colors.white, thickness: 1, height: 40),

              // Campos para adicionar um serviço
              _buildTextFormField('Descrição do Serviço', controller: serviceDescriptionController, keyboardType: TextInputType.text),
              _buildTextFormField('Data do Serviço', controller: serviceDateController, keyboardType: TextInputType.datetime),
              Container(
                child: DropdownButtonFormField<String>(
                  value: serviceStatus,
                  onChanged: (newStatus) {
                    setState(() {
                      serviceStatus = newStatus;
                    });
                  },
                  items: ['Pendente', 'Em andamento', 'Concluído']
                      .map((status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(
                        status,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    border: InputBorder.none, // Remove a borda extra
                  ),
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
              ElevatedButton(
                onPressed: _addService,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),
                child: Text('Adicionar Serviço'),
              ),
              SizedBox(height: 20),

              // Exibe a lista de serviços já adicionados
              Text('Serviços Adicionados:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ListView.builder(
                shrinkWrap: true,
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return ListTile(
                    title: Text(service['description'] ?? 'Sem descrição', style: TextStyle(color: Colors.white)),
                    subtitle: Text('Status: ${service['status']} - Data: ${service['date']}', style: TextStyle(color: Colors.white)),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          services.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: 20),

              // Botão para salvar as alterações no veículo
              ElevatedButton(
                onPressed: _updateProduct,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),
                child: Text('Salvar Alterações'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleImage() {
    return vehicleImage == null
        ? Icon(Icons.car_repair, size: 120, color: Colors.white)
        : Container(
      alignment: Alignment.center,
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(vehicleImage!.url!),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
