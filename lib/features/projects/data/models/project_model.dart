import 'package:cloud_firestore/cloud_firestore.dart';

class Project {
  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.mapLink,
    required this.createdAt,
    required this.imageUrls,
  });

  final String id;
  final String title;
  final String description;
  final String location;
  final String mapLink;
  final DateTime createdAt;
  final List<String> imageUrls;

  factory Project.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    final createdAtRaw = data['createdAt'];
    DateTime createdAt;
    if (createdAtRaw is Timestamp) {
      createdAt = createdAtRaw.toDate();
    } else if (createdAtRaw is String) {
      createdAt = DateTime.tryParse(createdAtRaw) ?? DateTime.now();
    } else {
      createdAt = DateTime.now();
    }
    final imagesDynamic = data['imageUrls'];
    final List<String> urls = [];
    if (imagesDynamic is List) {
      for (final item in imagesDynamic) {
        if (item is String) {
          urls.add(item);
        }
      }
    }
    return Project(
      id: doc.id,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      location: data['location'] as String? ?? '',
      mapLink: data['mapLink'] as String? ?? '',
      createdAt: createdAt,
      imageUrls: urls,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'location': location,
      'mapLink': mapLink,
      'createdAt': createdAt.toUtc(),
      'imageUrls': imageUrls,
    };
  }
}

