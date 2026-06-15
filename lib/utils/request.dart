import "package:dio/dio.dart";

class Request {
  static final Request _instance = Request._createInstance();

  factory Request() => _instance;

  late final Dio _dio;

  final String baseUrl = "http://192.168.10.101:8080";

  Request._createInstance() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          "Content-Type": "application/json",
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) {
          final data = response.data;
          if (data?["code"] == 0) {
            throw Exception(data?["message"] ?? "操作失败");
          }
          return handler.next(response);
        },
        onError: (error, handler) {
          return handler.next(error);
        },
      ),
    );
  }

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? params,
    Options? options,
    required T Function(dynamic) fromJson,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      path,
      queryParameters: params,
      options: options,
    );

    final data = response.data?["data"];
    return fromJson(data);
  }

  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? params,
    Options? options,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      path,
      data: data,
      queryParameters: params,
      options: options,
    );

    final responseData = response.data?["data"] as Map<String, dynamic>;
    return fromJson(responseData);
  }
}
