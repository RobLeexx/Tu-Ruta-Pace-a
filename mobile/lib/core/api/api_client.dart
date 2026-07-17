import 'package:ayni_ruta/core/config/app_config.dart';
import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ApiClient {
  ApiClient()
    : _dio = Dio(
        BaseOptions(
          baseUrl: AppConfig.apiBaseUrl,
          contentType: 'application/json',
          validateStatus: (_) => true,
        ),
      );

  final Dio _dio;

  Future<Map<String, dynamic>> get(String path) => _request('GET', path);

  Future<Map<String, dynamic>> post(String path, {Object? data}) =>
      _request('POST', path, data: data);

  Future<Map<String, dynamic>> patch(String path, {Object? data}) =>
      _request('PATCH', path, data: data);

  Future<Map<String, dynamic>> _request(
    String method,
    String path, {
    Object? data,
  }) async {
    try {
      final token = Supabase.instance.client.auth.currentSession?.accessToken;
      if (token == null) {
        throw const ApiException('Tu sesión expiró. Vuelve a iniciar sesión.');
      }

      final response = await _dio.request<dynamic>(
        path,
        data: data,
        options: Options(
          method: method,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      final body = response.data;
      if (body is! Map<String, dynamic>) {
        throw const ApiException('La respuesta del servidor no es válida.');
      }
      final error = body['error'];
      if (response.statusCode == null ||
          response.statusCode! >= 400 ||
          error != null) {
        final message = error is Map<String, dynamic> ? error['message'] : null;
        throw ApiException(
          message is String ? message : 'No se pudo completar la solicitud.',
        );
      }
      final payload = body['data'];
      if (payload is! Map<String, dynamic>) {
        throw const ApiException(
          'La respuesta del servidor no tiene datos válidos.',
        );
      }
      return payload;
    } on DioException {
      throw const ApiException('No se pudo conectar con el servidor.');
    }
  }
}
