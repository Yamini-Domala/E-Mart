import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'product.dart';
import 'product_service.dart';
import 'product_form_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyHome());
}

class MyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Mart',
      theme: ThemeData(
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          titleSmall: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> categories = ['Electronics', 'Clothing', 'Groceries', 'Beauty Products','Books','Pet Supplies','Home and Kitchen','Sports Wear'];
  final List<Map<String, dynamic>> favoriteItems = [];
  final List<Map<String, dynamic>> cartItems = [];

  String? selectedCategory;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _signUserOut() {
    FirebaseAuth.instance.signOut();
  }
  void _toggleFavorite(Map<String, dynamic> item) {
  setState(() {
    if (favoriteItems.contains(item)) {
      favoriteItems.remove(item);
    } else {
      favoriteItems.add(item);
    }
  });
}



  void _addToCart(Map<String, dynamic> item) {
    setState(() {
      var existingItem = cartItems.firstWhere(
          (cartItem) => cartItem['name'] == item['name'],
          orElse: () => {});
      if (existingItem.isNotEmpty) {
        existingItem['quantity'] += 1;
      } else {
        item['quantity'] = 1;
        cartItems.add(item);
      }
    });
  }

  void _removeFromFavorites(Map<String, dynamic> item) {
    setState(() {
      favoriteItems.remove(item);
    });
  }

  void _removeFromCart(Map<String, dynamic> item) {
    setState(() {
      cartItems.remove(item);
    });
  }

  void _increaseQuantity(Map<String, dynamic> item) {
    setState(() {
      item['quantity'] += 1;
    });
  }

  void _decreaseQuantity(Map<String, dynamic> item) {
    setState(() {
      if (item['quantity'] > 1) {
        item['quantity'] -= 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (_selectedIndex) {
      case 1:
        content = FavoritesScreen(
          favoriteItems: favoriteItems,
          removeFromFavorites: _removeFromFavorites,
          addToCart: _addToCart,
        );
        break;
      case 2:
        content = CartScreen(
          cartItems: cartItems,
          removeFromCart: _removeFromCart,
          toggleFavorite: _toggleFavorite,
          increaseQuantity: _increaseQuantity,
          decreaseQuantity: _decreaseQuantity,
        );
        break;
      default:
        content = _buildHomeScreen();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 200, 0, 255),
        centerTitle: true,
        title: const Text('Shop the Best Deals at E-Mart'),
        actions: [
          IconButton(onPressed: _signUserOut, icon: const Icon(Icons.logout))
        ],
      ),
      body: content,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductFormScreen()),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 200, 0, 255),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 200, 0, 255),
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildHomeScreen() {
    return ListView(
      
      padding: const EdgeInsets.all(16.0),
      children: [
        Center(child: Text('Categories', style: Theme.of(context).textTheme.headlineMedium)),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categories
                .map((category) => GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          color: selectedCategory == category
                              ? const Color.fromARGB(255, 187, 33, 243)
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(category,
                            style: TextStyle(
                                color: selectedCategory == category
                                    ? Colors.white
                                    : Colors.black)),
                      ),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 20),
        if (selectedCategory != null) ...[
          Text('$selectedCategory Items',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 10),
          FutureBuilder<List<Product>>(
            future: ProductService().fetchProductsByCategory(selectedCategory!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No items found');
              } else {
                return Column(
                  children: snapshot.data!
                      .map((item) => Card(
                            child: ListTile(
                              leading: Image.network(item.imageUrl),
                              title: Text(item.name),
                              subtitle: Text('₹${item.price}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      favoriteItems.contains(item.toMap())
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: favoriteItems.contains(item.toMap())
                                          ? Colors.red
                                          : null,
                                    ),
                                    onPressed: () => _toggleFavorite(item.toMap()),
                                    
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProductFormScreen(
                                            product: item,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () async {
                                      if (item.id != null) {
                                        await ProductService().deleteProduct(item.id!);
                                      }
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                              onTap: () {
                                _addToCart(item.toMap());
                              },
                            ),
                          ))
                      .toList(),
                );
              }
            },
          ),
        ],
      ],
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> favoriteItems;
  final void Function(Map<String, dynamic>) removeFromFavorites;
  final void Function(Map<String, dynamic>) addToCart;

  const FavoritesScreen({
    super.key,
    required this.favoriteItems,
    required this.removeFromFavorites,
    required this.addToCart,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: favoriteItems
          .map((item) => Card(
                child: ListTile(
                  leading: Image.network(item['imageUrl']),
                  title: Text(item['name']),
                  subtitle: Text('₹${item['price']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => removeFromFavorites(item),
                      ),
                      IconButton(
                        icon: const Icon(Icons.shopping_cart),
                        onPressed: () => addToCart(item),
                      ),
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }
}
class CartScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final void Function(Map<String, dynamic>) removeFromCart;
  final void Function(Map<String, dynamic>) toggleFavorite;
  final void Function(Map<String, dynamic>) increaseQuantity;
  final void Function(Map<String, dynamic>) decreaseQuantity;

  const CartScreen({
    Key? key,
    required this.cartItems,
    required this.removeFromCart,
    required this.toggleFavorite,
    required this.increaseQuantity,
    required this.decreaseQuantity,
  }) : super(key: key);

 

  @override
  Widget build(BuildContext context) {
    final totalAmount = cartItems.fold<double>(0, (sum, item) {
      final price = item['price'] is int ? (item['price'] as int).toDouble() : item['price'] as double;
      return sum + (price * item['quantity']);
    });

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: cartItems
                .map((item) => Card(
                      child: ListTile(
                        leading: Image.network(item['imageUrl']),
                        title: Text(item['name']),
                        subtitle: Text('₹${item['price']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () => decreaseQuantity(item),
                            ),
                            Text('${item['quantity']}'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => increaseQuantity(item),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => removeFromCart(item),
                            ),
                          ],
                        ),
                        onTap: () => toggleFavorite(item),
                      ),
                    ))
                .toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Total Amount: ₹$totalAmount', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Handle proceed to buy action
                  _proceedToBuy(context, cartItems, totalAmount);
                },
                child: const Text('Proceed to Buy'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _proceedToBuy(BuildContext context, List<Map<String, dynamic>> cartItems, double totalAmount) {
    // Implement your logic for proceeding to buy here
    // For example, you could navigate to a checkout screen or perform payment processing

    // For demonstration, let's navigate to a checkout screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutScreen(cartItems: cartItems, totalAmount: totalAmount),
      ),
    );
  }
}

class CheckoutScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final double totalAmount;

  const CheckoutScreen({Key? key, required this.cartItems, required this.totalAmount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Implement your checkout screen UI here
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Total Amount: ₹$totalAmount', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Implement payment processing or order placement logic here
                // This is a placeholder action
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Payment processing logic would be implemented here')),
                );
              },
              child: const Text('Place Order'),
            ),
          ],
        ),
      ),
    );
  }
}
