
import 'package:bot_toast/bot_toast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

double screenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

extension SpaceXY on double {
  SizedBox get spaceX => SizedBox(width: this); // For horizontal space
  SizedBox get spaceY => SizedBox(height: this); // For vertical space
}

void _printLog(dynamic msg) {
  if (kDebugMode) {
    debugPrint(msg.toString());
  }
}

void blocLog({required String msg, required String bloc}) {
  _printLog("\x1B[31m${bloc.toString()} ::==> ${msg.toString()}\x1B[0m");
}
//Custom loader widget
Widget customLoader({
  double height = 35,
  double width = 35,
  Color color = Colors.blue,
  double? value,
}) {
  return SizedBox(
    height: height,
    width: width,
    child: CircularProgressIndicator(
      color: color,
      value: value,
    ),
  );
}

/// This function checks for location permission and returns the current position if
/// permission is granted.
Future<Position?> currentPosition() async {
  LocationPermission permission;
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.deniedForever) {
      toast(
        msg:
        "Location Not Available",
      );
    }
  }else if(permission ==  LocationPermission.deniedForever){
    return null;
  }
  return await Geolocator.getCurrentPosition();
}

// Function to Display message popup
void toast({required String msg, bool isError = true}) {
  BotToast.showCustomText(
      duration: const Duration(seconds: 2),
      toastBuilder: (cancelFunc) => Align(
        alignment: const Alignment(0, 0.8),
        child: Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 4.0,
                  spreadRadius: 0.0,
                  offset: const Offset(
                    0.0,
                    2.0,
                  ),
                )
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: isError
                          ? Colors.red.withOpacity(0.2)
                          : Colors.green.withOpacity(0.2),
                    ),
                    child: Icon(
                      isError ? Icons.error : Icons.done_all,
                      color: isError ? Colors.red : Colors.green,
                    ),
                  ),
                  10.0.spaceX,
                  Flexible(
                    child: Text(
                      msg,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isError ? Colors.red : Colors.green,
                      ),
                    ),
                  ),
                 10.0.spaceX,
                ],
              ),
            ],
          ),
        ),
      ));
}

// Function to parse and format date
String formatDateTime(String dateTimeStr, {String format = 'EEEE, MMM d'}) {
  final dateTime = DateTime.parse(dateTimeStr.replaceAll(' ', 'T'));
  return DateFormat(format).format(dateTime);
}

// Function to format time
String formatTime(String dateTimeStr) {
  final dateTime = DateTime.parse(dateTimeStr.replaceAll(' ', 'T'));
  return DateFormat('h:mm a').format(dateTime);
}
// Function to Check for the current day
bool isSameDay(DateTime day1, DateTime day2) {
  return day1.year == day2.year &&
      day1.month == day2.month &&
      day1.day == day2.day;
}

// Function to Check for the internet connectivity
class ConnectivityManager{
  final Connectivity connectivity = Connectivity();
  ConnectivityManager._privateConstructor();
  static final ConnectivityManager _instance = ConnectivityManager._privateConstructor();
  static ConnectivityManager get instance => _instance;

  Future<bool> isOnline() async {
    List<ConnectivityResult> connectivityResult = await connectivity.checkConnectivity();
    return !connectivityResult.contains(ConnectivityResult.none);
  }

}
