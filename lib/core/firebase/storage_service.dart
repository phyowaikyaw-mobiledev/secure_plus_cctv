import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  StorageService._();

  static final StorageService _instance = StorageService._();

  factory StorageService() => _instance;

  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<String>> uploadImages({
    required String folderPath,
    required List<XFile> images,
  }) async {
    final List<String> urls = [];

    for (final image in images) {
      final file = File(image.path);
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = _storage.ref('$folderPath/$fileName.jpg');
      final uploadTask = await ref.putFile(file);
      final url = await uploadTask.ref.getDownloadURL();
      urls.add(url);
    }

    return urls;
  }
}

