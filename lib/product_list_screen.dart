import 'dart:async';  // Importing the async library for asynchronous programming.

import 'package:flutter/material.dart';  // Importing Flutter material design package.
import 'package:badges/badges.dart' as badges;  // Importing the badges package for displaying badges.
import 'package:provider/provider.dart';  // Importing provider for state management.
import 'package:shopping_cart/cart_model.dart';  // Importing the cart model.
import 'package:shopping_cart/cart_provider.dart';  // Importing the cart provider for managing cart state.
import 'package:shopping_cart/cart_screen.dart';  // Importing the cart screen.
import 'package:shopping_cart/db_helper.dart';  // Importing database helper class for managing SQLite operations.

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  DbHelper? dbHelper = DbHelper();  // Instance of the database helper class.

  // List of product names.
  List<String> productName = [
    'Mango',
    'Orange',
    'Grapes',
    'Banana',
    'Chery',
    'Peach',
    'Mixed Fruit ',
  ];

  // List of product units.
  List<String> productUnit = [
    'KG',
    'Dozen',
    'KG',
    'Dozen',
    'KG',
    'KG',
    'KG',
  ];

  // List of product prices.
  List<int> productPrice = [10, 20, 30, 40, 50, 60, 70];

  // List of product images.
  List<String> productImage = [
    'https://image.shutterstock.com/image-photo/mango-isolated-on-white-background-600w-610892249.jpg',
    'https://image.shutterstock.com/image-photo/orange-fruit-slices-leaves-isolated-600w-1386912362.jpg',
    'https://image.shutterstock.com/image-photo/green-grape-leaves-isolated-on-600w-533487490.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQIK_2nxGVrbPMKwSqwTBPAJhVHAulNqs_Jhg&s',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQPB8EPJ7RtNExqJ8xDqlaibAmM2zNiCo30WA&s',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT1hsbaFvOU0UVPnk6R_qorPRgSqQVM4ipSXQ&s',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSsrn37Q9JXE_-Xt0wIbzuGi_QiKhcUErHtyA&s',
  ];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);  // Accessing the cart provider.

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products list'),  // Title of the app bar.
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen()));  // Navigate to cart screen when tapped.
            },
            child: Center(
              child: badges.Badge(
                badgeContent: Consumer<CartProvider>(
                  builder: (context, value, child) {
                    return Text(
                      value.getCounter().toString(),  // Display the number of items in the cart.
                      style: const TextStyle(color: Colors.white),
                    );
                  },
                ),
                child: const Icon(Icons.shopping_bag_outlined),  // Shopping cart icon.
                badgeAnimation: const badges.BadgeAnimation.fade(
                  animationDuration: Duration(milliseconds: 300),  // Animation duration for badge.
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 20,  // Space between the badge and the edge of the app bar.
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: productName.length,  // Number of products in the list.
                  itemBuilder: (context, index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),  // Padding inside the card.
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Image(
                                  fit: BoxFit.cover,
                                  height: 100,
                                  width: 100,
                                  image: NetworkImage(
                                    productImage[index].toString(),  // Display product image.
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,  // Space between the image and the text.
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        productName[index].toString(),  // Display product name.
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,  // Space between product name and unit/price.
                                      ),
                                      Text(
                                        productUnit[index].toString() +
                                            '  ' +
                                            r'$' +
                                            productPrice[index].toString(),  // Display product unit and price.
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,  // Space between unit/price and the add to cart button.
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: InkWell(
                                          onTap: () {
                                            // Insert product into the database and update the cart.
                                            dbHelper!
                                                .insert(CartModel(
                                                id: index,
                                                productId: index.toString(),
                                                productName: productName[index].toString(),
                                                initialPrice: productPrice[index],
                                                productPrice: productPrice[index],
                                                quantity: 1,
                                                unitTag: productUnit[index].toString(),
                                                image: productImage[index].toString()
                                            ))
                                                .then((value) {
                                              cart.addCounter();  // Increment the cart counter.
                                              cart.addTotalPrice(productPrice[index].toDouble());  // Update the total price in the cart.
                                              print('Product is added to cart');  // Debugging message.
                                            }).onError((error, stackTrace) {
                                              print(error.toString());  // Print error if insertion fails.
                                            });
                                          },
                                          child: Container(
                                            height: 35,
                                            width: 100,
                                            decoration: BoxDecoration(
                                                color: Colors.green,  // Background color of the add to cart button.
                                                borderRadius: BorderRadius.circular(5)  // Rounded corners for the button.
                                            ),
                                            child: const Center(
                                              child: Text(
                                                'Add to cart',  // Text inside the add to cart button.
                                                style: TextStyle(
                                                    color: Colors.white
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }
              )
          )
        ],
      ),
    );
  }
}
