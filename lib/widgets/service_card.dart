import 'package:flutter/material.dart';

// Defina o modelo de serviço
class ServiceCard extends StatelessWidget {
  final Map<String, dynamic> service; // O serviço a ser exibido
  final List<String> statusOptions;  // Lista de status possíveis
  final Function(String) onStatusChanged;  // Função que será chamada ao alterar o status

  // Construtor do ServiceCard
  const ServiceCard({super.key,
    required this.service,
    required this.statusOptions,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Serviço: ${service['serviceName']}',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text('Placa: ${service['plate']}', style: TextStyle(fontSize: 16)),
        Text('Modelo: ${service['model']}', style: TextStyle(fontSize: 16)),
        SizedBox(height: 8),
        Text('Descrição: ${service['serviceDescription']}', style: TextStyle(fontSize: 16)),
        Text('Data: ${service['serviceDate']}', style: TextStyle(fontSize: 16)),
        SizedBox(height: 8),
        Text('Status: ${service['serviceStatus']}', style: TextStyle(fontSize: 16)),
        SizedBox(height: 16),
        DropdownButton<String>(
          value: service['serviceStatus'],
          onChanged: (newStatus) {
            if (newStatus != null) {
              onStatusChanged(newStatus); // Atualiza o status
            }
          },
          items: statusOptions.map((status) {
            return DropdownMenuItem<String>(
              value: status,
              child: Text(status),
            );
          }).toList(),
        ),
        SizedBox(height: 16),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fecha o diálogo
            },
            child: Text('Fechar'),
          ),
        ),
      ],
    );
  }
}