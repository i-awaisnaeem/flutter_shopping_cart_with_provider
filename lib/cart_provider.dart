import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_cart/db_helper.dart';
import 'cart_model.dart';

class CartProvider with ChangeNotifier {
  // Initialize the database helper instance to interact with the SQLite database.
  DbHelper db = DbHelper();

  // Private variables for cart item count and total price.
  int _counter = 0;
  double _totalPrice = 0;

  // Getter for cart item count.
  int get counter => _counter;

  // Getter for total price.
  double get totalPrice => _totalPrice;

  // Future for holding the cart data.
  late Future<List<CartModel>> _cart;

  // Getter for cart data.
  Future<List<CartModel>> get cart => _cart;

  // Method to fetch data from the database.
  Future<List<CartModel>> getData() async {
    _cart = db.getCartList();
    return _cart;
  }

  // Save the cart item count and total price to shared preferences.
  void _setPrefItems() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt('cart_items', _counter);
    preferences.setDouble('total_price', _totalPrice);
    notifyListeners(); // Notify listeners to update the UI.
  }

  // Retrieve the cart item count and total price from shared preferences.
  void _getPrefItems() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _counter = preferences.getInt('cart_items') ?? 0; // Default to 0 if not found.
    _totalPrice = preferences.getDouble('total_price') ?? 0.0; // Default to 0.0 if not found.
    notifyListeners(); // Notify listeners to update the UI.
  }

  // Increment the cart item count and update shared preferences.
  void addCounter() {
    _counter++;
    _setPrefItems(); // Save the updated count to shared preferences.
    notifyListeners(); // Notify listeners to update the UI.
  }

  // Decrement the cart item count and update shared preferences.
  void removeCounter() {
    _counter--;
    _setPrefItems(); // Save the updated count to shared preferences.
    notifyListeners(); // Notify listeners to update the UI.
  }

  // Retrieve the cart item count from shared preferences.
  int getCounter() {
    _getPrefItems(); // Get the current count from shared preferences.
    return _counter; // Return the current count.
  }

  // Add to the total price and update shared preferences.
  void addTotalPrice(double productPrice) {
    _totalPrice += productPrice; // Increase the total price by the product price.
    _setPrefItems(); // Save the updated total price to shared preferences.
    notifyListeners(); // Notify listeners to update the UI.
  }

  // Subtract from the total price and update shared preferences.
  void removeTotalPrice(double productPrice) {
    _totalPrice -= productPrice; // Decrease the total price by the product price.
    _setPrefItems(); // Save the updated total price to shared preferences.
    notifyListeners(); // Notify listeners to update the UI.
  }

  // Retrieve the total price from shared preferences.
  double getTotalPrice() {
    _getPrefItems(); // Get the current total price from shared preferences.
    return _totalPrice; // Return the current total price.
  }
}
