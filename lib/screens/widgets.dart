import 'package:flutter/material.dart';
import 'package:weather_app_bloc/utils/helper.dart';
import 'package:weather_app_bloc/utils/medium_text_widget.dart';
// Custom widget for display the time,temperature
Widget createWeatherEntry(Map<String, String> entry) {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: BodyMediumText(
            title: '${entry['time']}: ${entry['description']}',
            maxLine: 1,
          ),
        ),
        Row(
          children: [
            const Icon(Icons.thermostat, color: Colors.red),
            3.0.spaceX,
            BodyMediumText(title: entry['temperature']!),
          ],
        ),
        Row(
          children: [
            const Icon(Icons.water_drop, color: Colors.blue),
            3.0.spaceX,
            BodyMediumText(title: entry['rainProbability']!),
          ],
        ),
      ],
    ),
  );
}