import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
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

  // Função que exibe o diálogo com os detalhes do serviço
  void _showServiceDetails(ParseObject service) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 16,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start, // Alinha à esquerda
              children: [
                Text(
                  'Detalhes do Serviço',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Título em preto
                  ),
                ),
                SizedBox(height: 16),
                // Alinhamento à esquerda e direita para as informações
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Modelo:',
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      service.get<String>('model') ?? 'Desconhecido',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Placa:',
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      service.get<String>('plate') ?? 'Desconhecida',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Data:',
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      service.get<String>('date') ?? 'Indefinido',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Status:',
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      service.get<String>('status') ?? 'Indefinido',
                      style: TextStyle(
                        color: service.get<String>('status') == 'Disponível'
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Descrição abaixo de tudo, com maior largura
                Text(
                  'Descrição:',
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: 8),
                Text(
                  service.get<String>('description') ?? 'Sem descrição',
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: 20),
                // Centralizando o botão
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Fechar o diálogo
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black, // Botão preto
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Bordas arredondadas
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12), // Ajuste de tamanho
                    ),
                    child: Text('Fechar'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchServices(); // Carrega os serviços quando a tela for exibida
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: allServices.isNotEmpty
          ? ListView.builder(
        itemCount: allServices.length,
        itemBuilder: (context, index) {
          final service = allServices[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              contentPadding: EdgeInsets.all(16.0),
              title: Text(
                service.get<String>('description') ?? 'Sem Descrição',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.0),
                  Text('Modelo: ${service.get<String>('model')}'),
                  Text('Placa: ${service.get<String>('plate')}'),
                ],
              ),
              onTap: () => _showServiceDetails(service), // Exibe os detalhes
            ),
          );
        },
      )
          : Center(child: CircularProgressIndicator()), // Exibe um loading enquanto carrega os serviços
    );
  }
}
