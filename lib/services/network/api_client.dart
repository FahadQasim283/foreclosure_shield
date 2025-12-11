import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '/core/constants/api_endpoints.dart';
import '../local_storage/token_storage.dart';


class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 51),
        receiveTimeout: const Duration(seconds: 51),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      ),
    );

    _dio.interceptors.addAll([
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ),
      InterceptorsWrapper(onRequest: _onRequest, onResponse: _onResponse, onError: _onError),
    ]);
  }

  Future<void> _onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await TokenStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  Future<void> _onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.statusCode == 401) {
      await TokenStorage.clearAll();
    }
    if (response.data['success']) {
      // NotificationWidgets.showSuccessSnackBar(response.data['message']);
    } else {
    }

    handler.next(response);
  }

  Future<void> _onError(DioException err, ErrorInterceptorHandler handler) async {

    if (err.response?.statusCode == 401) {
      await TokenStorage.clearAll();
    }

    if (err.response?.statusCode == 429) {
      await TokenStorage.clearAll();
    }

    handler.next(err);
  }



  Future<Response> get(String endpoint, {Map<String, dynamic>? queryParams}) {
    //requesting

    return _dio.get(endpoint, queryParameters: queryParams);
  }

  Future<Response> post(String endpoint, {dynamic data}) {
    return _dio.post(endpoint, data: data);
  }

  Future<Response> postMultipart(String endpoint, FormData formData) {
    return _dio.post(endpoint, data: formData);
  }

  Future<Response> put(String endpoint, {dynamic data}) {
    return _dio.put(endpoint, data: data);
  }

  Future<Response> putMultipart(String endpoint, FormData formData) {
    return _dio.put(endpoint, data: formData);
  }

  Future<Response> patch(String endpoint, {dynamic data}) {
    return _dio.patch(endpoint, data: data);
  }

  Future<Response> delete(String endpoint) {
    return _dio.delete(endpoint);
  }
}
