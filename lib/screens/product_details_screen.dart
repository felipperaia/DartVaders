import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'edit_product_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String plate;

  const ProductDetailsScreen({super.key, required this.plate});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  ParseObject? vehicle;
  List<dynamic> services = [];
  final List<String> statusOptions = ['Pendente', 'Em andamento', 'Concluído'];

  Future<void> _fetchVehicleDetails() async {
    final query = QueryBuilder(ParseObject('Vehicle'))
      ..whereEqualTo('plate', widget.plate);

    try {
      final response = await query.query().timeout(Duration(seconds: 10));

      if (response.success && response.results != null) {
        setState(() {
          vehicle = response.results!.first as ParseObject;
          services = vehicle!.get<List<dynamic>>('services') ?? [];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar os dados do veículo.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar os dados do veículo.')),
      );
    }
  }

  Future<void> _updateServiceStatus(int index, String newStatus) async {
    setState(() {
      services[index]['status'] = newStatus;
    });

    vehicle!.set('services', services);
    await vehicle!.save();
  }

  Future<void> _deleteVehicle() async {
    final response = await vehicle!.delete();

    if (response.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veículo excluído com sucesso!')),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir o veículo: ${response.error?.message}')),
      );
    }
  }

  Widget _buildServiceList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        final String status = service['status'] ?? 'Pendente';

        return Card(
          color: Colors.white,
          margin: EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            title: Text(
              service['description'] ?? 'Sem descrição',
              style: TextStyle(color: Colors.black),
            ),
            subtitle: Text(
              'Data: ${service['date'] ?? 'Indefinido'}',
              style: TextStyle(color: Colors.black54),
            ),
            trailing: DropdownButton<String>(
              value: status,
              onChanged: (newStatus) {
                if (newStatus != null) {
                  _updateServiceStatus(index, newStatus);
                }
              },
              items: statusOptions.map((statusOption) {
                return DropdownMenuItem<String>(
                  value: statusOption,
                  child: Text(statusOption),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchVehicleDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          vehicle != null ? 'Veículo ${vehicle!.get<String>('plate')}' : 'Carregando...',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              if (vehicle != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProductScreen(vehicle: vehicle!),
                  ),
                ).then((value) {
                  if (value == true) {
                    _fetchVehicleDetails();
                  }
                });
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deleteVehicle,
          ),
        ],
      ),
      backgroundColor: Color(0xFF3A3A3A),
      body: vehicle != null
          ? SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Card(
                elevation: 6.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Container(
                        height: 180,
                        width: 180,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: vehicle!.get<ParseFile>('image') != null
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            vehicle!.get<ParseFile>('image')!.url!,
                            fit: BoxFit.cover,
                          ),
                        )
                            : Icon(
                          vehicle!.get<String>('type') == 'car'
                              ? Icons.directions_car
                              : Icons.motorcycle,
                          size: 80,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Tipo: ${vehicle!.get<String>('type')}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildDetailRow('Marca', vehicle!.get<String>('brand')),
            _buildDetailRow('Modelo', vehicle!.get<String>('model')),
            _buildDetailRow('Ano', vehicle!.get<int>('year')?.toString()),
            _buildDetailRow('Cor', vehicle!.get<String>('color')),
            _buildDetailRow('Placa', vehicle!.get<String>('plate')),
            SizedBox(height: 20),
            Text(
              'Serviços Relacionados:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            _buildServiceList(),
          ],
        ),
      )
          : Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
          ),
          Text(
            value ?? 'Indefinido',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
