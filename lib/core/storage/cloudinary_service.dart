import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

/// Cloudinary configuration (DEMO / MVP).
/// TODO: Replace with your real values from Cloudinary Dashboard.
const String cloudName = 'dosjsvdoy'; // TODO: Replace with real value
const String uploadPreset = 'secure_plus_unsigned'; // TODO: Replace with real value

/// Optional: organize uploads into a folder in Cloudinary.
const String defaultFolder = 'secure_plus/projects'; // TODO: change if you want

class CloudinaryService {
  CloudinaryService._();
  static final CloudinaryService _instance = CloudinaryService._();
  factory CloudinaryService() => _instance;

  Uri get _uploadUri =>
      Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

  /// Upload a single image file and return its secure URL.
  Future<String> uploadImage(
      File file, {
        String folder = defaultFolder,
        Duration timeout = const Duration(seconds: 45),
      }) async {
    final urls = await uploadImages(
      [file],
      folder: folder,
      timeout: timeout,
    );
    if (urls.isEmpty) {
      throw Exception('Cloudinary upload failed: no URL returned.');
    }
    return urls.first;
  }

  /// Upload multiple image files and return secure URLs.
  Future<List<String>> uploadImages(
      List<File> files, {
        String folder = defaultFolder,
        Duration timeout = const Duration(seconds: 45),
      }) async {
    if (files.isEmpty) return const [];

    final List<String> urls = [];

    for (final file in files) {
      if (!file.existsSync()) {
        throw Exception('File not found: ${file.path}');
      }

      final request = http.MultipartRequest('POST', _uploadUri)
        ..fields['upload_preset'] = uploadPreset
        ..fields['folder'] = folder;

      final mimeType = lookupMimeType(file.path) ?? 'image/jpeg';
      final typeParts = mimeType.split('/');
      final mediaType = (typeParts.length == 2)
          ? MediaType(typeParts[0], typeParts[1])
          :  MediaType('image', 'jpeg');

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
          contentType: mediaType,
        ),
      );

      final streamedResponse = await request.send().timeout(timeout);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(
          'Cloudinary upload failed (${response.statusCode}): ${response.body}',
        );
      }

      final Map<String, dynamic> body =
      jsonDecode(response.body) as Map<String, dynamic>;

      final url = (body['secure_url'] as String?) ?? (body['url'] as String?);
      if (url == null || url.isEmpty) {
        throw Exception('Cloudinary response missing secure_url/url: ${response.body}');
      }

      urls.add(url);
    }

    return urls;
  }
}
