import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Creates the "default" notification channel (used by FCM) so that
/// notifications show as popup (heads-up) and play sound on Android 8+.
/// Also shows local notification when FCM message is received in foreground.
class AppNotificationService {
  AppNotificationService._();
  static final AppNotificationService _instance = AppNotificationService._();
  factory AppNotificationService() => _instance;

  static const String _channelId = 'default';
  static const String _channelName = 'Secure Plus';

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  FlutterLocalNotificationsPlugin get plugin => _plugin;

  /// Call once at app startup. Creates Android channel and initializes plugin.
  Future<void> initialize() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: android);
    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Create channel so FCM messages show as popup with sound (Android 8+).
    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: 'Push notifications from Secure Plus',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(channel);
    // Android 13+: request runtime permission so notifications can show.
    await androidPlugin?.requestNotificationsPermission();
  }

  void _onNotificationTap(NotificationResponse response) {
    // Optional: navigate when user taps notification (e.g. from payload)
  }

  /// Show a local notification (used when FCM message is received in foreground).
  Future<void> showFromFcm(RemoteMessage message) async {
    final notification = message.notification;
    final android = message.notification?.android;
    if (notification == null) return;

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        android?.channelId ?? _channelId,
        _channelName,
        channelDescription: 'Push notifications from Secure Plus',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
      ),
    );
    final id = message.hashCode.abs().clamp(0, 0x7FFFFFFF);
    await _plugin.show(
      id,
      notification.title ?? 'Secure Plus',
      notification.body,
      details,
      payload: message.data.isEmpty ? null : message.data.toString(),
    );
  }
}
