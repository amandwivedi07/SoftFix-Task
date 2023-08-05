import 'package:flutter/material.dart';
import 'package:flutter_application_1/home/model/product.dart';
import 'package:flutter_application_1/home/view/product_details.dart';

import '../../../utils/colors.dart';

class ProductCard extends StatelessWidget {
  final ProductsModel product;
  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            Image.network(
              product.image!,
              fit: BoxFit.cover,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                return child;
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return Container(
                    height: 100,
                    width: 100,
                    color: Colors.grey.shade100,
                  );
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                    child: Text(
                  product.title!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${product.price!.toString()}',
                  style: TextStyle(
                      fontSize: 17,
                      color: darkGreenColor,
                      fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ProductDetailView(
                        productId: product.id!,
                      );
                    }));
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: darkGreenColor,
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      )),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}
