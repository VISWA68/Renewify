import 'package:Renewify/main.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'shop.dart';

class CartPage extends StatefulWidget {
  final List<Product> cartItems;

  const CartPage({Key? key, required this.cartItems}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Map<Product, int> productCount = {};

  @override
  void initState() {
    super.initState();
    widget.cartItems.forEach((product) {
      if (productCount.containsKey(product)) {
        productCount[product] = productCount[product]! + 1;
      } else {
        productCount[product] = 1;
      }
    });
  }

  void _increaseCount(Product product) {
    setState(() {
      productCount[product] = productCount[product]! + 1;
    });
  }

  void _decreaseCount(Product product) {
    setState(() {
      if (productCount[product] == 1) {
        productCount.remove(product);
      } else {
        productCount[product] = productCount[product]! - 1;
      }
    });
  }

  void _removeProduct(Product product) {
    setState(() {
      productCount.remove(product);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        backgroundColor: Colors.green,
        actions: [
          PopupMenuButton<String>(
            icon: FaIcon(FontAwesomeIcons.globe),
            onSelected: (String value) {
              if (value == 'en') {
                MyApp.of(context)!.setLocale(const Locale('en'));
              } else if (value == 'ta') {
                MyApp.of(context)!.setLocale(const Locale('ta'));
              } else if(value =='hi'){
                MyApp.of(context)!.setLocale(const Locale('hi'));
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'en',
                child: Text('English'),
              ),
              const PopupMenuItem<String>(
                value: 'ta',
                child: Text('Tamil'),
              ),
              const PopupMenuItem<String>(
                value: 'hi',
                child: Text('Hindi'),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(12.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 2.0),
          ),
        ),
      ),
      body: productCount.isEmpty
          ? Center(child: Text('Your cart is empty'))
          : ListView.builder(
              itemCount: productCount.length,
              itemBuilder: (context, index) {
                Product product = productCount.keys.elementAt(index);
                int count = productCount[product]!;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Image.asset(product.image),
                      title: Text(product.title),
                      subtitle: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () => _decreaseCount(product),
                          ),
                          Text('$count'),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () => _increaseCount(product),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeProduct(product),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}