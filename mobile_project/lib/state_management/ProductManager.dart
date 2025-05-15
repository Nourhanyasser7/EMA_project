import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import '../models/product.dart';
import '../services/api_service.dart';

// Class to manage the list of products
class ProductManager {
  final _productSubject = BehaviorSubject<List<Product>>();
  final ApiService _apiService = ApiService();  // Instance of the service class to make API calls

 // Public stream provide updated product lists data to the UI
  Stream<List<Product>> get productsStream => _productSubject.stream;
  
  // Get AllProducts from the API and send them to the stream
  void getAllProducts() async {
    final products = await _apiService.getAllProducts();
    _productSubject.sink.add(products); // Send data to the stream 
  }

  // Clean up when this class is no longer needed
  void dispose() {
    _productSubject.close();
  }
}