import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';


class ImageUploadService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage(File imageFile, String productId) async {
    try {
      final Reference ref = _storage.ref().child('product_images/$productId');
      final UploadTask uploadTask = ref.putFile(imageFile);
      final TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      throw e; // Handle the error appropriately in your UI
    }
  }
}

