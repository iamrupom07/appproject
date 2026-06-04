import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─── Dio Client Provider ──────────────────────────────────────────────────────
//
// No auth headers needed — the app is a public read-only catalogue.
// Timeouts are set to 15 seconds so catalogue loading fails fast.

const productionApiBaseUrl = 'https://abroz-machinery-server.vercel.app/api/v1';

final dioProvider = Provider<Dio>((ref) {
  final configuredBaseUrl = dotenv.env['API_BASE_URL']?.trim();
  final baseUrl = configuredBaseUrl == null || configuredBaseUrl.isEmpty
      ? productionApiBaseUrl
      : configuredBaseUrl;

  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      // Home and inventory screens already show loading/error states.
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // ── Logging interceptor (debug only) ─────────────────────────────────────
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        // ignore: avoid_print
        print('[API] ${options.method} ${options.uri}');
        handler.next(options);
      },
      onResponse: (response, handler) {
        // ignore: avoid_print
        print('[API] ${response.statusCode} ${response.requestOptions.uri}');
        handler.next(response);
      },
      onError: (error, handler) {
        // ignore: avoid_print
        print('[API] ERROR ${error.message}');
        handler.next(error);
      },
    ),
  );

  return dio;
});
