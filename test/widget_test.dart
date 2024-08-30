
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app_bloc/bloc/weather_bloc.dart';
import 'package:weather_app_bloc/models/weather_model.dart';
import 'package:weather_app_bloc/screens/home_screen.dart';
import 'package:weather_app_bloc/utils/common_button.dart';

void main() {
  group('HomeScreen Widget Tests', () {
    late WeatherBloc weatherBloc;

    setUp(() {
      weatherBloc = WeatherBloc();
    });

    tearDown(() {
      weatherBloc.close();
    });

    testWidgets('Show CircularProgressIndicator when loading',
            (WidgetTester tester) async {
          whenListen(
            weatherBloc,
            Stream.fromIterable([WeatherLoading()]),
            initialState: WeatherLoading(),
          );

          // When home screen widget created
          await tester.pumpWidget(
            MaterialApp(
              home: BlocProvider.value(
                value: weatherBloc,
                child: const HomeScreen(),
              ),
            ),
          );
          // CircularProgressIndicator loading
          expect(find.byType(CircularProgressIndicator), findsOneWidget);
        });

    testWidgets('Weather data when loaded',
            (WidgetTester tester) async {
          // Test Data
          final weatherModel = WeatherModel((b) => b
            ..city.name = 'Test City'
            ..city.country = 'Test Country'
            ..list.add(ListElement((b) => b
              ..dt_txt = '2024-08-24 12:20:00'
              ..main.temp = 298.15)));

          whenListen(
            weatherBloc,
            Stream.fromIterable([WeatherLoaded(weatherModel: weatherModel)]),
            initialState: WeatherLoaded(weatherModel: weatherModel),
          );

          // When home screen widget created
          await tester.pumpWidget(
            MaterialApp(
              home: BlocProvider.value(
                value: weatherBloc,
                child: HomeScreen(),
              ),
            ),
          );

          // Then: The weather data should be displayed
          expect(find.text('Test City, Test Country'), findsOneWidget);
          expect(find.text('24 August 2024'), findsOneWidget);
          expect(find.text('25.00°C'), findsOneWidget);
        });

    testWidgets('Error message when failed',
            (WidgetTester tester) async {
          whenListen(
            weatherBloc,
            Stream.fromIterable([WeatherFailed("error")]),
            initialState: WeatherFailed("error"),
          );

          // When home screen widget created
          await tester.pumpWidget(
            MaterialApp(
              home: BlocProvider.value(
                value: weatherBloc,
                child: HomeScreen(),
              ),
            ),
          );

          // Error message should be displayed
          expect(find.text('Failed to get weather'), findsOneWidget);
          expect(find.byType(GeneralBtn), findsOneWidget);
        });
  });
}
