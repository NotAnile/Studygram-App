import 'package:flutter/material.dart';

// Enum class with statuses for async operations
enum Status {
  idle,
  loading,
  success,
  error,
}

class BaseUrl {
  final String _baseUrl = "http://127.0.0.1:5000";

  String get baseUrl => _baseUrl;
}
