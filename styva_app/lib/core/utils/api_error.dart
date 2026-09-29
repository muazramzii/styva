import 'package:dio/dio.dart';

String extractApiErrorMessage(Object error) {
  if (error is DioException) {
    final data = error.response?.data;
    if (data is Map) {
      final detail = data['detail'];
      if (detail is String) return detail;

      final messages = <String>[];
      for (final value in data.values) {
        if (value is List) {
          messages.addAll(value.map((item) => '$item'));
        } else {
          messages.add('$value');
        }
      }
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
