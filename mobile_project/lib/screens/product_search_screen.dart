import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map_math/flutter_geo_math.dart';
import 'package:mobile_project/screens/product_map_screen.dart';
import '../models/product.dart';
import '../models/store.dart';
import '../services/api_service.dart';

class ProductSearchScreen extends StatefulWidget {
  const ProductSearchScreen({super.key});

  @override
  _ProductSearchScreenState createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  final ApiService _apiService = ApiService();
  List<Product> allProducts = [];
  Product? selectedProduct;
  List<Store> matchingStores = [];

  @override
  void initState() {
    super.initState();
    _fetchAllProducts();
  }

  void _fetchAllProducts() async {
    final products = await _apiService.getAllProducts();
    setState(() {
      allProducts = products;
    });
  }

  void _searchStoresByProduct(String productName) async {
    final stores = await _apiService.searchStoresByProduct(productName);
    setState(() {
      matchingStores = stores;
    });
  }

  Future<void> _showDistanceToStore(Store store) async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permission denied.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied.');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final flutterMapMath = FlutterMapMath();
      double distanceInMeters = flutterMapMath.distanceBetween(
        position.latitude,
        position.longitude,
        store.latitude,
        store.longitude,
        "meters",
      );

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(store.name),
          content: Text(
            'Distance between you and this store is about ${distanceInMeters.toStringAsFixed(2)} meters',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Cannot get your current location!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search by Product")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<Product>(
              value: selectedProduct,
              hint: Text('Select a product'),
              isExpanded: true,
              items: allProducts.map((Product product) {
                return DropdownMenuItem<Product>(
                  value: product,
                  child: Text(product.name),
                );
              }).toList(),
              onChanged: (Product? newValue) {
                setState(() {
                  selectedProduct = newValue;
                });
                _searchStoresByProduct(newValue!.name);
              },
            ),
            SizedBox(height: 20),
            
            ElevatedButton.icon(
              icon: Icon(Icons.map),
              label: Text("View as Map"),
              onPressed: () {
                if (matchingStores.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductMapScreen(stores: matchingStores),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please select a product with results first.")),
                  );
                }
              },
            ),

            Expanded(
              child: ListView.builder(
                itemCount: matchingStores.length,
                itemBuilder: (context, index) {
                  final store = matchingStores[index];
                  return Card(
                    child: ListTile(
                      title: Text(store.name),
                      trailing: IconButton(
                        icon: Icon(Icons.route),
                        onPressed: () => _showDistanceToStore(store),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
