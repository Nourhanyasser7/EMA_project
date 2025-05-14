import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../models/store.dart';
import '../models/product.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8000/api/'));

  Future<List<Store>> fetchStores() async {
    try {
      final response = await _dio.get('/stores/');
      print("Stores fetched: ${response.data}");
      return (response.data as List).map((json) => Store.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching stores: $e');
      return [];
    }
  }

  Future<List<Product>> fetchProductsInStore(int storeId) async {
    try {
      final response = await _dio.get('/stores/$storeId/products/');
      print("Products fetched for store $storeId: ${response.data}");
      return (response.data as List).map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching products for store $storeId: $e');
      return [];
    }
  }

  Future<List<Product>> fetchAllProducts() async {
    try {
      // Fetch all stores first
      final stores = await fetchStores();
      List<Product> allProducts = [];

      // Loop over each store and fetch its products
      for (var store in stores) {
        print('Fetching products for store ${store.id}');
        final products = await fetchProductsInStore(store.id);
        allProducts.addAll(products);
      }

      print("Total products fetched: ${allProducts.length}");
      return allProducts;
    } catch (e) {
      print('Error fetching all products: $e');
      return [];
    }
  }
   Future<Store> fetchStoreDetails(int storeId) async {
     try {
      final response = await _dio.get('/stores/$storeId/');
      print("Store details fetched: ${response.data}");
      
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


  Future<List<Store>> searchStoresByProduct(String productName) async {
    try {
      final response = await _dio.get('/search/', queryParameters: {'product': productName});
      print("Stores searched by product $productName: ${response.data}");
      return (response.data as List).map((json) => Store.fromJson(json)).toList();
    } catch (e) {
      print('Error searching stores by product: $e');
      return [];
    }
  }
}
