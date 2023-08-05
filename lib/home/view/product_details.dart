import 'package:badges/badges.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/home/view/widget/wheter_container.dart';
import 'package:flutter_application_1/utils/colors.dart';
import 'package:flutter_application_1/widget/button.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../controller/product_controller.dart';
import '../model/hive_product.dart';
import 'cart_view.dart';

class ProductDetailView extends StatefulWidget {
  int productId;
  ProductDetailView({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  @override
  void initState() {
    super.initState();
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    // Add a method to clear _productDetails
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      productProvider.clearProductDetails();
      productProvider.fetchProductsDetails(widget.productId);
    });
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    final cartBox = Hive.box<Product>('cart');

    return Visibility(
      visible: cartBox.length > 0,
      child: FloatingActionButton(
        backgroundColor: darkGreenColor,
        child: badges.Badge(
          badgeStyle: const BadgeStyle(badgeColor: Colors.red),
          badgeContent: Text(
            '${cartBox.length}',
            style: TextStyle(color: Colors.white),
          ),
          child: const Icon(
            Icons.shopping_bag_outlined,
            color: Colors.white,
          ),
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CartScreen();
          }));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(builder: (context, productProvider, _) {
      return Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: _buildFloatingActionButton(context),
          persistentFooterButtons: [
            (productProvider.isLoadingDetail &&
                    productProvider.productDetails.isEmpty)
                ? const SizedBox()
                : Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: darkGreenColor, width: 2),
                            borderRadius: BorderRadius.circular(6)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.message_outlined),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Button(
                            backgroundColor: darkGreenColor,
                            label: 'Add to Cart',
                            onPressed: () {
                              productProvider
                                  .addToCart(productProvider.productDetails[0]);
                            }),
                      ),
                    ],
                  )
          ],
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Column(
                children: [
                  if (productProvider.isLoadingDetail &&
                      productProvider.productDetails.isEmpty)
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.67,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (productProvider.productDetails.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Image.network(
                              productProvider.productDetails[0].image!,
                              fit: BoxFit.contain,
                              height: MediaQuery.of(context).size.height * 0.38,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  productProvider.productDetails[0].title!,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const Icon(Icons.share),
                              const SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  productProvider.toggleWishlist(
                                      productProvider.productDetails[0].id!);
                                },
                                child: Icon(
                                  productProvider.wishlist.contains(
                                          productProvider.productDetails[0].id)
                                      ? CupertinoIcons.heart_fill
                                      : CupertinoIcons.heart,
                                  color: productProvider.wishlist.contains(
                                          productProvider.productDetails[0].id)
                                      ? Colors.red
                                      : null,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            productProvider.productDetails[0].category!,
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          WhetherContainer(),
                          SizedBox(
                            height: 10,
                          ),
                          const Divider(
                            thickness: 1,
                          ),
                          const Text(
                            'Description',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            productProvider.productDetails[0].description!,
                            style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Text(
                                'Price',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '\$${productProvider.productDetails[0].price!.toString()}',
                                style: TextStyle(
                                    color: darkGreenColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(children: [
                            Row(
                              children: [
                                RatingBar.builder(
                                  itemSize: 18,
                                  initialRating: productProvider
                                      .productDetails[0].rating!.rate!
                                      .toDouble(),
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
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              '${productProvider.productDetails[0].rating!.rate!.toString()} of 5',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Based on ${productProvider.productDetails[0].rating!.count.toString()}+ reviews',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade700),
                            )
                          ]),
                        ],
                      ),
                    )
                ],
              ),
            ),
          ));
    });
  }
}
