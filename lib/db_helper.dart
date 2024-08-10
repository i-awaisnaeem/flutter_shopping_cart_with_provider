import 'package:sqflite/sqflite.dart';  // Importing the sqflite package for database operations.
import 'package:path_provider/path_provider.dart';  // Importing path provider to get the directory path.
import 'dart:io' as io;  // Importing dart:io for file and directory operations.
import 'cart_model.dart';  // Importing the CartModel class.
import 'package:path/path.dart';  // Importing the path package to manipulate file paths.

class DbHelper {
  static Database? _database;  // Static variable to hold the instance of the database.

  // Getter to retrieve the database instance. If it is null, it initializes the database.
  Future<Database?> get db async {
    if (_database != null) {
      return _database!;  // Return the existing database instance.
    }
    _database = await initDatabase();  // Initialize the database if it doesn't exist.
    return _database;  // Return the newly initialized database instance.
  }

  // Method to initialize the database.
  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();  // Get the directory for storing application documents.
    String path = join(documentDirectory.path, 'cart.db');  // Define the path for the database file.
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);  // Open the database and create it if it doesn't exist.
    return db;  // Return the database instance.
  }

  // Method that gets called when the database is being created.
  _onCreate(Database db, int version) async {
    // Execute SQL command to create the 'cart' table.
    await db.execute('CREATE TABLE cart (id INTEGER PRIMARY KEY, productId VARCHAR UNIQUE, productName TEXT,'
        'initialPrice INTEGER, productPrice INTEGER, quantity INTEGER, unitTag TEXT, image TEXT)');
  }

  // Method to insert a new item into the 'cart' table.
  Future<CartModel> insert(CartModel cart) async {
    var dbClient = await db;  // Get the database instance.
    await dbClient!.insert('cart', cart.toMap());  // Insert the cart item into the table.
    return cart;  // Return the inserted cart item.
  }

  // Method to retrieve the list of all items in the 'cart' table.
  Future<List<CartModel>> getCartList() async {
    var dbClient = await db;  // Get the database instance.
    final List<Map<String, Object?>> queryResult = await dbClient!.query('cart');  // Query the 'cart' table.
    return queryResult.map((e) => CartModel.fromMap(e)).toList();  // Convert the query result to a list of CartModel objects.
  }

  // Method to delete an item from the 'cart' table based on its ID.
  Future<int> delete(int id) async {
    var dbClient = await db;  // Get the database instance.
    return await dbClient!.delete('cart', where: 'id = ?', whereArgs: [id]);  // Delete the item with the specified ID.
  }

  // Method to update the quantity of an item in the 'cart' table.
  Future<int> updateQuantity(CartModel cart) async {
    var dbClient = await db;  // Get the database instance.
    return await dbClient!.update('cart', cart.toMap(), where: 'id = ?', whereArgs: [cart.id]);  // Update the item with the specified ID.
  }
}
