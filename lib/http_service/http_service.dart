import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import '../utils/helper.dart';
import '../wrapper/response_wrapper.dart';


abstract class HttpServiceConst {
  static const int post = 0;
  static const int get = 1;
  static const int delete = 2;
  static const int put = 3;
}

class HttpService {
  late Dio _dio;

  HttpService() {
    _dio = Dio();
  }

  Future<Response> request({
    required String url,
    int requestType = HttpServiceConst.post,
    Map<String, dynamic>? body,
    Map<String, String>? customHeaders,
    bool useBaseUrl = true,
    bool useTokenInBody = true,
  }) async {
    Response response;
    try {
      Map<String, dynamic> map = body ?? {};
      Map<String, String> headers = customHeaders ?? getHeaders();
      String fullUrl = url;
      response = await _checkRequest(
        fullUrl: fullUrl,
        requestType: requestType,
        body: map,
        headers: headers,
      );
      if (response.statusCode == RepoResponseStatus.success) {
        final result = responseChecker(response);
        return Response(
          requestOptions: response.requestOptions,
          data: result,
          statusCode: result['cod']=="200" ? RepoResponseStatus.success : RepoResponseStatus.error,
          statusMessage: response.statusMessage,
        );
      }
    } on SocketException catch (e) {
      blocLog(bloc: "Error message for", msg: "$url: ${e.message}");
      blocLog(bloc: "Error Status Code ", msg: "SocketException");
      throw SocketException(e.message);
    } on DioError catch (e) {
      blocLog(bloc: "Error message for", msg: "$url: ${e.message}");
      blocLog(bloc: "Error response for $url ", msg: "${e.response?.data}");
      blocLog(bloc: "Error Status Code ", msg: "${e.response?.statusCode}");
      throw throwException(e, url: url);
    }
    return response;
  }

  // Function to check the requests(Get/Post/Patch/Delete)
  Future<Response> _checkRequest({
    required String fullUrl,
    required int requestType,
    required Map<String, dynamic> body,
    required Map<String, dynamic> headers,
  }) async {
    if (requestType == HttpServiceConst.get) {
      return await _dio.get(
        fullUrl,
        options: Options(headers: headers),
        queryParameters: body,
      );
    } else if (requestType == HttpServiceConst.post) {
      return await _dio.post(fullUrl,
          data: body, options: Options(headers: headers));
    } else if (requestType == HttpServiceConst.delete) {
      return await _dio.delete(fullUrl,
          data: body, options: Options(headers: headers));
    } else {
      return await _dio.patch(fullUrl,
          data: body, options: Options(headers: headers));
    }
  }
// Api Header method
  Map<String, String> getHeaders() {
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    return headers;
  }
// Exception method
  dynamic throwException(DioError e, {String? url}) {
    if (e.response != null &&
        (e.response?.statusCode == RepoResponseStatus.platformException ||
            e.response?.statusCode == RepoResponseStatus.notFoundException)) {
      throw PlatformException(
        details: e.response?.data['message'].toString(),
        message: e.response?.data['message'].toString(),
        code: "${e.response?.statusCode.toString()}",
        stacktrace: "",
      );
    } else {
      throw Exception(e.message);
    }
  }
}
