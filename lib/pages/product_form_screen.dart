import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' show File;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'product.dart';
import 'product_service.dart';


class ProductFormScreen extends StatefulWidget {
  final Product? product;

  const ProductFormScreen({Key? key, this.product}) : super(key: key);

  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _categories = ['Electronics', 'Clothing', 'Groceries', 'Beauty Products','Books','Pet Supplies','Home and Kitchen','Sports Wear'];
  String? _selectedCategory;
  XFile? _image;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _descriptionController.text = widget.product!.description;
      _priceController.text = widget.product!.price.toString();
      _selectedCategory = widget.product!.category;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        String imageUrl;
        if (_image != null) {
          String productId = widget.product?.id ?? FirebaseFirestore.instance.collection('products').doc().id;
          if (kIsWeb) {
            imageUrl = await ImageUploadService().uploadImageWeb(_image!, productId);
          } else {
            File file = File(_image!.path);
            imageUrl = await ImageUploadService().uploadImage(file, productId);
          }
        } else if (widget.product != null) {
          imageUrl = widget.product!.imageUrl;
        } else {
          throw Exception('Image is required');
        }

        final product = Product(
          id: widget.product?.id,
          name: _nameController.text,
          description: _descriptionController.text,
          price: double.parse(_priceController.text),
          category: _selectedCategory!,
          imageUrl: imageUrl,
          
        );

        if (widget.product == null) {
          await ProductService().addProduct(product);
        } else {
          await ProductService().updateProduct(product);
        }

        Navigator.pop(context);
      } catch (e) {
        print('Error: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
        backgroundColor: Color.fromARGB(255, 200, 0, 255),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Product Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a product name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: 'Description'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid price';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: _categories
                          .map((category) => DropdownMenuItem<String>(
                                value: category,
                                child: Text(category),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a category';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _image == null && widget.product == null
                        ? const Text('No image selected.')
                        : kIsWeb
                            ? Image.network(widget.product?.imageUrl ?? '')
                            : Image.file(File(_image!.path)),
                    TextButton(
                      onPressed: _pickImage,
                      child: const Text('Select Image'),
                    ),
                              

                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveProduct,
                      child: Text(widget.product == null ? 'Add Product' : 'Update Product'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 200, 0, 255),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class ImageUploadService {
  // Add a method for web-specific image upload
  Future<String> uploadImageWeb(XFile image, String productId) async {
    // Your web-specific image upload logic here
    // For example, using Firebase Storage
    Reference ref = FirebaseStorage.instance.ref().child('products').child(productId);
    UploadTask uploadTask = ref.putData(await image.readAsBytes());
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  // Existing method for non-web image upload
  Future<String> uploadImage(File image, String productId) async {
    Reference ref = FirebaseStorage.instance.ref().child('products').child(productId);
    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }
}
