import 'package:flutter/material.dart';
import '../models/store.dart';
import '../state_management/store_bloc.dart';
import 'product_list_screen.dart';

class StoreListScreen extends StatefulWidget {
  const StoreListScreen({super.key});

  @override
  _StoreListScreenState createState() => _StoreListScreenState();
}

class _StoreListScreenState extends State<StoreListScreen> {
  final StoreBloc _storeBloc = StoreBloc();

  @override
  void initState() {
    super.initState();
    _storeBloc.fetchStores();
  }

  @override
  void dispose() {
    _storeBloc.dispose();
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
        child: StreamBuilder<List<Store>>(
          stream: _storeBloc.storesStream,
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductListScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading stores'));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
