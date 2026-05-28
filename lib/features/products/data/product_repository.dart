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
    this.limit = 50,
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

  /// Fetch all products — returns data + meta for pagination.
  Future<({List<ProductDto> products, ApiMeta? meta})> getProducts(
    ProductQuery query,
  ) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/product',
      queryParameters: query.toQueryParams(),
    );

    final body = res.data!;
    final meta = body['meta'] != null
        ? ApiMeta.fromJson(body['meta'] as Map<String, dynamic>)
        : null;

    final rawData = body['data'];
    List<dynamic> rawList;

    // QueryBuilder wraps results in { data: [...], meta: {...} }
    if (rawData is Map<String, dynamic> && rawData.containsKey('data')) {
      rawList = rawData['data'] as List<dynamic>;
      // meta may also live inside data
      final innerMeta = rawData['meta'];
      if (innerMeta != null && meta == null) {
        // use inner meta (ignore outer if null)
      }
    } else if (rawData is List) {
      rawList = rawData;
    } else {
      rawList = [];
    }

    final products =
        rawList.map((e) => ProductDto.fromJson(e as Map<String, dynamic>)).toList();

    return (products: products, meta: meta);
  }

  /// Fetch a single product by id.
  Future<ProductDto> getSingleProduct(String id) async {
    final res = await _dio.get<Map<String, dynamic>>('/product/$id');
    final raw = _extractData(res.data!);
    return ProductDto.fromJson(raw as Map<String, dynamic>);
  }

  /// Fetch all categories.
  Future<List<CategoryDto>> getCategories() async {
    final res = await _dio.get<Map<String, dynamic>>('/category');
    final body = res.data!;

    final rawData = body['data'];
    List<dynamic> rawList;

    if (rawData is Map<String, dynamic> && rawData.containsKey('data')) {
      rawList = rawData['data'] as List<dynamic>;
    } else if (rawData is List) {
      rawList = rawData;
    } else {
      rawList = [];
    }

    return rawList
        .map((e) => CategoryDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ── Private ────────────────────────────────────────────────────────────────

  dynamic _extractData(Map<String, dynamic> body) {
    final data = body['data'];
    if (data is Map<String, dynamic> && data.containsKey('data')) {
      return data['data'];
    }
    return data;
  }
}

// ─── Providers ────────────────────────────────────────────────────────────────

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => ProductRepository(ref.watch(dioProvider)),
);
