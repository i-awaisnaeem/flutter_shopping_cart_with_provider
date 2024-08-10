import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart ' as badges;
import 'package:shopping_cart/cart_model.dart';
import 'package:shopping_cart/db_helper.dart';
import 'cart_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  // Create an instance of DbHelper to interact with the SQLite database.
  DbHelper? dbHelper = DbHelper();

  @override
  Widget build(BuildContext context) {
    // Access the CartProvider using Provider.of to manage the cart state.
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Products'),
        actions: [
          // Badge showing the number of items in the cart.
          Center(
            child: badges.Badge(
              // Badge content is the cart item count, updated via Consumer.
              badgeContent: Consumer<CartProvider>(
                builder: (context, value, child) {
                  return Text(
                    value.getCounter().toString(),
                    style: const TextStyle(color: Colors.white),
                  );
                },
              ),
              // Shopping cart icon with badge.
              child: const Icon(Icons.shopping_bag_outlined),
              badgeAnimation: const badges.BadgeAnimation.fade(
                animationDuration: Duration(milliseconds: 300),
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      // Main body of the screen.
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // FutureBuilder to handle async data retrieval from the database.
            FutureBuilder(
              // Fetch cart data from the database.
                future: cart.getData(),
                builder: (context, AsyncSnapshot<List<CartModel>> snapshot){

                  // If the cart is empty, display an empty cart image and message.
                  if (snapshot.data!.isEmpty){
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage('images/empty_cart.png'),
                          ),
                          SizedBox(height: 20,),
                          Text('Cart is empty'),
                        ],
                      ),
                    );
                  }
                  // If the cart has items, display them in a list.
                  else {
                    return Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          // Display product image.
                                          Image(
                                              fit: BoxFit.cover,
                                              height: 100,
                                              width: 100,
                                              image: NetworkImage(
                                                snapshot.data![index].image
                                                    .toString(),
                                              )),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          // Display product details.
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    // Product name.
                                                    Text(
                                                      snapshot.data![index]
                                                          .productName
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight
                                                              .w500),
                                                    ),
                                                    // Delete icon to remove item from cart.
                                                    InkWell(
                                                        onTap: () {
                                                          // Delete item from database and update cart.
                                                          dbHelper!.delete(
                                                              snapshot
                                                                  .data![index]
                                                                  .id!);
                                                          cart.removeCounter();
                                                          cart.removeTotalPrice(
                                                              double.parse(
                                                                  snapshot
                                                                      .data![index]
                                                                      .productPrice
                                                                      .toString()));
                                                        },
                                                        child: const Icon(
                                                            Icons.delete)),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                // Display product unit and price.
                                                Text(
                                                  snapshot.data![index].unitTag
                                                      .toString() +
                                                      '  ' +
                                                      r'$' +
                                                      snapshot.data![index]
                                                          .productPrice
                                                          .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight
                                                          .w500),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                // Quantity adjustment controls (add/remove buttons).
                                                Align(
                                                  alignment: Alignment.centerRight,
                                                  child: InkWell(
                                                    onTap: () {
                                                      // Additional actions can be defined here if needed.
                                                    },
                                                    child: Container(
                                                      height: 35,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                          color: Colors.green,
                                                          borderRadius:
                                                          BorderRadius.circular(5)),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(4.0),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            // Decrease quantity button.
                                                            InkWell(
                                                                onTap: () {
                                                                  int quantity = snapshot
                                                                      .data![index]
                                                                      .quantity!;
                                                                  int price = snapshot
                                                                      .data![index]
                                                                      .initialPrice!;
                                                                  quantity--;
                                                                  int? newPrice = price *
                                                                      quantity;

                                                                  // If quantity is greater than 0, update the database.
                                                                  if (quantity > 0) {
                                                                    dbHelper!
                                                                        .updateQuantity(
                                                                        CartModel(
                                                                            id: snapshot
                                                                                .data![index]
                                                                                .id!,
                                                                            productId: snapshot
                                                                                .data![index]
                                                                                .id!
                                                                                .toString(),
                                                                            initialPrice: snapshot
                                                                                .data![index]
                                                                                .initialPrice!,
                                                                            productPrice: newPrice,
                                                                            quantity: quantity,
                                                                            productName: snapshot
                                                                                .data![index]
                                                                                .productName!,
                                                                            unitTag: snapshot
                                                                                .data![index]
                                                                                .unitTag
                                                                                .toString(),
                                                                            image: snapshot
                                                                                .data![index]
                                                                                .image
                                                                                .toString())
                                                                    ).then((
                                                                        value) {
                                                                      // Reset the price and quantity variables.
                                                                      newPrice = 0;
                                                                      quantity = 0;
                                                                      cart
                                                                          .removeTotalPrice(
                                                                          double
                                                                              .parse(
                                                                              snapshot
                                                                                  .data![index]
                                                                                  .initialPrice!
                                                                                  .toString()));
                                                                    }).onError((
                                                                        error,
                                                                        stackTrace) {
                                                                      print(
                                                                          error
                                                                              .toString());
                                                                    });
                                                                  }
                                                                },
                                                                child: const Icon(
                                                                  Icons.remove,
                                                                  color: Colors
                                                                      .white,)),
                                                            // Display current quantity.
                                                            Text(
                                                              snapshot
                                                                  .data![index]
                                                                  .quantity
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            // Increase quantity button.
                                                            InkWell(
                                                                onTap: () {
                                                                  int quantity = snapshot
                                                                      .data![index]
                                                                      .quantity!;
                                                                  int price = snapshot
                                                                      .data![index]
                                                                      .initialPrice!;
                                                                  quantity++;
                                                                  int? newPrice = price *
                                                                      quantity;

                                                                  // Update the database with the new quantity and price.
                                                                  dbHelper!
                                                                      .updateQuantity(
                                                                      CartModel(
                                                                          id: snapshot
                                                                              .data![index]
                                                                              .id!,
                                                                          productId: snapshot
                                                                              .data![index]
                                                                              .id!
                                                                              .toString(),
                                                                          initialPrice: snapshot
                                                                              .data![index]
                                                                              .initialPrice!,
                                                                          productPrice: newPrice,
                                                                          quantity: quantity,
                                                                          productName: snapshot
                                                                              .data![index]
                                                                              .productName!,
                                                                          unitTag: snapshot
                                                                              .data![index]
                                                                              .unitTag
                                                                              .toString(),
                                                                          image: snapshot
                                                                              .data![index]
                                                                              .image
                                                                              .toString())
                                                                  ).then((
                                                                      value) {
                                                                    // Reset the price and quantity variables.
                                                                    newPrice = 0;
                                                                    quantity = 0;
                                                                    cart
                                                                        .addTotalPrice(
                                                                        double
                                                                            .parse(
                                                                            snapshot
                                                                                .data![index]
                                                                                .initialPrice!
                                                                                .toString()));
                                                                  }).onError((
                                                                      error,
                                                                      stackTrace) {
                                                                    print(error
                                                                        .toString());
                                                                  });
                                                                },
                                                                child: const Icon(
                                                                  Icons.add,
                                                                  color: Colors
                                                                      .white,))
                                                          ],
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
                            }));
                  }
                }),
            // Display the cart total price if it's not zero.
            Consumer<CartProvider>(builder: (context, value,child){
              return Visibility(
                visible: value.getTotalPrice().toStringAsFixed(2) == '0.00'? false : true,
                child: Column(
                  children: [
                    ReuseableWidget(
                        value: r'$' + value.getTotalPrice().toStringAsFixed(2),
                        title: 'Sub Total'),
                    const ReuseableWidget(
                        value: r'$' + '10',
                        title: 'Cash Voucher'),
                    ReuseableWidget(
                        value: r'$' + value.getTotalPrice().toStringAsFixed(2),
                        title: 'Total')
                  ],
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}

// ReuseableWidget is used to display the cart's subtotal, cash voucher, and total amount.
class ReuseableWidget extends StatelessWidget {

  final String title, value;
  const ReuseableWidget({super.key, required this.value, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall),
          Text(value.toString(), style: Theme.of(context).textTheme.titleSmall),
        ],
      ),
    );
  }
}
