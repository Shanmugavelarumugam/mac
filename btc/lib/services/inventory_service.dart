import 'package:btc/models/item_model.dart';
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'https://scientist-galaxy-protocols-arkansas.trycloudflare.com/api/data'),
  );

  Future<List<Item>> getAllItems() async {
    try {
      final response = await _dio.get('/inventory');
      return (response.data as List).map((e) => Item.fromJson(e)).toList();
    } catch (e) {
      print('❌ Error fetching all items: $e');
      rethrow;
    }
  }

  Future<Item> getItemById(int id) async {
    try {
      final response = await _dio.get('/inventory/$id');
      return Item.fromJson(response.data);
    } catch (e) {
      print('❌ Error fetching item by ID: $e');
      rethrow;
    }
  }

  Future<List<Item>> getItemsByUserId(int userId) async {
    try {
      final response = await _dio.get('/inventory/inventory/$userId');
      return (response.data as List).map((e) => Item.fromJson(e)).toList();
    } catch (e) {
      print('❌ Error fetching items by userId: $e');
      rethrow;
    }
  }

  Future<Item> createItem(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/inventory', data: data);
      return Item.fromJson(response.data);
    } catch (e) {
      print('❌ Error creating item: $e');
      rethrow;
    }
  }

  Future<Item> updateItem(int id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put('/inventory/$id', data: data);
      return Item.fromJson(response.data);
    } catch (e) {
      print('❌ Error updating item: $e');
      rethrow;
    }
  }

  Future<void> deleteItem(int id) async {
    try {
      await _dio.delete('/inventory/$id');
    } catch (e) {
      print('❌ Error deleting item: $e');
      rethrow;
    }
  }

  Future<Item> stockInOut(int id, Map<String, dynamic> data, bool isIn) async {
    final url = '/inventory/${isIn ? 'stock-in' : 'stock-out'}/$id';
    try {
      print('📡 Calling: ${_dio.options.baseUrl}$url');
      final response = await _dio.post(url, data: data);
      return Item.fromJson(response.data['item']);
    } catch (e) {
      print('❌ Error in stock in/out: $e');
      rethrow;
    }
  }
}
