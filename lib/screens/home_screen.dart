import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'product_details_screen.dart';
import '../widgets/navigation_bar.dart';
import 'services_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  List<ParseObject> vehicles = [];
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _fetchVehicles();
    _controller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fetchVehicles() async {
    final query = QueryBuilder(ParseObject('Vehicle'));
    final response = await query.query();

    if (response.success && response.results != null) {
      setState(() {
        vehicles = response.results!.cast<ParseObject>();
      });
    } else {
      print('Erro ao carregar veículos: ${response.error?.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manager Auto',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: _currentIndex == 0
          ? Padding(
        padding: const EdgeInsets.all(8.0),
        child: vehicles.isEmpty
            ? Center(child: CircularProgressIndicator())
            : GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 1,
          ),
          itemCount: vehicles.length,
          itemBuilder: (context, index) {
            final vehicle = vehicles[index];
            final imageFile = vehicle.get<ParseFile>('image');
            final imageUrl = imageFile?.url;

            return GestureDetector(
              onTapDown: (_) {
                _controller.forward();
              },
              onTapUp: (_) async {
                await Future.delayed(Duration(milliseconds: 100));
                _controller.reverse();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsScreen(
                      plate: vehicle.get<String>('plate')!,
                    ),
                  ),
                );
              },
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1 + _controller.value * 0.1,
                    child: child,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF3A3A3A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: imageUrl != null
                              ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                          )
                              : Icon(
                            Icons.directions_car,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          vehicle.get<String>('plate')!,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      )
          : _currentIndex == 1
          ? ServicesScreen()
          : ProfileScreen(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _currentIndex == 0
          ? Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: FloatingActionButton(
          onPressed: () async {
            await Navigator.pushNamed(context, '/addProduct');
            _fetchVehicles();
          },
          backgroundColor: Colors.black,
          child: Icon(Icons.add, color: Colors.white),
        ),
      )
          : null, // Botão flutuante só aparece na Home
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
