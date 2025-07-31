import 'package:youthspot/screens/homepage.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class NotificationService {
  static Future<void> initializeNotification() async {
    try {
      await AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
            channelGroupKey: 'high_importance_channel_group',
            channelKey: 'high_importance_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            ledColor: Colors.white,
            importance: NotificationImportance.Max,
            channelShowBadge: true,
            onlyAlertOnce: true,
            playSound: true,
            criticalAlerts: true,
            icon: 'resource://drawable/icon_notifications',
          )
        ],
        channelGroups: [
          NotificationChannelGroup(
            channelGroupKey: 'high_importance_channel_group',
            channelGroupName: 'Group 1',
          )
        ],
        debug: true,
      );

      await AwesomeNotifications().isNotificationAllowed().then(
        (isAllowed) async {
          if (!isAllowed) {
            await AwesomeNotifications().requestPermissionToSendNotifications();
          }
        },
      );

      await AwesomeNotifications().setListeners(
        onActionReceivedMethod: onActionReceivedMethod,
        onNotificationCreatedMethod: onNotificationCreatedMethod,
        onNotificationDisplayedMethod: onNotificationDisplayedMethod,
        onDismissActionReceivedMethod: onDismissActionReceivedMethod,
      );
    } catch (e) {
      debugPrint('Error initializing notifications: $e');
    }
  }

  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('Notification Created: ${receivedNotification.title}');
  }

  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('Notification Displayed: ${receivedNotification.title}');
  }

  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('Notification Dismissed: ${receivedAction.title}');
  }

  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('Notification Action Received: ${receivedAction.title}');
    final payload = receivedAction.payload ?? {};
    if (payload.containsKey("navigate") && payload["navigate"] == "true") {
      MyApp.navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => const HomePage(),
        ),
      );
    } else {
      debugPrint("Unhandled payload: $payload");
    }
  }

  static Future<void> showNotification({
    required final String title,
    required final String body,
    final String? summary,
    final Map<String, String>? payload,
    final ActionType actionType = ActionType.Default,
    final NotificationLayout notificationLayout = NotificationLayout.Default,
    final NotificationCategory? category,
    final String? bigPicture,
    final List<NotificationActionButton>? actionButtons,
    final bool scheduled = false,
    final int? interval,
  }) async {
    assert(!scheduled || (scheduled && interval != null));

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now()
            .millisecondsSinceEpoch
            .remainder(100000), // Dynamic ID
        channelKey: 'high_importance_channel',
        title: title,
        body: body,
        actionType: actionType,
        notificationLayout: notificationLayout,
        summary: summary,
        category: category,
        payload: payload,
        bigPicture: bigPicture,
        icon: 'resource://drawable/icon_notifications',
      ),
      actionButtons: actionButtons,
      schedule: scheduled
          ? NotificationInterval(
              interval: Duration(seconds: interval ?? 1), // FIXED
              timeZone:
                  await AwesomeNotifications().getLocalTimeZoneIdentifier(),
              preciseAlarm: true,
            )
          : null,
    );
  }

  static Future<void> sendImmediateNotification({
    required int notificationId,
    required String title,
    required String body,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: notificationId,
        channelKey: 'high_importance_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
        icon: 'resource://drawable/icon_notifications',
      ),
    );
  }

  static Future<void> scheduleNotification({
    required final String title,
    required final String body,
    required final DateTime scheduledDate,
    required int notificationId,
  }) async {
    try {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: notificationId, // Ensure notificationId is used
          channelKey: 'high_importance_channel',
          title: title,
          body: body,
          notificationLayout: NotificationLayout.Default,
          icon: 'resource://drawable/icon_notifications',
        ),
        schedule: NotificationCalendar.fromDate(date: scheduledDate),
      );
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
      rethrow;
    }
  }

  // Cancel a specific notification by its ID
  static Future<void> cancelNotification(int notificationId) async {
    await AwesomeNotifications().cancel(notificationId);
  }

  // Cancel all notifications (optional, you can use this if needed)
  static Future<void> cancelAllNotifications() async {
    await AwesomeNotifications().cancelAll();
  }
}
