import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../utils/colors.dart';
import '../controller/product_controller.dart';

class WishlistScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(elevation: 0, centerTitle: true, title: Text('Your WishList')),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, _) {
          return productProvider.wishlist.isEmpty
              ? Center(
                  child: Text('Your Wishlist is Empty'),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10),
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 20,
                    ),
                    itemCount: productProvider.wishlist.length,
                    itemBuilder: (context, index) {
                      final productId =
                          productProvider.wishlist.elementAt(index);
                      final product = productProvider.products.firstWhere(
                        (p) => p.id == productId,
                        orElse: () => null!,
                      );

                      if (product != null) {
                        return Container(
                          decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(8)),
                          child: ListTile(
                            leading: Image.network(
                              product.image!,
                              fit: BoxFit.contain,
                              height: 60,
                              width: 60,
                            ),
                            title: Text(
                              product.title!,
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
                                          product.rating!.rate!.toDouble(),
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
                                productProvider.toggleWishlist(productId);
                              },
                            ),
                          ),
                        );

                        //    ListTile(
                        //     leading: Image.network(
                        //       product.image!,
                        //       fit: BoxFit.contain,
                        //     ),
                        //     trailing: GestureDetector(
                        //       onTap: () {
                        //         productProvider.toggleWishlist(productId);
                        //       },
                        //       child: Icon(Icons.delete),
                        //     ),
                        //     title: Text(product.title!),
                        //     subtitle: Text('\$${product.price}'),
                        //   );
                        // } else {
                        //   return ListTile(
                        //     title: Text('Invalid Product'), // Display a placeholder
                        //   );
                      }
                    },
                  ),
                );
        },
      ),
    );
  }
}
