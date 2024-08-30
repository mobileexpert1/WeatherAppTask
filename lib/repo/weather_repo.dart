

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app_bloc/http_service/http_service.dart';
import 'package:weather_app_bloc/models/weather_model.dart';
import 'package:weather_app_bloc/utils/locator.dart';

import '../wrapper/response_wrapper.dart';

abstract class WeatherRepository {
  Future<ResponseWrapper> getWeather({required String? lat,required String? long});
}

class WeatherRepositoryImp extends WeatherRepository {

  @override
  Future<ResponseWrapper> getWeather(
      {required String? lat,required String? long}) async {
    try {
      final response = await locator<HttpService>().request(
        url: "${dotenv.env['BASE_URL']}forecast?lat=$lat&lon=$long&appid=${dotenv.env['APP_ID']}",
        requestType: HttpServiceConst.get,
      );
      if (response.statusCode == RepoResponseStatus.success) {
        WeatherModel? model=WeatherModel.fromJson(response.data);
        return getSuccessResponseWrapper(model);
      } else {
        return getFailedResponseWrapper(response.statusMessage);
      }
    } catch (e,s) {
      return getFailedResponseWrapper(exceptionHandler(
        e: s,
        functionName: "getWeather",
      ));
    }
  }
}
