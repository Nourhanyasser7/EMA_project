import 'package:flutter/material.dart';

//model class for the store
class Store {
  final int id;
  final String name;
  final String type;
  final double latitude;
  final double longitude;

// Constructor to initialize a Store object
  Store({
    required this.id,
    required this.name,
    required this.type,
    required this.latitude,
    required this.longitude,
  });

 // Factory constructor to create a Store object from a Json 
  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}