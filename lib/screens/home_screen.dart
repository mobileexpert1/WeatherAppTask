
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather_app_bloc/screens/widgets.dart';
import 'package:weather_app_bloc/utils/common_button.dart';
import 'package:weather_app_bloc/utils/helper.dart';
import 'package:weather_app_bloc/utils/medium_text_widget.dart';
import '../bloc/weather_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    context.read<WeatherBloc>().add(const GetWeatherScreen());
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            16.0.spaceY,
            16.0.spaceY,
            Expanded(
              child: BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) {
                  if (state is WeatherLoading) {
                    return  Center(child: customLoader());
                  }
                  if (state is WeatherLoaded) { //Load state
                    final today = DateTime.now();
                    final nextSixDays = List.generate(6, (index) => today.add(Duration(days: index)));
                    final listByDate = state.weatherModel.list?.where((list) {
                      if (list.dt_txt == null) return false;
                      final dateTime = DateTime.parse(list.dt_txt!.replaceAll(' ', 'T'));
                      return nextSixDays.any((day) => isSameDay(day, dateTime));
                    }).toList() ?? [];
                    final sunrise=state.weatherModel.city?.sunrise;
                    final sunset=state.weatherModel.city?.sunset;
                    final sunriseTime = sunrise != null ? DateFormat('h:mm a').format(DateTime.fromMillisecondsSinceEpoch((sunrise??0) * 1000)) : 'N/A';
                    final sunsetTime = sunset != null ? DateFormat('h:mm a').format(DateTime.fromMillisecondsSinceEpoch((sunset??0) * 1000)) : 'N/A';
                    final entries = <DateTime, List<Map<String, String>>>{};
                    for (var element in listByDate) {
                      if (element.dt_txt == null) continue;
                      final dateTime = DateTime.parse(element.dt_txt!.replaceAll(' ', 'T'));
                      final dateOnly = DateTime(dateTime.year, dateTime.month, dateTime.day);
                      final time = formatTime(element.dt_txt!);
                      final weatherDescription = element.weather?.first.description ?? 'Unknown';
                      final tempInCelsius = (element.main?.temp ?? 0.0) - 273.15;
                      final temp = tempInCelsius.toStringAsFixed(2);
                      final rainProbability = (element.pop ?? 0.0) * 100;
                      final entry = {
                        'time': time,
                        'description': weatherDescription,
                        'temperature': '$temp°C',
                        'rainProbability': '${rainProbability.toStringAsFixed(0)}%',
                      };

                      if (entries.containsKey(dateOnly)) {
                        entries[dateOnly]?.add(entry);
                      } else {
                        entries[dateOnly] = [entry];
                      }
                    }
                    return RefreshIndicator(
                      onRefresh: () async {
                          context.read<WeatherBloc>().add(const GetWeatherScreen());
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BodyMediumText(
                                title: '${state.weatherModel.city?.name}, ${state.weatherModel.city?.country}',
                                fontSize: 16,
                              ),
                              8.0.spaceX,
                              Column(
                                children: [
                                  BodyMediumText(
                                    title: 'Sunrise: $sunriseTime',
                                    fontSize: 14,
                                  ),
                                  BodyMediumText(
                                    title: 'Sunset: $sunsetTime',
                                    fontSize: 14,
                                  ),
                                ],
                              ),
                            ],
                          ),


                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: entries.length,
                              itemBuilder: (context, index) {
                                final date = entries.keys.elementAt(index);
                                final data = entries[date]!;
                                return Container(
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.blue.shade100,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      BodyMediumText(title: formatDateTime(date.toString())),
                                      ...data.map(createWeatherEntry),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  if (state is WeatherFailed) { // If api failed to get the data
                    return  Center(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const BodyMediumText(title: "Failed to get weather",fontSize: 16.0,),
                        10.0.spaceY,
                        SizedBox(
                          width: screenWidth(context)/2,
                          child: GeneralBtn(

                            title: "Try again",
                             onTap:() async {
                                 context.read<WeatherBloc>().add(const GetWeatherScreen());

                             },),
                        )
                      ],
                    ));
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );

  }

}
