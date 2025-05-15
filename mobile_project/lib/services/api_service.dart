import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../models/store.dart';
import '../models/product.dart';

// A service class responsible for handling API requests to the backend.
class ApiService {
  // Dio HTTP client configured with the base API URL
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8000/api/'));

  // Fetches a list of all available stores from the API.
  Future<List<Store>> getStores() async {
    try {
      final response = await _dio.get('/stores/');
      // Map each JSON object to a Store model
      return (response.data as List).map((json) => Store.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching stores: $e');
      return [];  // Return empty list on failure
    }
  }

  // Fetches products that belong to a specific store by [storeId]
  Future<List<Product>> getProductsInStore(int storeId) async {
    try {
      final response = await _dio.get('/stores/$storeId/products/');      
      // Map each JSON object to a Product model
      return (response.data as List).map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching products for store $storeId: $e');
      return [];  // Return empty list on failure
    }
  }
  // Fetches all products from all stores by making sequential requests.
  Future<List<Product>> getAllProducts() async {
    try {
      // First, get all available stores
      final stores = await getStores();
      List<Product> allProducts = [];
      // Loop over each store and fetch its products
      for (var store in stores) {
        final products = await getProductsInStore(store.id);
        allProducts.addAll(products);
      }
      return allProducts;
    } catch (e) {
      print('Error fetching all products: $e');
      return [];  // Return empty list on failure
    }
  }

   // Fetches detailed information about a single store using [storeId].
   Future<Store> getStoreDetails(int storeId) async {
     try {
      final response = await _dio.get('/stores/$storeId/');      
      // Ensure we're getting the first element of the list (assuming it's a list of one store)
      if (response.data is List && response.data.isNotEmpty) {
        return Store.fromJson(response.data[0]);  // Use the first item from the list
      } else {
        throw Exception('Store not found');
      }
    } catch (e) {
      print('Error fetching store details: $e');
      throw e;  // Re-throw to be caught in the screen
    }
  
  }

   // Fetches stores that sell a specific product 
  Future<List<Store>> searchStoresByProduct(String productName) async {
    try {
      final response = await _dio.get('/search/', queryParameters: {'product': productName});
      // Map each JSON object to a list of Store objects and return it
      return (response.data as List).map((json) => Store.fromJson(json)).toList();
    } catch (e) {
      print('Error searching stores by product: $e');
      return []; // Return empty list on failure
    }
  }
}
