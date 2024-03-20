import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:vanilla_example/base/network/exception/exception.dart';
import 'config/http_config.dart';

typedef SuccessCallback = void Function(String json);
typedef FailureCallback = void Function(int? errCode, String? errMsg);
typedef NetWorkError = void Function(NetworkException e);

class BaseHttpRequest {
  //有3中超时：连接超时、发送超时、接受服务器回应超时
  static final BaseOptions baseOptions = BaseOptions(
      baseUrl: HttpConfig.baseURL,
      connectTimeout: const Duration(milliseconds: HttpConfig.connectTimeOut));
  static final Dio dio = Dio();
  static Future<void> request<T>(
    String url, {
    String method = "get",
    Map<String, dynamic>? params,
    SuccessCallback? successCallback,
    FailureCallback? failureCallback,
    NetWorkError? netWorkError,
  }) async {
    // 创建请求配置
    final option = Options(method: method);
    // 创建全局的拦截器(默认拦截器)
    // onrequest：请求拦截
    // onResponse： 响应拦截
    // onError: 错误拦截
    Interceptor defaultInterceptor = InterceptorsWrapper(
      onRequest: (options, handler) {
        //请求拦截
        print("请求拦截,options=&$options");
      },
      onResponse: (response, handler) {
        print("响应拦截,response=$response");
      },
      onError: (error, handler) {
        //错误拦截
        print("错误拦截,error=$error");
      },
    );
    // 统一添加到拦截区中
    dio.interceptors.add(defaultInterceptor);
    try {
      Response response =
          await dio.request(url, queryParameters: params, options: option);
      if (response.statusCode == 200) {
        _handleResponse(response.data, successCallback, failureCallback);
      } else {
        if (failureCallback != null) {
          failureCallback.call(
              response.statusCode ?? -1, response.statusMessage ?? '');
        }
      }
    } on DioException catch (error) {
      var exception = NetworkException.from(url, error);
      if (netWorkError != null) {
        netWorkError.call(exception);
      }
    }
  }

  static _handleResponse<T>(T? resData, SuccessCallback? successCallback,
      FailureCallback? failureCallback) {
    if (resData is String) {
      dynamic decodeData = jsonDecode(resData);
      if (successCallback != null) {
        successCallback.call(decodeData);
      }
    }
  }
}
