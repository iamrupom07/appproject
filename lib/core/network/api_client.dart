import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─── Dio Client Provider ──────────────────────────────────────────────────────
//
// No auth headers needed — the app is a public read-only catalogue.
// Timeouts are set to 45 seconds to handle Vercel cold starts.

final dioProvider = Provider<Dio>((ref) {
  final baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://10.0.2.2:5000/api/v1';

  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      // Vercel serverless functions can take 20–30 s to cold-start.
      // 45 s gives enough headroom without feeling broken to the user.
      connectTimeout: const Duration(seconds: 45),
      receiveTimeout: const Duration(seconds: 45),
      sendTimeout: const Duration(seconds: 45),
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
