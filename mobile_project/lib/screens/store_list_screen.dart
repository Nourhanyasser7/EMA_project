import 'package:flutter/material.dart';
import '../models/store.dart';
import '../state_management/StoreManager.dart';
import 'nav_bar.dart';
import 'product_list_screen.dart';

// A screen to displays a list of stores (restaurants and cafés)
class StoreListScreen extends StatefulWidget {
  @override
  _StoreListScreenState createState() => _StoreListScreenState();
}

class _StoreListScreenState extends State<StoreListScreen> {
  final StoreManager storemanager = StoreManager();

  @override
  void initState() {
    super.initState();
    // Fetch the list of stores when the screen is initialized
    storemanager.getStores();
  }

  @override
  void dispose() {
    storemanager.dispose(); // Clean up stream when screen is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color.fromARGB(255, 89, 136, 170);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'RESTAURANTS & CAFÉS',
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        // Listen to the stream of store data and rebuild UI when it changes
        child: StreamBuilder<List<Store>>(
          stream: storemanager.storesStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final stores = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.only(top: 100),
                itemCount: stores.length,
                itemBuilder: (context, index) {
                  final store = stores[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 218, 232, 242),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        title: Text(
                          store.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 57, 93, 119),
                          ),
                        ),
                        subtitle: Text(
                          store.type,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 90, 120, 140),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              // Show error message if fetching data failed
              return const Center(child: Text('Error loading stores'));
            } else {
              // Show a loading spinner while data is being fetched
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      bottomNavigationBar: const NavBar(selectedIndex: 0),
    );
  }
}