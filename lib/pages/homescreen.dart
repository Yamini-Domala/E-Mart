import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

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
        primarySwatch: Colors.blue,
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
  final List<String> categories = ['Electronics', 'Clothing', 'Groceries'];
  final Map<String, List<Map<String, dynamic>>> itemsByCategory = {
    'Electronics': [
      {'name': 'Nokia Mobile Phone 105 (Dual SIM, Black)', 'price': '₹1000', 'image': 'lib/images/nokia.png'},
      {'name': 'Nokia Smart Android', 'price': '₹7000', 'image': 'lib/images/nokiasmart.png'},
      {'name': 'SamsungM52 5g', 'price': '₹25000', 'image': 'lib/images/samsungM52.png'},
      {'name': 'Lenovo Laptop', 'price': '₹69999', 'image': 'lib/images/lenovo.png'},
      {'name': 'Boat Headphones', 'price': '₹1999', 'image': 'lib/images/boat.png'},
      {'name': 'Canon Camera', 'price': '₹29999', 'image': 'lib/images/canon.png'},
      {'name': 'Boat Smartwatch', 'price': '₹4999', 'image': 'lib/images/boatSW.png'},
    ],
    'Clothing': [
      {'name': 'Girls T-Shirt Pack of five', 'price': '₹1499', 'image': 'lib/images/GirlsTshirt.png'},
      {'name': 'Boys T-Shirt', 'price': '₹499', 'image': 'lib/images/BoysTshirt.png'},
      {'name': 'T-Shirts Family pack Customizable', 'price': '₹1499', 'image': 'lib/images/Familypack.png'},
      {'name': 'Boys Jeans', 'price': '₹1999', 'image': 'lib/images/Bjeans.png'},
      {'name': 'Girls Jeans', 'price': '₹1999', 'image': 'lib/images/Gjeans.png'},
      {'name': 'Jacket', 'price': '₹2999', 'image': 'lib/images/Jacket1.png'},
      {'name': 'Jacket', 'price': '₹2999', 'image': 'lib/images/Jacket2.png'},
      {'name': 'Long Dress', 'price': '₹1499', 'image': 'lib/images/dress1.png'},
      {'name': 'Dress', 'price': '₹1499', 'image': 'lib/images/dress2.png'},
      {'name': 'Shoes', 'price': '₹2999', 'image': 'lib/images/shoes.png'},
    ],
    'Groceries': [
      {'name': 'Apple (Pack of 10)', 'price': '₹199', 'image': 'lib/images/apple.png'},
      {'name': 'Milk (500 ml)', 'price': '₹49', 'image': 'lib/images/milk.png'},
      {'name': 'Bread (500g)', 'price': '₹59', 'image': 'lib/images/bread.png'},
      {'name': 'Eggs (12)', 'price': '₹99', 'image': 'lib/images/egg.png'},
    ],
  };
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
        setState(() {
          item['quantity'] -= 1;
        });
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
        backgroundColor: const Color.fromARGB(255, 148, 86, 255),
        actions: [
          IconButton(onPressed: _signUserOut, icon: const Icon(Icons.logout))
        ],
      ),
      body: content,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Cart'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildHomeScreen() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text('Categories', style: Theme.of(context).textTheme.headlineMedium),
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
                              ? Colors.blue
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
          Column(
            children: itemsByCategory[selectedCategory]!
                .map((item) => Card(
                      child: ListTile(
                        leading: Image.network(item['image']!),
                        title: Text(item['name']!),
                        subtitle: Text('${item['price']}'),
                        trailing: IconButton(
                          icon: Icon(
                            favoriteItems.contains(item)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: favoriteItems.contains(item)
                                ? Colors.red
                                : null,
                          ),
                          onPressed: () => _toggleFavorite(item),
                        ),
                        onTap: () {
                          _addToCart(item);
                        },
                      ),
                    ))
                .toList(),
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
                  leading: Image.network(item['image']!),
                  title: Text(item['name']!),
                  subtitle: Text('${item['price']}'),
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
    super.key,
    required this.cartItems,
    required this.removeFromCart,
    required this.toggleFavorite,
    required this.increaseQuantity,
    required this.decreaseQuantity,
  });

  @override
  Widget build(BuildContext context) {
    final double totalPrice = cartItems.fold(
        0,
        (sum, item) =>
            sum +
            (double.parse(item['price']!
                    .replaceAll('₹', '')
                    .replaceAll(',', '')) *
                item['quantity']));

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        ...cartItems.map((item) => Card(
              child: ListTile(
                leading: Image.network(item['image']!),
                title: Text(item['name']!),
                subtitle: Text(
                    '${item['price']} x ${item['quantity']} = ₹${(double.parse(item['price']!.replaceAll('₹', '').replaceAll(',', '')) * item['quantity']).toStringAsFixed(2)}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () => decreaseQuantity(item),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => increaseQuantity(item),
                    ),
                    IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () => toggleFavorite(item),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => removeFromCart(item),
                    ),
                  ],
                ),
              ),
            )),
        const SizedBox(height: 20),
        Text('Total: ₹${totalPrice.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.headlineMedium),
             Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              // Handle the proceed to buy action
            },
            child: const Text('Proceed to Buy'),
          ),)
      ],
      
    );
     
  }
  
}  