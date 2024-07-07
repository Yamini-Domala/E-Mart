import 'package:cloud_firestore/cloud_firestore.dart';
import 'product.dart';

class ProductService {
  final CollectionReference _productsCollection = FirebaseFirestore.instance.collection('products');

  Future<void> addProduct(Product product) {
    return _productsCollection.add(product.toMap());
  }

  Future<void> updateProduct(Product product) {
    return _productsCollection.doc(product.id).update(product.toMap());
  }

  Future<void> deleteProduct(String id) {
    return _productsCollection.doc(id).delete();
  }

  Future<List<Product>> fetchProductsByCategory(String category) async {
    final QuerySnapshot querySnapshot = await _productsCollection.where('category', isEqualTo: category).get();
    return querySnapshot.docs.map((doc) => Product.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }
}
