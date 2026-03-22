import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/firebase/firebase_paths.dart';
import '../../../../../core/firebase/firestore_service.dart';
import '../../../../../core/firebase/storage_service.dart';
import '../models/service_request.dart';

class ServiceRequestRepository {
  ServiceRequestRepository({
    FirestoreService? firestore,
    StorageService? storage,
  })  : _firestore = firestore ?? FirestoreService(),
        _storage = storage ?? StorageService();

  final FirestoreService _firestore;
  final StorageService _storage;

  Stream<List<ServiceRequest>> watchRequests() {
    return _firestore
        .streamCollection(
          FirebasePaths.serviceRequests,
          queryBuilder: (query) =>
              query.orderBy('createdAt', descending: true),
        )
        .map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          final createdAt = (data['createdAt'] as Timestamp).toDate();
          return ServiceRequest(
            id: doc.id,
            name: data['name'] as String? ?? '',
            phone: data['phone'] as String? ?? '',
            township: data['township'] as String? ?? '',
            address: data['address'] as String? ?? '',
            locationLink: data['locationLink'] as String? ?? '',
            premiseType: data['premiseType'] as String? ?? '',
            cameraCount: (data['cameraCount'] as num?)?.toInt() ?? 0,
            indoorOutdoor: data['indoorOutdoor'] as String? ?? '',
            remoteView: data['remoteView'] as bool? ?? false,
            audioRequired: data['audioRequired'] as bool? ?? false,
            preferredDateTime: data['preferredDateTime'] as String? ?? '',
            notes: data['notes'] as String? ?? '',
            photoUrl: data['photoUrl'] as String?,
            status: data['status'] as String? ?? 'pending',
            createdAt: createdAt,
          );
        }).toList();
      },
    );
  }

  Future<void> submitRequest({
    required ServiceRequest request,
    XFile? attachment,
  }) async {
    final data = request.toMap();
    data['status'] = 'pending';

    final docRef =
        await _firestore.add(FirebasePaths.serviceRequests, data);

    if (attachment != null) {
      final urls = await _storage.uploadImages(
        folderPath:
            FirebasePaths.serviceRequestImagesFolder(docRef.id),
        images: [attachment],
      );
      await docRef.update({'photoUrl': urls.first});
    }
  }

  Future<void> updateStatus({
    required String id,
    required String status,
    String? notes,
    String? scheduledAt,
  }) async {
    final data = <String, dynamic>{'status': status};
    if (notes != null) {
      data['adminNotes'] = notes;
    }
    if (scheduledAt != null) {
      data['scheduledAt'] = scheduledAt;
    }
    await _firestore.update(
      FirebasePaths.serviceRequests,
      id,
      data,
    );
  }
}

