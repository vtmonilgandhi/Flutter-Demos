import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'product_item.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Products productsData = Provider.of<Products>(context);
    final products = productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemBuilder: (ctx, i) => ProductItem(
          id: products[i].id,
          title: products[i].title,
          imageUrl: products[i].imageUrl),
      itemCount: products.length,
    );
  }
}
