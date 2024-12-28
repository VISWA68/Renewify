import 'package:Renewify/main.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'cart.dart';
import 'shoplocation.dart';
import 'package:Renewify/gen_l10n/app_localizations.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  List<Product> cartItems = [];
  Set<Product> favoriteItems = {};

  void addToCart(Product product) {
    setState(() {
      // Check if the product is already in the cart
      if (cartItems.contains(product)) {
        // Increment the quantity of the product
        product.quantity++;
      } else {
        // Add the product to the cart with an initial quantity of 1
        product.quantity = 1;
        cartItems.add(product);
      }
    });
  }

  void toggleFavorite(Product product) {
    setState(() {
      if (favoriteItems.contains(product)) {
        favoriteItems.remove(product);
      } else {
        favoriteItems.add(product);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Initialize productList with localized titles
    List<Product> productList = [
      Product(
        image: 'assets/images/hybrid.jpg',
        title: AppLocalizations.of(context)!.inverter,
      ),
      Product(
        image: 'assets/images/charge.jpg',
        title: AppLocalizations.of(context)!.charge,
      ),
      Product(
        image: 'assets/images/batteries.jpeg',
        title: AppLocalizations.of(context)!.battery,
      ),
      Product(
        image: 'assets/images/wall.jpg',
        title: AppLocalizations.of(context)!.wall_solar,
      ),
      Product(
        image: 'assets/images/biocyl.jpeg',
        title: AppLocalizations.of(context)!.cylinder,
      ),
      Product(
        image: 'assets/images/manure.jpeg',
        title: AppLocalizations.of(context)!.manure,
      ),
    ];

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text(
                'RENEWIFY',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.energy),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(cartItems: cartItems),
                ),
              );
            },
          ),
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search . . .',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/go_green.jpg',
                            height: constraints.maxWidth < 600 ? 60 : 80,
                            width: constraints.maxWidth < 600 ? 60 : 80,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.shop_title,
                                  style: TextStyle(
                                    fontSize: constraints.maxWidth < 600 ? 16 : 20,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  AppLocalizations.of(context)!.shop_para,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: constraints.maxWidth < 600 ? 2 : 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: productList.length,
                        itemBuilder: (context, index) {
                          return ProductItem(
                            product: productList[index],
                            onAddToCart: addToCart,
                            onToggleFavorite: toggleFavorite,
                            isFavorite: favoriteItems.contains(productList[index]),
                            quantity: productList[index].quantity,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final Product product;
  final Function(Product) onAddToCart;
  final Function(Product) onToggleFavorite;
  final bool isFavorite;
  final int quantity;

  const ProductItem({
    Key? key,
    required this.product,
    required this.onAddToCart,
    required this.onToggleFavorite,
    required this.isFavorite,
    required this.quantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 4,
            child: Image.asset(
              product.image,
              height: 80,
              width: 80,
            ),
          ),
          SizedBox(height: 5),
          Flexible(
            flex: 2,
            child: Text(
              product.title,
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(height: 3),
          Text(
            'Quantity: $quantity',  // Display the quantity
            style: TextStyle(fontSize: 14, color: Colors.green),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: isFavorite ? Colors.red : Colors.grey, // Toggle color
                ),
                onPressed: () => onToggleFavorite(product),
              ),
              IconButton(
                icon: Icon(Icons.add_shopping_cart_rounded),
                onPressed: () => onAddToCart(product),
              ),
            ],
          ),
          Flexible(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Market(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 158, 247, 161),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(AppLocalizations.of(context)!.shop_now),
            ),
          ),
        ],
      ),
    );
  }
}

class Product {
  final String image;
  final String title;
  int quantity;

  Product({required this.image, required this.title, this.quantity = 0});
}
