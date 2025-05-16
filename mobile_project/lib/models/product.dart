import 'package:flutter/material.dart';

//model class for the Product
class Product {
  final int id;
  final String name;
  final int storeId;

// Constructor to initialize a Product object
  Product({
    required this.id,
    required this.name,
    required this.storeId,
  });

 // Factory constructor to create a Product object from a Json 
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      storeId: json['store'],
    );
  }
}