import 'package:flutter/material.dart';
import '../models/prodcut.dart';
import '../service/api_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool isLoading = false;

  List<Product> get products => _products;

  Future<void> fetchProducts() async {
    isLoading = true;
    notifyListeners();
    try {
      _products = await ApiService.getProducts();
    } catch (e) {
      print(' fetchProducts error: $e'); // Add this line
      _products = [];
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    await ApiService.addProduct(product);
    await fetchProducts();
  }

  Future<void> updateProduct(Product product) async {
    await ApiService.updateProduct(product);
    await fetchProducts();
  }

  Future<void> deleteProduct(int id) async {
    await ApiService.deleteProduct(id);
    await fetchProducts();
  }

  Product? getById(int id) {
    return _products.firstWhere(
      (prod) => prod.productId == id,
      orElse: () => null as Product,
    );
  }
}
