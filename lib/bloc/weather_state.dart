part of 'weather_bloc.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();
}
// Initiate class when Bloc class called
 class WeatherInitial extends WeatherState {
  @override
  List<Object> get props => [];
}
// Loading data class
class WeatherLoading extends WeatherState {
  @override
  List<Object> get props => [

  ];
}
// Loaded state class
class WeatherLoaded extends WeatherState {
  final WeatherModel weatherModel;

  const WeatherLoaded({ required this.weatherModel});
  @override
  List<Object?> get props => [
    weatherModel,
  ];
}
// Class if got any error
class WeatherFailed extends WeatherState {
  final String error;

  const WeatherFailed(this.error);
  @override
  List<Object> get props => [error];
}