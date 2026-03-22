import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'firebase_paths.dart';

/// Registers current device FCM token in Firestore for the given role
/// so Cloud Functions can send push notifications.
class FcmService {
  FcmService({
    FirebaseMessaging? messaging,
    FirebaseFirestore? firestore,
  })  : _messaging = messaging ?? FirebaseMessaging.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseMessaging _messaging;
  final FirebaseFirestore _firestore;

  /// Call when user is in owner flow so they receive admin notifications.
  Future<void> registerAsAdmin() => _registerRole('admin');

  /// Call when user is in customer flow so they receive customer notifications.
  Future<void> registerAsCustomer() => _registerRole('customer');

  Future<void> _registerRole(String role) async {
    try {
      final token = await _messaging.getToken();
      if (token == null || token.isEmpty) return;

      await _firestore.collection(FirebasePaths.fcmTokens).doc(token).set({
        'token': token,
        'role': role,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {
      // Ignore; permission denied or no token
    }
  }

  /// Request permission (call early; needed on iOS).
  Future<bool> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }
}
