import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../state_management/ProductManager.dart'; 

// Screen to display all products grouped by store
class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ProductManager _productManager = ProductManager();
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _productManager.getAllProducts(); // Fetch products when screen starts
  }

  @override
  void dispose() {
    _productManager.dispose(); // Clean up stream when screen is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color.fromARGB(255, 89, 136, 170);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'ALL PRODUCTS',
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: StreamBuilder<List<Product>>(
          stream: _productManager.productsStream, // Listen to product updates
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator()); // Show loading
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No products found."));
            }

            final products = snapshot.data!;
            final groupedProducts = groupProductsByStore(products);

            // Fetch store names for the grouped products
            return FutureBuilder<Map<int, String>>(
              future: getStoreNames(groupedProducts.keys.toList()),
              builder: (context, storeSnapshot) {
                if (!storeSnapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final storeNames = storeSnapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.only(top: 100, bottom: 16),
                  itemCount: groupedProducts.keys.length,
                  itemBuilder: (context, index) {
                    final storeId = groupedProducts.keys.elementAt(index);
                    final storeProducts = groupedProducts[storeId]!;
                    final storeName = storeNames[storeId] ?? 'Unknown Store';

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 218, 232, 242),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                storeName,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromARGB(255, 57, 93, 119),
                                ),
                              ),
                              const SizedBox(height: 10),
                              ...storeProducts.map((product) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                                  child: Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 90, 120, 140),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  // Groups products by their storeId
  Map<int, List<Product>> groupProductsByStore(List<Product> products) {
    Map<int, List<Product>> grouped = {};
    for (var product in products) {
      grouped.putIfAbsent(product.storeId, () => []).add(product);
    }
    return grouped;
  }

  // Fetches the store names given a list of store IDs
  Future<Map<int, String>> getStoreNames(List<int> storeIds) async {
    Map<int, String> names = {};
    for (int id in storeIds) {
      try {
        final store = await _apiService.getStoreDetails(id);
        names[id] = store.name;
      } catch (e) {
        names[id] = 'Unknown Store';
      }
    }
    return names;
  }
}
