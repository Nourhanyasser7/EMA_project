import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ApiService _apiService = ApiService();
  Map<int, List<Product>> groupedProducts = {};
  Map<int, String> storeNames = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProductsAndStoreNames();
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
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
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
                            }),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Future<void> _fetchProductsAndStoreNames() async {
    try {
      List<Product> products = await _apiService.fetchAllProducts();
      groupedProducts = _groupProductsByStore(products);

      List<Future<void>> storeDetailsFutures = [];
      groupedProducts.forEach((storeId, _) {
        storeDetailsFutures.add(
          _apiService.fetchStoreDetails(storeId).then((store) {
            storeNames[storeId] = store.name;
          }),
        );
      });

      await Future.wait(storeDetailsFutures);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Map<int, List<Product>> _groupProductsByStore(List<Product> products) {
    Map<int, List<Product>> grouped = {};
    for (var product in products) {
      grouped.putIfAbsent(product.storeId, () => []).add(product);
    }
    return grouped;
  }
}
