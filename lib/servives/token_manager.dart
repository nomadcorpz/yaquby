import 'dart:async';

import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:flutter/material.dart';

class TokenManager {
  static final TokenManager _instance = TokenManager._internal();
  late BuildContext _context;
  factory TokenManager() {
    return _instance;
  }

  TokenManager._internal();

  late DateTime _expirationTime;

  DateTime get expirationTime => _expirationTime;

  set expirationTime(DateTime value) {
    _expirationTime = value;
    _startExpirationTimer();
  }

  void _startExpirationTimer() {
    _cancelExpirationTimer();
    DateTime now = DateTime.now();
    DateTime utcNow = now.toUtc();
    print(utcNow);
    Duration timeRemaining = _expirationTime.difference(utcNow);

    if (timeRemaining > Duration.zero) {

      Timer(timeRemaining, _logout);
    } else {
      _logout();
    }
  }

  void _cancelExpirationTimer() {
    // Cancel the existing timer if active
    // ...
  }

  void setContext(BuildContext context) {
    _context = context;
  }

  Future<void> _logout() async {
    await APICacheManager().deleteCache("login_details");
    await APICacheManager().deleteCache("selected_location");
    // ignore: use_build_context_synchronously
    Navigator.pushNamedAndRemoveUntil(
      _context, // Use the stored BuildContext
      '/login',
      (route) => false,
    );
    // Perform the logout process
    // ...
  }
}
