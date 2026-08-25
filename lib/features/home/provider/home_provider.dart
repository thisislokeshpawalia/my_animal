import 'package:flutter/material.dart';
import '../data/product_repository.dart';
import '../models/product_model.dart';

class HomeProvider extends ChangeNotifier {
  final ProductRepository _repository = ProductRepository();

  List<Product> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> getProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await _repository.fetchProducts();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}