import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/cart_screen.dart';
import 'package:flutter_complete_guide/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../providers/products.dart';

enum Filters { Favorites, all }

class ProducsOverviewScreen extends StatefulWidget {
  @override
  State<ProducsOverviewScreen> createState() => _ProducsOverviewScreenState();
}

class _ProducsOverviewScreenState extends State<ProducsOverviewScreen> {
  bool _showOnlyFavorites = false;
  bool _isInit = true;

  @override
  void initState() {
    //Provider.of<Products>(context).fetchAndSetProducts(); werkt niet
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<Products>(context).fetchAndSetProducts();
    }
    _isInit = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My shop'),
        actions: [
          PopupMenuButton(
            onSelected: (Filters selectedVal) {
              setState(() {
                if (selectedVal == Filters.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: Filters.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show all'),
                value: Filters.all,
              ),
            ],
            icon: Icon(Icons.more_vert),
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: ProducstGrid(_showOnlyFavorites),
    );
  }
}
