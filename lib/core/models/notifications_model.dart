import 'dart:convert';

class NotificationsModel {
  final String title;
  final String body;
  final DateTime timestamp;

  NotificationsModel({
    required this.title,
    required this.body,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    "title": title,
    "body": body,
    "timestamp": timestamp.toIso8601String(),
  };

  factory NotificationsModel.fromJson(Map<String, dynamic> json) {
    return NotificationsModel(
      title: json["title"],
      body: json["body"],
      timestamp: DateTime.parse(json["timestamp"]),
    );
  }
}
