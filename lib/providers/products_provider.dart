import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_management/providers/http_exception.dart';
import 'package:shop_management/providers/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [...items];
  }

  List<Product> get favouriteItems {
    return items.where((element) => element.isFavourite).toList();
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        "http://kushalaa-c9407-default-rtdb.firebaseio.com/products.json");
    try {
      final response = await http.post(url,
          body: json.encode({
            "title": product.title,
            "description": product.description,
            "imageUrl": product.imageUrl,
            "price": product.price,
            "isFavourite": product.isFavourite,
          }));
      final newProduct = Product(
        title: product.title,
        description: product.description,
        id: json.decode(response.body)["name"],
        price: product.price,
        imageUrl: product.imageUrl,
      );
    } catch (error) {
      throw error;
    }

    notifyListeners();
  }

  Product findbyId(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    final url = Uri.parse(
        "http://kushalaa-c9407-default-rtdb.firebaseio.com/products/$id.json");
    await http.patch(url,
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
          'price': newProduct.price,
          'isFavourite': newProduct.isFavourite,
        }));
    _items[prodIndex] = newProduct;
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        "http://kushalaa-c9407-default-rtdb.firebaseio.com/products/$id.json");
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException("Could not delete product");
    }
    existingProduct = null;
  }

  Future<Void> fetchAndSet() async {
    final url = Uri.parse(
        "http://kushalaa-c9407-default-rtdb.firebaseio.com/products.json");
    try {
      final response = await http.get(url);
      final extractData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProduct = [];
      extractData.forEach((prodId, prodData) {
        loadedProduct.add(
          Product(
            id: prodId,
            title: prodData["title"],
            description: prodData["description"],
            price: prodData["price"],
            isFavourite: prodData["isFavourite"],
            imageUrl: prodData["imageUrl"],
          ),
        );
      });
      _items = loadedProduct;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
