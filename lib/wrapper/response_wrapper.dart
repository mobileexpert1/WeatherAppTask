import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import '../utils/helper.dart';
// Api response handler class
class ResponseWrapper {
  int? status;
  String? message;
  dynamic response;

  ResponseWrapper({
    this.status,
    this.message,
    this.response,
  });

  ResponseWrapper.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
    response = json["response"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["status"] = status;
    data["message"] = message;
    data["response"] = response;
    return data;
  }
}

abstract class RepoResponseStatus {
  static const int error = 500;
  static const int success = 200;
  static const int authentication = 401;
  static const int subscriptionExpire = 0;
  static const int platformException = 400;
  static const int notFoundException = 404;
  static const int serverIsTemporarilyUnable = 503;
}

dynamic responseChecker(Response<dynamic> response) {
  return (response.data.runtimeType == String)
      ? (jsonDecode(response.data))
      : (response.data);
}

ResponseWrapper getSuccessResponseWrapper(dynamic response) => ResponseWrapper(
  status: RepoResponseStatus.success,
  response: response,
);

ResponseWrapper getFailedResponseWrapper(dynamic e, {dynamic response}) =>
    ResponseWrapper(
      status: RepoResponseStatus.error,
      message: e.toString(),
      response: response ?? false,
    );

String exceptionHandler({
  required Object e,
  required String functionName,
}) {
   if (e is PlatformException) {
    blocLog(
      msg: e.message ?? e.toString(),
      bloc: "PlatformException in ==>$functionName",
    );
    return e.message ?? e.toString();
  } else if (e is ConnectingTimedOut) {
    blocLog(
      msg: e.message ?? e.toString(),
      bloc: "ConnectingTimedOut in ==>$functionName",
    );
    return e.message ?? e.toString();
  } else if (e is SocketException) {
    blocLog(
      msg: e.message,
      bloc: "SocketException in ==>$functionName",
    );
    return e.message;
  } else if (e.toString().toLowerCase().contains("SocketException".toLowerCase())) {
    blocLog(
      msg: "Connection Timeout, Please Try Again",
      bloc: "SocketException ==>$functionName",
    );
    return "Connection Timeout, Please Try Again";
  } else {
    blocLog(
      msg: e.toString(),
      bloc: functionName,
    );
    return e.toString();
  }
}

class Errors {
  Errors();

  factory Errors.fromJson(Map<String, dynamic> json) => Errors(
  );

  Map<String, dynamic> toJson() => {
  };
}

class GeneralModel {
  String? message;
  bool? status;
  Errors? errors;
  dynamic data;
  int? statusCode;

  GeneralModel(
      {this.message, this.status, this.data, this.statusCode, this.errors});

  factory GeneralModel.fromJson(Map<String, dynamic> json) => GeneralModel(
    message: json['message'] as String?,
    statusCode: json['statusCode'] as int?,
    status: json['status'] as bool?,
    data: json['data'],
    errors: json["errors"] == null ? null : Errors.fromJson(json["errors"]),
  );

  Map<String, dynamic> toJson() => {
    'message': message,
    'status': status,
    'data': data,
    'statusCode': statusCode,
    "errors": errors?.toJson(),
  };
}

// Timeout exception
class ConnectingTimedOut implements Exception {
  String? message;

  ConnectingTimedOut(String? _message) {
    message = _message;
  }
}