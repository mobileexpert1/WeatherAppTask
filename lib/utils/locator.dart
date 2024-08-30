import 'dart:developer';
import 'package:get_it/get_it.dart';
import 'package:weather_app_bloc/http_service/http_service.dart';
import '../repo/weather_repo.dart';

GetIt locator = GetIt.instance;
// method to add Http and Weather repo to access directly in the classes
Future<void> setupLocator() async {
  locator.registerSingleton<HttpService>(HttpService());
  locator.registerSingleton<WeatherRepository>(WeatherRepositoryImp());
  log('All services started!!! ✅');
}