import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:weather_app_bloc/models/weather_model.dart';
import 'package:weather_app_bloc/repo/weather_repo.dart';
import 'package:weather_app_bloc/utils/helper.dart';
import 'package:weather_app_bloc/utils/locator.dart';
import 'package:weather_app_bloc/wrapper/response_wrapper.dart';
part 'weather_event.dart';
part 'weather_state.dart';

// Class to get data from api
class WeatherBloc extends HydratedBloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherInitial()) {
    on<GetWeatherScreen>(_onGetWeather);
  }

  // Function to get data from api
  Future<void> _onGetWeather(GetWeatherScreen event, Emitter<WeatherState> emit) async {
    try {
      bool isOnline = await ConnectivityManager.instance.isOnline(); // Check network is online/offline
      final currentState = state;

      if (currentState is WeatherLoaded && !isOnline) {
        emit(currentState);
      } else {
        emit(WeatherLoading());
        final res = await currentPosition();
        if (res != null && res is Position) {
          final result = await locator<WeatherRepository>().getWeather(
            lat: res.latitude.toString(),
            long: res.longitude.toString(),
          );
          if (result.status == RepoResponseStatus.success) {
            final weatherModel = result.response;
            emit(WeatherLoaded(weatherModel: weatherModel));
          } else {
            emit(WeatherFailed(result.message.toString()));
          }
        } else {
          emit(const WeatherFailed('Failed to fetch location'));
        }
      }
    } catch (e) {
      emit(WeatherFailed(e.toString()));
    }
  }

  @override
  Map<String, dynamic>? toJson(WeatherState state) {
    if (state is WeatherLoaded) {
      return state.weatherModel.toJson();
    }
    return null;
  }

  @override
  WeatherState? fromJson(Map<String, dynamic> json) {
    try {
      WeatherModel? weatherModel = WeatherModel.fromJson(json);
      return WeatherLoaded(weatherModel: weatherModel??WeatherModel());
    } catch (_) {
      return null;
    }
  }
}


