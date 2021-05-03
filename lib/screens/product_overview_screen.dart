import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_management/providers/badge.dart';
import 'package:shop_management/providers/cart.dart';
import 'package:shop_management/providers/products_provider.dart';
import 'package:shop_management/widgets/app_drawer.dart';
import 'package:shop_management/widgets/products_grid.dart';

enum FilterOptions {
  Favourites,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var showOnlyFavourites = false;
  var isLoading = false;
  var isInit = true;

  @override
  void didChangeDependencies() {
    setState(() {
      isLoading = true;
    });
    if (isInit)
      Provider.of<Products>(context).fetchAndSet().then((value) {
        setState(() {
          isLoading = false;
        });
      });
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My shop'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favourites'),
                value: FilterOptions.Favourites,
              ),
              PopupMenuItem(
                child: Text('Show all'),
                value: FilterOptions.All,
              ),
            ],
            onSelected: (selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favourites)
                  showOnlyFavourites = true;
                else
                  showOnlyFavourites = false;
              });
            },
          ),
          Consumer<Cart>(
            builder: (_, cartData, ch) => Badge(
              child: ch,
              value: cartData.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {},
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(showOnlyFavourites),
    );
  }
}
