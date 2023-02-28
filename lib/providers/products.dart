import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    //Product(
    //  id: 'p1',
    //  title: 'Red Shirt',
    //  description: 'A red shirt - it is pretty red!',
    //  price: 29.99,
    //  imageUrl:
    //      'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    //),
    //Product(
    //  id: 'p2',
    //  title: 'Trousers',
    //  description: 'A nice pair of trousers.',
    //  price: 59.99,
    //  imageUrl:
    //      'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    //),
    //Product(
    //  id: 'p3',
    //  title: 'Yellow Scarf',
    //  description: 'Warm and cozy - exactly what you need for the winter.',
    //  price: 19.99,
    //  imageUrl:
    //      'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    //),
    //Product(
    //  id: 'p4',
    //  title: 'A Pan',
    //  description: 'Prepare any meal you want.',
    //  price: 49.99,
    //  imageUrl:
    //      'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    //),
  ];
  //var _showFavoritesOnly = false;
//
  //void showFavoritesOnly() {
  //  _showFavoritesOnly = true;
  //  notifyListeners();
  //}
//
  //void showAll() {
  //  _showFavoritesOnly = false;
  //  notifyListeners();
  //}

  List<Product> get faveItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  List<Product> get items {
    //if (_showFavoritesOnly) {
    //  return _items.where((element) => element.isFavorite).toList();
    //}
    return [..._items];
  }

  Product findById(String Id) {
    return _items.firstWhere((elm) => elm.id == Id);
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.parse(
        'https://flutter-test-fc38f-default-rtdb.europe-west1.firebasedatabase.app/products.json');
    try {
      final response = await http.get(url);
      final data = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProds = [];
      data.forEach((prodId, prodVal) {
        loadedProds.add(Product(
          id: prodId,
          title: prodVal['title'],
          description: prodVal['description'],
          price: prodVal['price'],
          isFavorite: prodVal['isFavorite'],
          imageUrl: prodVal['imageUrl'],
        ));
      });
      _items = loadedProds;
      notifyListeners();
    } catch (err) {
      throw (err);
    }
  }

  Future<void> addProduct(Product prod) async {
    final url = Uri.parse(
        'https://flutter-test-fc38f-default-rtdb.europe-west1.firebasedatabase.app/products.json');

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': prod.title,
          'description': prod.description,
          'imageUrl': prod.imageUrl,
          'price': prod.price,
          'isFavorite': prod.isFavorite,
        }),
      );
      final newProduct = Product(
        title: prod.title,
        description: prod.description,
        imageUrl: prod.imageUrl,
        price: prod.price,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      //_items.insert(0, newProduct); begin of list
      notifyListeners();
    } catch (error) {
      return throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProd) async {
    final index = _items.indexWhere((elm) => elm.id == id);
    if (index >= 0) {
      final url = Uri.parse(
          'https://flutter-test-fc38f-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json');
      await http.patch(url,
          body: json.encode({
            'title': newProd.title,
            'description': newProd.description,
            'imageUrl': newProd.imageUrl,
            'price': newProd.price,
            'isFavorite': newProd.isFavorite,
          }));
      _items[index] = newProd;
      notifyListeners();
    }
  }

  void deleteProd(String id) {
    _items.removeWhere((elm) => elm.id == id);
    notifyListeners();
  }
}
