part of 'weather_bloc.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();
}
// Class to call event
class GetWeatherScreen extends WeatherEvent {
  const GetWeatherScreen();

  @override
  List<Object?> get props => [

  ];
}