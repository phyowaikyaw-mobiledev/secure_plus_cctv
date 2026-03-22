import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._() {
    _firestore.settings = const Settings(persistenceEnabled: true);
  }

  static final FirestoreService _instance = FirestoreService._();

  factory FirestoreService() => _instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseFirestore get instance => _firestore;

  CollectionReference<Map<String, dynamic>> collection(String path) {
    return _firestore.collection(path);
  }

  DocumentReference<Map<String, dynamic>> doc(
    String path,
    String id,
  ) {
    return _firestore.collection(path).doc(id);
  }

  Future<DocumentReference<Map<String, dynamic>>> add(
    String path,
    Map<String, dynamic> data,
  ) {
    return _firestore.collection(path).add(data);
  }

  Future<void> update(
    String path,
    String id,
    Map<String, dynamic> data,
  ) {
    return _firestore.collection(path).doc(id).update(data);
  }

  Future<void> delete(
    String path,
    String id,
  ) {
    return _firestore.collection(path).doc(id).delete();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamCollection(
    String path, {
    Query<Map<String, dynamic>> Function(
      Query<Map<String, dynamic>> query,
    )?
        queryBuilder,
  }) {
    Query<Map<String, dynamic>> query = _firestore.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    return query.snapshots();
  }
}

