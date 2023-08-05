import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/colors.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../controller/product_controller.dart';
import '../model/hive_product.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartBox = Hive.box<Product>('cart');

    return Scaffold(
      appBar: AppBar(centerTitle: true, elevation: 0, title: Text('Your cart')),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, _) {
          return cartBox.isEmpty
              ? const Center(
                  child: Text(
                    'Your cart is empty',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10),
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 20,
                    ),
                    itemCount: cartBox.length,
                    itemBuilder: (context, index) {
                      final product = cartBox.getAt(index);

                      return Container(
                        decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8)),
                        child: ListTile(
                          leading: Image.network(
                            product!.image,
                            fit: BoxFit.contain,
                            height: 60,
                            width: 60,
                          ),
                          title: Text(
                            product.title,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: darkGreenColor),
                            maxLines: 1,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '\$${product.price}',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: darkGreenColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  RatingBar.builder(
                                    itemSize: 18,
                                    initialRating:
                                        product.ratingCount.toDouble(),
                                    minRating: 0,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      size: 10,
                                      color: Colors.orange,
                                    ),
                                    onRatingUpdate: (rating) {
                                      // prinrating);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              productProvider.removeFromCart(product);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
        },
      ),
    );
  }
}
