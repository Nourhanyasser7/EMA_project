import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import '../models/store.dart';
import '../services/api_service.dart';

// Class to manage the state and data flow of stores
class StoreManager {
  final _storeSubject = BehaviorSubject<List<Store>>();
  final ApiService _apiService = ApiService();  // Instance of the service class to make API calls
    
  // Public stream provide updated store lists data to the UI
  Stream<List<Store>> get storesStream => _storeSubject.stream;
  
  // Get stores from the API and send them to the stream
  void getStores() async {
    final stores = await _apiService.getStores();
    _storeSubject.sink.add(stores);  // Send data to the stream 
  }

  // Clean up when this class is no longer needed
  void dispose() {
    _storeSubject.close();
  }
}
