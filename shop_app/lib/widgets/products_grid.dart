import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showfavs;
  const ProductsGrid({Key? key, required this.showfavs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Products productsData = Provider.of<Products>(context);
    final products = showfavs ? productsData.favoriteItems : productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: const ProductItem(),
      ),
      itemCount: products.length,
    );
  }
}
