import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio;

  DioClient._internal(this._dio);

  static final DioClient _instance = DioClient._create();

  factory DioClient() => _instance;

  // Singleton Dio instance
  static DioClient _create() {
    final dio = Dio();

    dio.options = BaseOptions(
      baseUrl: "https://fakestoreapi.com", // Replace with your base URL
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      contentType: 'application/json',
      headers: {
        'Accept': 'application/json',
      },
    );

    // Add interceptors
    dio.interceptors.addAll([
      LogInterceptor(requestBody: true, responseBody: true), // For logging
    ]);

    return DioClient._internal(dio);
  }

  Dio get dio => _dio;

  void setHeaders(Map<String, dynamic> headers) {
    _dio.options.headers.addAll(headers);
  }
}

class TokenInterceptor extends Interceptor {
  final Dio _dio;

  TokenInterceptor(this._dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Add the token dynamically
    final token = await getToken(); // Replace with your token retrieval logic
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Handle token refresh
      final newToken = await refreshToken(); // Replace with your token refresh logic
      if (newToken != null) {
        // Retry the failed request with a new token
        final opts = err.requestOptions;
        opts.headers['Authorization'] = 'Bearer $newToken';
        final cloneReq = await _dio.request(
          opts.path,
          options: Options(
            method: opts.method,
            headers: opts.headers,
          ),
          data: opts.data,
          queryParameters: opts.queryParameters,
        );
        return handler.resolve(cloneReq);
      }
    }
    super.onError(err, handler);
  }
}

// Simulated token retrieval
Future<String?> getToken() async {
  // Retrieve the token from secure storage or a similar source
  return "your_access_token";
}

// Simulated token refresh logic
Future<String?> refreshToken() async {
  // Implement your token refresh logic here
  // E.g., make a call to your server's refresh token endpoint
  return "new_access_token";
}
