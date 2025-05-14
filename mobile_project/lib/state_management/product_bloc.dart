import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductBloc {
  final _productSubject = BehaviorSubject<List<Product>>();
  final ApiService _apiService = ApiService();

  Stream<List<Product>> get productsStream => _productSubject.stream;

  void fetchAllProducts() async {
    final products = await _apiService.fetchAllProducts();
    _productSubject.sink.add(products);
  }

  void dispose() {
    _productSubject.close();
  }
}

