import 'dart:ffi';
import 'dart:js';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_management/providers/products_provider.dart';
import 'package:shop_management/screens/edit_product_screen.dart';
import 'package:shop_management/widgets/app_drawer.dart';
import 'package:shop_management/widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-screen';
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSet();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('abc'),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              })
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemBuilder: (c, i) => UserProductItem(productsData.items[i].title,
                productsData.items[i].imageUrl, productsData.items[i].id),
            itemCount: productsData.items.length,
          ),
        ),
      ),
    );
  }
}
