import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/cart_provider.dart';
import 'package:shopping_cart/product_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => CartProvider(), // Providing the CartProvider to the entire widget tree.
    child: Builder(builder: (BuildContext){
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            appBarTheme: const AppBarTheme(
                foregroundColor: Colors.white,
                centerTitle: true,
                backgroundColor: Colors.blueAccent,
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                )
            )
        ),
        home: const ProductListScreen(),
      );
    }),);
  }
}

