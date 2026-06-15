/// API 响应包装类
class Response<T> {
  final int code;
  final String message;
  final T data;

  Response({
    required this.code,
    required this.message,
    required this.data,
  });
}
