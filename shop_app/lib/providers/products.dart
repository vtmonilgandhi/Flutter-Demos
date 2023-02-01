import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exception.dart';
import 'product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  final String? authToken;
  final String? userId;

  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  // var _showFavoritesOnly = false;

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Products(this.authToken, this._items, this.userId);

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return [..._items.where((prodItem) => prodItem.isFavorite)];
    // }
    return [..._items];
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    var params = {'auth': authToken, 'orderBy': json.encode("creatorId")};

    if (filterByUser) {
      params = {
        'auth': authToken,
        'orderBy': json.encode("creatorId"),
        'equalTo': json.encode(userId),
      };
    }

    var url = Uri.https('shop-app-flutter-5c717-default-rtdb.firebaseio.com',
        '/products.json', params);
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      if (extractedData.isEmpty) {
        return;
      }

      url = Uri.https('shop-app-flutter-5c717-default-rtdb.firebaseio.com',
          'userFavorites/$userId.json', params);
      final favoriteResponse = await http.get(url);
      final favoriteData =
          json.decode(favoriteResponse.body) as Map<String, dynamic>;

      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            isFavorite: favoriteData[prodId] ?? false,
            imageUrl: prodData['imageUrl']));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(Product prodcut) async {
    var params = {
      'auth': authToken,
    };

    final url = Uri.https('shop-app-flutter-5c717-default-rtdb.firebaseio.com',
        '/products.json', params);

    try {
      final response = await http.post(url,
          body: json.encode({
            'title': prodcut.title,
            'description': prodcut.description,
            'imageUrl': prodcut.imageUrl,
            'price': prodcut.price,
            'creatorId': userId,
          }));

      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: prodcut.title,
          description: prodcut.description,
          price: prodcut.price,
          imageUrl: prodcut.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
    // return error;
  }

  Future<void> updateProduct(String id, Product newProdcut) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    var params = {
      'auth': authToken,
    };

    if (prodIndex >= 0) {
      final url = Uri.https(
          'shop-app-flutter-5c717-default-rtdb.firebaseio.com',
          '/products/$id.json',
          params);
      await http.patch(url,
          body: json.encode({
            'title': newProdcut.title,
            'description': newProdcut.description,
            'imageUrl': newProdcut.imageUrl,
            'price': newProdcut.price
          }));
      _items[prodIndex] = newProdcut;
      notifyListeners();
    } else {}
  }

  Future<void> deleteProduct(String id) async {
    var params = {
      'auth': authToken,
    };

    final url = Uri.https('shop-app-flutter-5c717-default-rtdb.firebaseio.com',
        '/products/$id.json', params);

    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw CustomHttpException('Could not delete product.');
    }
    existingProduct = null;
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }
}
