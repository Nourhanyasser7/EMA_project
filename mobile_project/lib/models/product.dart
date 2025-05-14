import 'package:flutter/material.dart';

class Product {
  final int id;
  final String name;
  final int storeId;

  Product({
    required this.id,
    required this.name,
    required this.storeId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      storeId: json['store'],
    );
  }
}
