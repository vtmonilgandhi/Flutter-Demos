import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';

import '../widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({super.key});
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(EditProductScreen.routeName),
              icon: const Icon(Icons.add)),
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: (() => _refreshProducts(context)),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemBuilder: ((_, i) => Column(
                  children: [
                    UserProductItem(
                      id: productsData.items[i].id,
                      imageUrl: productsData.items[i].imageUrl,
                      title: productsData.items[i].title,
                    ),
                    const Divider(),
                  ],
                )),
            itemCount: productsData.items.length,
          ),
        ),
      ),
    );
  }
}
