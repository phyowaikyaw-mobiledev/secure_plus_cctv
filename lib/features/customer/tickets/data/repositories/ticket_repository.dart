import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/firebase/firebase_paths.dart';
import '../../../../../core/firebase/firestore_service.dart';
import '../../../../../core/firebase/storage_service.dart';
import '../models/ticket.dart';

class TicketRepository {
  TicketRepository({
    FirestoreService? firestore,
    StorageService? storage,
  })  : _firestore = firestore ?? FirestoreService(),
        _storage = storage ?? StorageService();

  final FirestoreService _firestore;
  final StorageService _storage;

  Stream<List<Ticket>> watchTickets() {
    return _firestore
        .streamCollection(
          FirebasePaths.tickets,
          queryBuilder: (query) =>
              query.orderBy('createdAt', descending: true),
        )
        .map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          final createdAt = (data['createdAt'] as Timestamp).toDate();
          return Ticket(
            id: doc.id,
            issueType: data['issueType'] as String? ?? '',
            description: data['description'] as String? ?? '',
            urgency: data['urgency'] as String? ?? 'normal',
            photoUrl: data['photoUrl'] as String?,
            status: data['status'] as String? ?? 'open',
            createdAt: createdAt,
          );
        }).toList();
      },
    );
  }

  Future<void> createTicket({
    required Ticket ticket,
    XFile? attachment,
  }) async {
    final data = ticket.toMap();
    data['status'] = 'open';
    final doc =
        await _firestore.add(FirebasePaths.tickets, data);
    if (attachment != null) {
      final urls = await _storage.uploadImages(
        folderPath: FirebasePaths.ticketImagesFolder(doc.id),
        images: [attachment],
      );
      await doc.update({'photoUrl': urls.first});
    }
  }

  Future<void> updateStatus({
    required String id,
    required String status,
    String? priority,
  }) async {
    final data = <String, dynamic>{'status': status};
    if (priority != null) {
      data['urgency'] = priority;
    }
    await _firestore.update(FirebasePaths.tickets, id, data);
  }
}

