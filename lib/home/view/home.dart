import 'package:badges/badges.dart' as badges;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/home/view/widget/product_view.dart';
import 'package:flutter_application_1/home/view/wishlist_view.dart';
import 'package:flutter_application_1/widget/app_drawer.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../controller/product_provider.dart';
import '../model/hive_product.dart';
import 'cart_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      drawer: AppDrawer(),
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.green.shade900,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return WishlistScreen();
              }));
            },
            icon: const Icon(CupertinoIcons.heart),
          ),
          Consumer<ProductProvider>(builder: (context, productProvider, _) {
            final cartBox = Hive.box<Product>('cart');
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return CartScreen();
                  }));
                },
                icon: badges.Badge(
                    badgeStyle: const badges.BadgeStyle(badgeColor: Colors.red),
                    badgeContent: Text(
                      cartBox.length.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                    child: Icon(Icons.shopping_cart_outlined)),
              ),
            );
          })
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.green.shade900,
                stretch: true,
                onStretchTrigger: () {
                  // Function callback for stretch
                  return Future<void>.value();
                },
                expandedHeight: 140.0,
                flexibleSpace: FlexibleSpaceBar(
                    background: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "Let's Grab Your Favourite Plants",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: SizedBox(
                        height: 44,
                        child: TextField(
                          onChanged: (value) {
                            productProvider.searchProducts(value);
                          },
                          decoration: const InputDecoration(
                            labelText: 'Search',
                            hintText: 'Search for options...',
                            prefixIcon: Icon(Icons.search),
                            filled: true, // Set to true to fill the background
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ))),
            SliverList(delegate: SliverChildListDelegate([ProductView()]))
          ],
        ),
      ),
    );
  }
}
