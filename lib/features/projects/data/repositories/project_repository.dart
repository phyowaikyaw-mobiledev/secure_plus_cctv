import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/firebase/firebase_paths.dart';
import '../../../../core/firebase/firestore_service.dart';
import '../../../../core/storage/cloudinary_service.dart';
import '../models/project_model.dart';

class ProjectRepository {
  ProjectRepository({
    FirestoreService? firestore,
    CloudinaryService? cloudinary,
  })  : _firestore = firestore ?? FirestoreService(),
        _cloudinary = cloudinary ?? CloudinaryService();

  final FirestoreService _firestore;
  final CloudinaryService _cloudinary;

  static const String _cacheBoxName = 'secure_plus_settings';
  static const String _cacheKey = 'projects_cache';

  Stream<List<Project>> watchProjects() {
    return _firestore
        .streamCollection(
          FirebasePaths.projects,
          queryBuilder: (query) =>
              query.orderBy('createdAt', descending: true),
        )
        .map((snapshot) {
      final projects =
          snapshot.docs.map(Project.fromDoc).toList(growable: false);
      _cacheProjects(projects);
      return projects;
    });
  }

  Future<List<Project>> loadCachedProjects() async {
    final box = Hive.box(_cacheBoxName);
    final cached = box.get(_cacheKey);
    if (cached is List) {
      return cached
          .whereType<Map>()
          .map((raw) {
            final map = Map<String, dynamic>.from(raw);
            return Project(
              id: map['id'] as String? ?? '',
              title: map['title'] as String? ?? '',
              description: map['description'] as String? ?? '',
              location: map['location'] as String? ?? '',
              mapLink: map['mapLink'] as String? ?? '',
              createdAt:
                  DateTime.tryParse(map['createdAt'] as String? ?? '') ??
                      DateTime.now(),
              imageUrls: (map['imageUrls'] as List?)
                      ?.whereType<String>()
                      .toList() ??
                  <String>[],
            );
          })
          .toList(growable: false);
    }
    return <Project>[];
  }

  Future<void> addProject({
    required Project project,
    required List<XFile> images,
  }) async {
    final ref = await _firestore.add(
      FirebasePaths.projects,
      project.toMap(),
    );

    if (images.isNotEmpty) {
      final files = images.map((xfile) => File(xfile.path)).toList();
      final urls = await _cloudinary.uploadImages(files);
      await ref.update({'imageUrls': urls});
    }
  }

  Future<void> updateProject({
    required Project project,
    List<XFile> newImages = const [],
  }) async {
    final data = project.toMap();
    if (newImages.isNotEmpty) {
      final files = newImages.map((xfile) => File(xfile.path)).toList();
      final urls = await _cloudinary.uploadImages(files);
      data['imageUrls'] = [...project.imageUrls, ...urls];
    }
    await _firestore.update(
      FirebasePaths.projects,
      project.id,
      data,
    );
  }

  Future<void> deleteProject(Project project) async {
    await _firestore.delete(FirebasePaths.projects, project.id);
    // Storage cleanup can be added later if required.
  }

  void _cacheProjects(List<Project> projects) {
    final box = Hive.box(_cacheBoxName);
    final data = projects
        .map(
          (p) => {
            'id': p.id,
            'title': p.title,
            'description': p.description,
            'location': p.location,
            'mapLink': p.mapLink,
            'createdAt': p.createdAt.toIso8601String(),
            'imageUrls': p.imageUrls,
          },
        )
        .toList(growable: false);
    box.put(_cacheKey, data);
  }
}

