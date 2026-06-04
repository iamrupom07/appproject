import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_response.dart';
import 'product_dto.dart';

// ─── Query params ─────────────────────────────────────────────────────────────

class ProductQuery {
  const ProductQuery({
    this.search,
    this.categoryId,
    this.status = 'active',
    this.page = 1,
    this.limit = 100,
  });

  final String? search;
  final String? categoryId;
  final String? status;
  final int page;
  final int limit;

  Map<String, dynamic> toQueryParams() {
    return {
      if (search != null && search!.isNotEmpty) 'search': search,
      if (categoryId != null) 'categoryId': categoryId,
      if (status != null) 'status': status,
      'page': page,
      'limit': limit,
    };
  }
}

// ─── Repository ───────────────────────────────────────────────────────────────

class ProductRepository {
  const ProductRepository(this._dio);
  final Dio _dio;

  // ── GET /product ─────────────────────────────────────────────────────────

  /// Fetch products from the backend.
  ///
  /// Production response shape:
  /// ```json
  /// {
  ///   "success": true,
  ///   "message": "...",
  ///   "data": [ { ...product }, ... ],
  ///   "meta": { "page": 1, "limit": 100, "total": 42, "totalPages": 1 }
  /// }
  /// ```
  Future<({List<ProductDto> products, ApiMeta? meta})> getProducts(
    ProductQuery query,
  ) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/product',
      queryParameters: query.toQueryParams(),
    );

    final body = res.data ?? const <String, dynamic>{};
    final rawList = _extractList(body);
    final meta = _extractMeta(body);

    final products = rawList
        .whereType<Map<String, dynamic>>()
        .map(ProductDto.fromJson)
        .toList();

    return (products: products, meta: meta);
  }

  // ── GET /product/:id ─────────────────────────────────────────────────────

  Future<ProductDto> getSingleProduct(String id) async {
    final res = await _dio.get<Map<String, dynamic>>('/product/$id');
    final body = res.data!;
    final raw = _unwrap(body['data']);
    return ProductDto.fromJson(raw as Map<String, dynamic>);
  }

  // ── GET /category ─────────────────────────────────────────────────────────

  Future<List<CategoryDto>> getCategories() async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/category',
      queryParameters: const {'page': 1, 'limit': 100},
    );
    final body = res.data ?? const <String, dynamic>{};
    final rawList = _extractList(body);

    return rawList
        .whereType<Map<String, dynamic>>()
        .map(CategoryDto.fromJson)
        .toList();
  }

  // ── Private ────────────────────────────────────────────────────────────────

  List<dynamic> _extractList(Map<String, dynamic> body) {
    final outerData = body['data'];

    if (outerData is List) {
      return outerData;
    }

    if (outerData is Map<String, dynamic>) {
      final innerData = outerData['data'];
      if (innerData is List) {
        return innerData;
      }
      if (innerData is Map<String, dynamic>) {
        return [innerData];
      }
      return [outerData];
    }

    return const [];
  }

  ApiMeta? _extractMeta(Map<String, dynamic> body) {
    final topLevelMeta = body['meta'];
    if (topLevelMeta is Map<String, dynamic>) {
      return ApiMeta.fromJson(topLevelMeta);
    }

    final outerData = body['data'];
    if (outerData is Map<String, dynamic>) {
      final nestedMeta = outerData['meta'];
      if (nestedMeta is Map<String, dynamic>) {
        return ApiMeta.fromJson(nestedMeta);
      }
    }

    return null;
  }

  dynamic _unwrap(dynamic data) {
    if (data is Map<String, dynamic> && data.containsKey('data')) {
      return data['data'];
    }
    return data;
  }
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => ProductRepository(ref.watch(dioProvider)),
);
