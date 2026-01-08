import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _notifications.initialize(settings);
  }

  static Future<void> showPredictionResult({
    required double risk,
    required double bpm,
  }) async {
    final isHigh = risk > 50;

    const androidDetails = AndroidNotificationDetails(
      'heart_predict',
      'Heart Prediction',
      importance: Importance.max,
      priority: Priority.high,
    );

    await _notifications.show(
      0,
      isHigh ? '⚠️ Cảnh báo tim mạch' : '❤️ Tim mạch ổn định',
      isHigh
          ? 'Nguy cơ cao (${risk.toStringAsFixed(1)}%) – BPM $bpm'
          : 'Nguy cơ thấp (${risk.toStringAsFixed(1)}%) – BPM $bpm',
      const NotificationDetails(android: androidDetails),
    );
  }
}
