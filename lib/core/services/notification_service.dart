// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:fitness_app/core/models/notifications_model.dart';
// import 'package:fitness_app/core/models/tasks_model.dart';
// import 'package:fitness_app/core/models/user_model.dart';
// import 'package:fitness_app/core/services/database_services.dart';
// import 'package:fitness_app/ui/screens/notifications/notifications_storage.dart';
// import 'package:fitness_app/ui/screens/root/root_screen.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:get/get.dart';

// class NotificationService {
//   final _fcm = FirebaseMessaging.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final DatabaseServices _databaseServices = DatabaseServices();

//   String? fcmToken;

//   late AndroidNotificationChannel channel;
//   late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

//   /// Initialize FCM and local notifications
//   Future<void> initConfigure() async {
//     if (kIsWeb) return;

//     // 1️⃣ Setup notification channel
//     channel = const AndroidNotificationChannel(
//       'default_channel',
//       'High Importance Notifications',
//       description: 'Used for push notifications',
//       importance: Importance.high,
//     );

//     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//     const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const iosInit = DarwinInitializationSettings();
//     const settings = InitializationSettings(android: androidInit, iOS: iosInit);

//     // 2️⃣ Handle notification taps (foreground/background/terminated)
//     await flutterLocalNotificationsPlugin.initialize(
//       settings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) async {
//         debugPrint("🔗 Notification tapped: ${response.payload}");
//         Get.to(() => RootScreen()); // Open app/home when tapped
//       },
//     );

//     // 3️⃣ Create channel
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin
//         >()
//         ?.createNotificationChannel(channel);

//     // 4️⃣ Request permissions
//     await _fcm.requestPermission(alert: true, badge: true, sound: true);

//     // 5️⃣ Get FCM token
//     fcmToken = await _fcm.getToken();
//     debugPrint("✅ FCM token: $fcmToken");

//     final userId = _auth.currentUser?.uid;
//     if (userId != null && fcmToken != null) {
//       final userDoc = await _databaseServices.getUser(userId);
//       if (userDoc == null ||
//           userDoc.fcmToken == null ||
//           userDoc.fcmToken != fcmToken) {
//         await _databaseServices.updateFcmToken(fcmToken ?? "");
//       }
//     }

//     // 6️⃣ Foreground messages
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//       debugPrint("📩 Foreground message: ${message.data}");
//       await handleIncomingMessage(message);
//     });

//     // 7️⃣ Background notification tap
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       debugPrint("📩 App opened from background: ${message.data}");
//       Get.to(() => RootScreen());
//     });

//     // 8️⃣ Terminated state (app killed, opened via tap)
//     final initialMessage = await _fcm.getInitialMessage();
//     if (initialMessage != null) {
//       debugPrint("📩 App opened from terminated state: ${initialMessage.data}");
//       Get.to(() => RootScreen());
//     }
//   }

//   /// Handle incoming message in any state
//   Future<void> handleIncomingMessage(RemoteMessage message) async {
//     try {
//       final userId = _auth.currentUser?.uid;
//       if (userId == null) return;

//       final workout =
//           message.data['workout'] ?? "20 Sprint-in-Place (high knees)";
//       final points =
//           int.tryParse(message.data['points']?.toString() ?? "10") ?? 10;

//       // ✅ Save task
//       final task = TaskModel(
//         id: "",
//         title: workout,
//         description:
//             message.notification?.body ?? "Task received from notification",
//         createdAt: DateTime.now(),
//         points: points,
//       );
//       await _databaseServices.saveTask(task);

//       // ✅ Save locally
//       final notif = NotificationsModel(
//         title: message.notification?.title ?? "Rush Detected!",
//         body: message.notification?.body ?? "No Body",
//         timestamp: DateTime.now(),
//       );
//       await NotificationStorage.saveNotification(notif);

//       // ✅ Show local notification
//       if (message.notification != null) {
//         await flutterLocalNotificationsPlugin.show(
//           message.notification.hashCode,
//           message.notification?.title,
//           message.notification?.body,
//           NotificationDetails(
//             android: AndroidNotificationDetails(
//               channel.id,
//               channel.name,
//               channelDescription: channel.description,
//               importance: Importance.high,
//               priority: Priority.high,
//               icon: '@mipmap/ic_launcher',
//             ),
//             iOS: DarwinNotificationDetails(),
//           ),
//           payload: message.data.toString(),
//         );
//         debugPrint("🔔 Local notification displayed");
//       }
//     } catch (e, st) {
//       debugPrint("🔥 Error while processing notification: $e\n$st");
//     }
//   }
// }
