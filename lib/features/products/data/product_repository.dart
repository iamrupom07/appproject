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
  /// Backend response shape (from QueryBuilder + sendResponse):
  /// ```json
  /// {
  ///   "success": true,
  ///   "message": "...",
  ///   "data": {
  ///     "data": [ { ...product }, ... ],
  ///     "meta": { "page": 1, "limit": 100, "total": 42, "totalPages": 1 }
  ///   }
  /// }
  /// ```
  Future<({List<ProductDto> products, ApiMeta? meta})> getProducts(
    ProductQuery query,
  ) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/product',
      queryParameters: query.toQueryParams(),
    );

    final body = res.data!;

    // The QueryBuilder wraps its result in a nested { data: [...], meta: {...} }
    // inside the outer sendResponse data field.
    final outerData = body['data'];
    List<dynamic> rawList = [];
    ApiMeta? meta;

    if (outerData is Map<String, dynamic>) {
      final innerData = outerData['data'];
      if (innerData is List) {
        rawList = innerData;
      } else if (innerData is Map<String, dynamic>) {
        // edge case: single object wrapped in data
        rawList = [innerData];
      }
      final rawMeta = outerData['meta'];
      if (rawMeta is Map<String, dynamic>) {
        meta = ApiMeta.fromJson(rawMeta);
      }
    } else if (outerData is List) {
      rawList = outerData;
    }

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
    final res = await _dio.get<Map<String, dynamic>>('/category');
    final body = res.data!;

    final outerData = body['data'];
    List<dynamic> rawList = [];

    if (outerData is Map<String, dynamic>) {
      final inner = outerData['data'];
      if (inner is List) rawList = inner;
    } else if (outerData is List) {
      rawList = outerData;
    }

    return rawList
        .whereType<Map<String, dynamic>>()
        .map(CategoryDto.fromJson)
        .toList();
  }

  // ── Private ────────────────────────────────────────────────────────────────

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
