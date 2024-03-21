import 'package:dio/dio.dart';

class NetworkException implements Exception {
  static const unknownException = "未知错误";
  final String? message;
  final int? code;
  String? stackInfo;
  String? requestUrl;

  NetworkException([this.requestUrl, this.code, this.message]);
  factory NetworkException.fromDioError(DioException error) {
    final requestUrl = error.requestOptions.uri.toString();
    switch (error.type) {
      case DioExceptionType.cancel:
        return BadRequestException(requestUrl, -1, "请求取消");
      case DioExceptionType.connectionTimeout:
        return BadRequestException(requestUrl, -1, "连接超时");
      case DioExceptionType.sendTimeout:
        return BadRequestException(requestUrl, -1, "请求超时");
      case DioExceptionType.receiveTimeout:
        return BadRequestException(requestUrl, -1, "响应超时");
      case DioExceptionType.badResponse:
        try {
          if (error.response?.data != null) {
            return NetworkException(
                requestUrl, error.response!.statusCode, "请求超时，请稍后重试");
          }
          int? errCode = error.response?.statusCode;
          switch (errCode) {
            case 400:
              return BadRequestException(requestUrl, errCode, "请求超时，请稍后重试");
            case 401:
              return UnauthorisedException(requestUrl, errCode!, "登录已失效，请重新登录");
            case 403:
              return UnauthorisedException(
                  requestUrl, errCode!, "暂无权限，请联系运营开通");
            case 404:
              return UnauthorisedException(
                  requestUrl, errCode!, "无法连接服务器，请稍后重试");
            case 405:
              return UnauthorisedException(requestUrl, errCode!, "请求超时，请稍后重试");
            case 500:
              return UnauthorisedException(requestUrl, errCode!, "服务器异常，请稍后重试");
            case 502:
              return UnauthorisedException(requestUrl, errCode!, "请求超时，请稍后重试");
            case 503:
              return UnauthorisedException(requestUrl, errCode!, "服务器异常，请稍后重试");
            case 504:
              return UnauthorisedException(requestUrl, errCode!, "请求超时，请稍后重试");
            case 505:
              return UnauthorisedException(requestUrl, errCode!, "服务器异常，请稍后重试");
            default:
              return NetworkException(requestUrl, errCode, '系统异常，请稍后重试');
          }
        } on Exception catch (_) {
          return NetworkException(requestUrl, -1, unknownException);
        }
      default:
        return NetworkException(requestUrl, -1, "请求超时，请稍后重试");
    }
  }

  factory NetworkException.from(String? requestUrl, dynamic exception) {
    if (exception is DioException) {
      return NetworkException.fromDioError(exception);
    }
    if (exception is NetworkException) {
      return exception;
    } else {
      var apiException = NetworkException(requestUrl, -1, unknownException);
      apiException.stackInfo = exception?.toString();
      return apiException;
    }
  }

  @override
  String toString() {
    return 'message: $message';
  }
}

class BadRequestException extends NetworkException {
  BadRequestException([String? requestUrl, int? code, String? message])
      : super(requestUrl, code, message);
}

class UnauthorisedException extends NetworkException {
  UnauthorisedException(
      [String? requestUrl, int code = -1, String message = ''])
      : super(requestUrl, code, message);
}
