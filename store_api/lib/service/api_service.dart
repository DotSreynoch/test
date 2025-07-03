import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/prodcut.dart';

class ApiService {
  static const baseUrl = 'http://192.168.1.4:3000/api/products';

  static Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load products");
    }
  }

  static Future<void> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );
    if (response.statusCode != 201) throw Exception("Failed to add product");
  }

  static Future<void> updateProduct(Product product) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${product.productId}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );
    if (response.statusCode != 200) throw Exception("Failed to update product");
  }

  static Future<void> deleteProduct(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) throw Exception("Failed to delete product");
  }
}
