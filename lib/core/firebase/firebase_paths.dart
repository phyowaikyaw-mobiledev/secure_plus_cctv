class FirebasePaths {
  static const String serviceRequests = 'service_requests';
  static const String tickets = 'tickets';
  static const String projects = 'projects';
  static const String quotes = 'quotes';
  /// FCM device tokens for push: doc id = token, field 'role' = 'admin' | 'customer'
  static const String fcmTokens = 'fcm_tokens';

  static String projectImagesFolder(String projectId) =>
      'projects/$projectId/images';

  static String serviceRequestImagesFolder(String requestId) =>
      'service_requests/$requestId';

  static String ticketImagesFolder(String ticketId) => 'tickets/$ticketId';
}

