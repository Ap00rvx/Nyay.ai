import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:nyay/core/exception/network_failure.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// FP-friendly result types
typedef NetworkEither<T> = Either<NetworkFailure, T>;
typedef NetworkTask<T> = TaskEither<NetworkFailure, T>;

/// Provides a global, configured Dio instance with logging.
class DioProvider {
  DioProvider._();

  static final Dio _dio = _create();

  static Dio get instance => _dio;

  static Dio _create() {
    final options = BaseOptions(
      baseUrl: const String.fromEnvironment('API_BASE_URL', defaultValue: ''),
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      responseType: ResponseType.json,
      contentType: 'application/json',
      headers: const {'Accept': 'application/json'},
    );

    final dio = Dio(options);

    // Log requests/responses/errors for easier debugging
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        compact: true,
        error: true,
        maxWidth: 100,
      ),
    );

    return dio;
  }

  /// Update/clear bearer auth token header
  static void setAuthToken(String? token) {
    if (token == null || token.isEmpty) {
      _dio.options.headers.remove('Authorization');
    } else {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  /// Update base url at runtime if needed
  static void setBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }
}

/// Thin network client exposing FP-based helpers for common HTTP verbs.
class NetworkClient {
  final Dio _dio;
  NetworkClient([Dio? dio]) : _dio = dio ?? DioProvider.instance;

  NetworkTask<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    T Function(dynamic data)? decoder,
  }) {
    return _wrap<T>(
      () => _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      ),
      decoder,
    );
  }

  NetworkTask<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    T Function(dynamic data)? decoder,
  }) {
    return _wrap<T>(
      () => _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
      decoder,
    );
  }

  NetworkTask<T> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    T Function(dynamic data)? decoder,
  }) {
    return _wrap<T>(
      () => _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
      decoder,
    );
  }

  NetworkTask<T> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic data)? decoder,
  }) {
    return _wrap<T>(
      () => _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
      decoder,
    );
  }

  /// Wraps a Dio request into a TaskEither and applies error mapping.
  NetworkTask<T> _wrap<T>(
    Future<Response<dynamic>> Function() request,
    T Function(dynamic data)? decoder,
  ) {
    return TaskEither<NetworkFailure, T>.tryCatch(() async {
      final res = await request();
      final body = res.data;

      if (decoder != null) {
        return decoder(body);
      }

      // If no decoder is provided, attempt a safe cast for common shapes.
      if (T == Response || T == Response<dynamic>) {
        return res as T;
      }
      return body as T; // may throw if T mismatches; caught and mapped below
    }, (error, stackTrace) => _mapToFailure(error));
  }
}

NetworkFailure _mapToFailure(Object error) {
  if (error is DioException) {
    final type = error.type;
    switch (type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return const TimeoutFailure('Request timed out');
      case DioExceptionType.badCertificate:
        return const ServerFailure('Bad SSL certificate');
      case DioExceptionType.connectionError:
        return const NoConnectionFailure(
          'No internet connection or host unreachable',
        );
      case DioExceptionType.cancel:
        return const CancelledFailure('Request cancelled');
      case DioExceptionType.badResponse:
        final status = error.response?.statusCode ?? 0;
        final data = error.response?.data;
        final message = _extractMessage(data) ?? 'HTTP $status error';
        if (status == 400)
          return BadRequestFailure(message, statusCode: status, details: data);
        if (status == 401)
          return UnauthorizedFailure(message, statusCode: status);
        if (status == 403) return ForbiddenFailure(message, statusCode: status);
        if (status == 404) return NotFoundFailure(message, statusCode: status);
        if (status == 409)
          return ConflictFailure(message, statusCode: status, details: data);
        if (status >= 500) {
          return ServerFailure(message, statusCode: status, details: data);
        }
        return UnknownFailure(message, statusCode: status, details: data);
      case DioExceptionType.unknown:
        // Often JSON cast issues or other runtime exceptions end up here
        final msg = error.message ?? 'Unexpected error';
        return UnknownFailure(msg);
    }
  }

  if (error is FormatException || error is TypeError) {
    return SerializationFailure(
      'Failed to parse/serialize data',
      details: error.toString(),
    );
  }

  return UnknownFailure('Unexpected error: $error');
}

String? _extractMessage(dynamic data) {
  try {
    if (data is Map<String, dynamic>) {
      // Common API error shapes
      if (data['message'] is String) return data['message'] as String;
      if (data['error'] is String) return data['error'] as String;
      if (data['detail'] is String) return data['detail'] as String;
    }
    if (data is String) {
      // Sometimes servers send plain text
      return data;
    }
    // Handle encoded JSON string
    if (data is List || data is Iterable) {
      return data.isEmpty ? null : data.first.toString();
    }
    if (data is! String) return null;
    final decoded = json.decode(data);
    if (decoded is Map<String, dynamic>) {
      return decoded['message'] as String? ?? decoded['error'] as String?;
    }
  } catch (_) {
    // ignore parsing errors for error payloads
  }
  return null;
}

/// Example usage:
///
/// final client = NetworkClient();
/// final task = client.get<UserDTO>(
///   '/users/42',
///   decoder: (json) => UserDTO.fromJson(json as Map<String, dynamic>),
/// );
/// final result = await task.run();
/// result.match(
///   (l) => print('Error: ${l.message}'),
///   (r) => print('User: $r'),
/// );
