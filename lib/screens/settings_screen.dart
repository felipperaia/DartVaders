import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<ParseObject> allServices = []; // Lista para armazenar todos os serviços

  // Função para carregar os serviços do banco de dados
  Future<void> _fetchServices() async {
    final query = QueryBuilder(ParseObject('Vehicle'));
    final response = await query.query();

    if (response.success && response.results != null) {
      final vehicles = response.results!.cast<ParseObject>();

      List<ParseObject> servicesList = [];
      for (var vehicle in vehicles) {
        final services = vehicle.get<List<dynamic>>('services') ?? [];
        for (var service in services) {
          final serviceObject = ParseObject('Service')
            ..set('plate', vehicle.get<String>('plate'))
            ..set('model', vehicle.get<String>('model'))
            ..set('description', service['description'])
            ..set('status', service['status'])
            ..set('date', service['date'] ?? '');
          servicesList.add(serviceObject);
        }
      }

      setState(() {
        allServices = servicesList; // Atualiza a lista de serviços
      });
    } else {
      print('Erro ao carregar os dados do banco: ${response.error?.message}');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações de Serviços'),
      ),
      body: allServices.isNotEmpty
          ? ListView.builder(
        itemCount: allServices.length,
        itemBuilder: (context, index) {
          final service = allServices[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              contentPadding: EdgeInsets.all(16.0),
              title: Text(service.get<String>('description') ?? 'Sem Nome'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Modelo: ${service.get<String>('model')}'),
                  Text('Placa: ${service.get<String>('plate')}'),
                  Text('Data: ${service.get<String>('date') ?? 'Indefinido'}'),
                  Text('Status: ${service.get<String>('status')}'),
                ],
              ),
              trailing: DropdownButton<String>(
                value: service.get<String>('status'),
                onChanged: (newStatus) async {
                  if (newStatus != null) {
                    service.set('status', newStatus);
                    await service.save();
                    setState(() {});
                  }
                },
                items: ['Pendente', 'Em andamento', 'Concluído'].map((status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
              ),
            ),
          );
        },
      )
          : Center(child: CircularProgressIndicator()), // Exibe loading enquanto carrega os serviços
    );
  }
}