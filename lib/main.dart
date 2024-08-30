import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weather_app_bloc/bloc/weather_bloc.dart';
import 'package:weather_app_bloc/screens/home_screen.dart';
import 'package:weather_app_bloc/utils/app_bloc_observer.dart';
import 'package:weather_app_bloc/utils/locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  await dotenv.load(fileName: "assets/.env");
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  );
  Bloc.observer = AppBlocObserver();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  final botToastBuilder = BotToastInit();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => WeatherBloc(),
  child: MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      builder: (context, child) {
        child = botToastBuilder(context, child);
        return child;
      },
      navigatorObservers: [BotToastNavigatorObserver()]
    ),
);
  }
}


