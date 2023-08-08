import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/home/model/product.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../model/hive_product.dart';

class ProductProvider with ChangeNotifier {
  get isVisible => _isVisible;
  bool _isVisible = false;
  set isVisible(value) {
    _isVisible = value;
    notifyListeners();
  }

  bool _cpasswordVisible = false;

  bool get cpasswordVisible => _cpasswordVisible;

  set cpasswordVisible(value) {
    _cpasswordVisible = value;
    notifyListeners();
  }

  bool _isLoading = false;
  bool _isLoadingDetail = false;
  List<ProductsModel> _products = [];

  bool get isLoading => _isLoading;

  bool get isLoadingDetail => _isLoadingDetail;
  List<ProductsModel> get products => _products;

  List<ProductsModel> _filteredProducts = [];

  List<ProductsModel> get filteredProducts => _filteredProducts;

  List<ProductsModel> _productDetails = [];
  List<ProductsModel> get productDetails => _productDetails;

  Set<int> _wishlist = {};

  Set<int> get wishlist => _wishlist;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response =
          await http.get(Uri.parse('https://fakestoreapi.com/products'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        _products =
            data.map((product) => ProductsModel.fromJson(product)).toList();

        _isLoading = false;
        notifyListeners();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      Fluttertoast.showToast(
        msg: 'Some Exception Occur',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      // throw error;
    }
  }

  Future<void> fetchProductsDetails(int productId) async {
    _isLoadingDetail = true;
    notifyListeners();

    try {
      final response = await http
          .get(Uri.parse('https://fakestoreapi.com/products/$productId'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final product = ProductsModel.fromJson(data);
        _productDetails = [product]; // Separate list for product details
        _isLoading = false;
        notifyListeners();
      } else {
        throw Exception('Failed to load product details');
      }
    } catch (error) {
      _isLoadingDetail = false;
      notifyListeners();
      Fluttertoast.showToast(
        msg: 'Some Exception Occur',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  void clearProductDetails() {
    _productDetails.clear();
    notifyListeners();
  }

  void searchProducts(String query) {
    if (query.isEmpty) {
      _filteredProducts = List.from(_products);
    } else {
      _filteredProducts = _products
          .where((product) =>
              product.title!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

//Hive
  Box<Product>? _cartBox;

  Future<void> openCartBox() async {
    _cartBox ??= await Hive.openBox<Product>('cart');
  }

  Future<void> addToCart(ProductsModel productModel) async {
    final productId = productModel.id;

    if (_cartBox == null) {
      await openCartBox();
    }

    if (_cartBox!.values.any((product) => product.id == productId)) {
      Fluttertoast.showToast(
        msg: 'Product is already in the cart',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } else {
      final product = Product(
          id: productModel.id!,
          title: productModel.title!,
          price: productModel.price!,
          image: productModel.image!,
          ratingCount: productModel.rating!.rate!);

      _cartBox!.add(product);
      Fluttertoast.showToast(
        msg: 'Product added to cart',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    }
    notifyListeners();
  }

  void removeFromCart(Product product) async {
    if (_cartBox == null) {
      await openCartBox();
    }

    final productId = product.id;

    // Find the index of the product with matching ID in the cart
    final indexToRemove = _cartBox!.values
        .toList()
        .indexWhere((cartProduct) => cartProduct.id == productId);

    if (indexToRemove != -1) {
      // Remove the product at the identified index
      _cartBox!.deleteAt(indexToRemove);
      Fluttertoast.showToast(
        msg: 'Product removed from cart',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      notifyListeners(); // Notify listeners after successful removal
    } else {
      // Product not found in cart
      Fluttertoast.showToast(
        msg: 'Product not found in cart',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  int get cartItemCount {
    if (_cartBox == null) {
      return 0; // Return 0 if the cart box hasn't been opened yet
    }
    return _cartBox!.length; // Return the length of the cart box
  }

  void toggleWishlist(int productId) {
    if (_wishlist.contains(productId)) {
      _wishlist.remove(productId);
      Fluttertoast.showToast(
        msg: 'Product removed from wishlist',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } else {
      _wishlist.add(productId);
      Fluttertoast.showToast(
        msg: 'Product added to wishlist',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    }
    notifyListeners();
  }
}
