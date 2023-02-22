import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './screens/products_overview_screen.dart';
import 'package:provider/provider.dart';

import './screens/product_detail_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './screens/cart_screen.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => Products())),
        ChangeNotifierProvider(create: ((context) => Cart())),
        ChangeNotifierProvider(create: ((context) => Orders()))
      ],
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          brightness: Brightness.dark,
          fontFamily: GoogleFonts.lato().fontFamily,
          primarySwatch: Colors.blue,
          textTheme: TextTheme(
            bodyLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        darkTheme: ThemeData.dark(),
        home: ProducsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
          CartScreen.routeName: ((context) => CartScreen()),
          OrdersScreen.routeName: ((context) => OrdersScreen())
        },
      ),
    );
  }
}
