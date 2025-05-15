
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/store.dart';

class ProductMapScreen extends StatelessWidget {
  final List<Store> stores;

  const ProductMapScreen({Key? key, required this.stores}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If no stores, center on (0,0)
    if (stores.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Stores Map View")),
        body: const Center(child: Text("No stores found.")),
      );
    }

    // Compute LatLngBounds to include all store locations
    final bounds = LatLngBounds(
      LatLng(stores[0].latitude, stores[0].longitude),
      LatLng(stores[0].latitude, stores[0].longitude),
    );
    for (var store in stores) {
      bounds.extend(LatLng(store.latitude, store.longitude));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Stores Map View")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          clipBehavior: Clip.antiAlias,
          child: FlutterMap(
            options: MapOptions(
              bounds: bounds,
              boundsOptions: const FitBoundsOptions(
                padding: EdgeInsets.all(50),
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: stores.map((store) {
                  return Marker(
                    width: 80,
                    height: 80,
                    point: LatLng(store.latitude, store.longitude),
                    child:  Column(
                      children: [
                        const Icon(Icons.location_pin, color: Colors.red, size: 36),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          child: Text(
                            store.name,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
