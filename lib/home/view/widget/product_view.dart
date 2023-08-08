import 'package:flutter/material.dart';
import 'package:flutter_application_1/home/view/widget/product_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../../controller/product_provider.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      productProvider.fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, _) {
        return productProvider.isLoading
            ? SizedBox(
                height: MediaQuery.of(context).size.height * 0.53,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : MasonryGridView.builder(
                shrinkWrap: true,
                primary: false,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                itemCount: productProvider.filteredProducts.isNotEmpty
                    ? productProvider.filteredProducts.length
                    : productProvider.products.length,
                itemBuilder: (context, index) {
                  final product = productProvider.filteredProducts.isNotEmpty
                      ? productProvider.filteredProducts[index]
                      : productProvider.products[index];

                  return ProductCard(
                    product: product,
                  );
                },
                gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2));
      },
    );
  }
}
