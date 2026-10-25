import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageServices {
  static SharedPreferences? _preferences;
  static const String accessTokenKey = 'accessTokenKey';
  static const String welcomeCompleteKey = 'welcomeCompletedKey';
  static const String loginCompletedKey = 'loginCompletedKey';
  static const String assessmentCompletedKey = 'assessmentCompletedKey';

  // Access token getter/setter
  dynamic get accessToken => _getFromDisk(accessTokenKey) ?? null;
  set accessToken(token) => _saveToDisk(accessTokenKey, token);

  // Onboarding completed getter/setter
  bool get welcomeCompleted =>
      _getFromDisk(welcomeCompleteKey) ?? false;
  set welcomeCompleted(bool value) =>
      _saveToDisk(welcomeCompleteKey, value);

  bool get loginAlready =>
      _getFromDisk(loginCompletedKey) ?? false;
  set loginAlready(bool value) =>
      _saveToDisk(loginCompletedKey, value);

  bool get assessmentCompleted =>
      _getFromDisk(assessmentCompletedKey) ?? false;
  set assessmentCompleted(bool value) =>
      _saveToDisk(assessmentCompletedKey, value);

  // Initialize shared preferences
  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Internal read method
  _getFromDisk(String key) {
    var value = _preferences!.get(key);
    debugPrint(
        '(TRACE) LocalStorageService:_getFromDisk. key: $key value: $value');
    return value;
  }

  // Internal save method
  void _saveToDisk<T>(String key, T content) {
    debugPrint(
        '(TRACE) LocalStorageService:_saveToDisk. key: $key value: $content');

    if (content is String) {
      _preferences!.setString(key, content);
    }
    if (content is bool) {
      _preferences!.setBool(key, content);
    }
    if (content is int) {
      _preferences!.setInt(key, content);
    }
    if (content is double) {
      _preferences!.setDouble(key, content);
    }
    if (content is List<String>) {
      _preferences!.setStringList(key, content);
    }
    if (content is List<Map<String, dynamic>>) {
      String jsonString = json.encode(content);
      _preferences!.setString(key, jsonString);
    }

    if (content == null) {
      _preferences!.remove(key);
    }
  }
}
