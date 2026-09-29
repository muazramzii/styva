import 'package:dio/dio.dart';

String extractApiErrorMessage(Object error) {
  if (error is DioException) {
    final statusCode = error.response?.statusCode;
    if (statusCode != null && statusCode >= 500) {
      return 'Something went wrong on our side. Please try again.';
    }

    final data = error.response?.data;
    if (data is Map) {
      final detail = data['detail'];
      if (detail is String) return detail;

      final messages = _collectMessages(data);
      if (messages.isNotEmpty) return messages.join('\n');
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return 'Could not reach the server. Please try again.';
    }

    return error.message ?? 'Something went wrong.';
  }
  return error.toString();
}

/// Flattens DRF validation errors, including nested serializer errors like
/// `{"shipping_address": {"postcode": ["..."]}}`, into readable lines.
List<String> _collectMessages(Object? value) {
  if (value is Map) {
    return value.values.expand(_collectMessages).toList();
  }
  if (value is List) {
    return value.expand(_collectMessages).toList();
  }
  if (value == null) return const [];
  return ['$value'];
}
