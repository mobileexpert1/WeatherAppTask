import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_collection/built_collection.dart';

part 'weather_model.g.dart';

/// Main model class
abstract class WeatherModel implements Built<WeatherModel, WeatherModelBuilder> {
  String? get cod;
  int? get message;
  int? get cnt;
  BuiltList<ListElement>? get list;
  City? get city;

  WeatherModel._();
  factory WeatherModel([void Function(WeatherModelBuilder) updates]) = _$WeatherModel;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(WeatherModel.serializer, this) as Map<String, dynamic>;
  }

  static WeatherModel? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(WeatherModel.serializer, json);
  }

  static Serializer<WeatherModel> get serializer => _$weatherModelSerializer;
}

/// City model class
abstract class City implements Built<City, CityBuilder> {
  int? get id;
  String? get name;
  Coord? get coord;
  String? get country;
  int? get population;
  int? get timezone;
  int? get sunrise;
  int? get sunset;

  City._();
  factory City([void Function(CityBuilder) updates]) = _$City;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(City.serializer, this) as Map<String, dynamic>;
  }

  static City? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(City.serializer, json);
  }

  static Serializer<City> get serializer => _$citySerializer;
}

/// Coord model class
abstract class Coord implements Built<Coord, CoordBuilder> {
  double? get lat;
  double? get lon;

  Coord._();
  factory Coord([void Function(CoordBuilder) updates]) = _$Coord;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(Coord.serializer, this) as Map<String, dynamic>;
  }

  static Coord? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(Coord.serializer, json);
  }

  static Serializer<Coord> get serializer => _$coordSerializer;
}

/// ListElement model class
abstract class ListElement implements Built<ListElement, ListElementBuilder> {
  int? get dt;
  Main? get main;
  BuiltList<Weather>? get weather;
  Clouds? get clouds;
  Wind? get wind;
  int? get visibility;
  double? get pop;
  Sys? get sys;
  String? get dt_txt;
  Rain? get rain;

  ListElement._();
  factory ListElement([void Function(ListElementBuilder) updates]) = _$ListElement;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(ListElement.serializer, this) as Map<String, dynamic>;
  }

  static ListElement? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(ListElement.serializer, json);
  }

  static Serializer<ListElement> get serializer => _$listElementSerializer;
}

/// Clouds model class
abstract class Clouds implements Built<Clouds, CloudsBuilder> {
  int? get all;

  Clouds._();
  factory Clouds([void Function(CloudsBuilder) updates]) = _$Clouds;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(Clouds.serializer, this) as Map<String, dynamic>;
  }

  static Clouds? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(Clouds.serializer, json);
  }

  static Serializer<Clouds> get serializer => _$cloudsSerializer;
}

/// Main model class
abstract class Main implements Built<Main, MainBuilder> {
  double? get temp;
  double? get feelsLike;
  double? get tempMin;
  double? get tempMax;
  int? get pressure;
  int? get sea_level;
  int? get grnd_level;
  int? get humidity;
  double? get temp_kf;

  Main._();
  factory Main([void Function(MainBuilder) updates]) = _$Main;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(Main.serializer, this) as Map<String, dynamic>;
  }

  static Main? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(Main.serializer, json);
  }

  static Serializer<Main> get serializer => _$mainSerializer;
}

/// Rain model class
abstract class Rain implements Built<Rain, RainBuilder> {
  @BuiltValueField(wireName: '3h')
  double? get the3H;

  Rain._();
  factory Rain([void Function(RainBuilder) updates]) = _$Rain;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(Rain.serializer, this) as Map<String, dynamic>;
  }

  static Rain? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(Rain.serializer, json);
  }

  static Serializer<Rain> get serializer => _$rainSerializer;
}

/// Sys model class
abstract class Sys implements Built<Sys, SysBuilder> {
  String? get pod;

  Sys._();
  factory Sys([void Function(SysBuilder) updates]) = _$Sys;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(Sys.serializer, this) as Map<String, dynamic>;
  }

  static Sys? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(Sys.serializer, json);
  }

  static Serializer<Sys> get serializer => _$sysSerializer;
}

/// Weather model class
abstract class Weather implements Built<Weather, WeatherBuilder> {
  int? get id;
  String? get main;
  String? get description;
  String? get icon;

  Weather._();
  factory Weather([void Function(WeatherBuilder) updates]) = _$Weather;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(Weather.serializer, this) as Map<String, dynamic>;
  }

  static Weather? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(Weather.serializer, json);
  }

  static Serializer<Weather> get serializer => _$weatherSerializer;
}

/// Wind model class
abstract class Wind implements Built<Wind, WindBuilder> {
  double? get speed;
  int? get deg;
  double? get gust;

  Wind._();
  factory Wind([void Function(WindBuilder) updates]) = _$Wind;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(Wind.serializer, this) as Map<String, dynamic>;
  }

  static Wind? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(Wind.serializer, json);
  }

  static Serializer<Wind> get serializer => _$windSerializer;
}

/// Serializers for the models
@SerializersFor([
  WeatherModel,
  City,
  Coord,
  ListElement,
  Clouds,
  Main,
  Rain,
  Sys,
  Weather,
  Wind,
])
final Serializers serializers = (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
