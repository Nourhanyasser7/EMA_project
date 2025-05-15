import 'package:rxdart/rxdart.dart';
import '../models/store.dart';
import '../services/api_service.dart';

class StoreBloc {
  final _storeSubject = BehaviorSubject<List<Store>>();
  final ApiService _apiService = ApiService();

  Stream<List<Store>> get storesStream => _storeSubject.stream;

  void fetchStores() async {
    final stores = await _apiService.fetchStores();
    _storeSubject.sink.add(stores);
  }

  void dispose() {
    _storeSubject.close();
  }
}
