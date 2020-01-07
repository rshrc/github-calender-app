// To parse this JSON data, do
//
//     final wheatherModel = wheatherModelFromJson(jsonString);

import 'dart:convert';

class WheatherModel {
  HourlyForecasts hourlyForecasts;
  DateTime feedCreation;
  bool metric;

  WheatherModel({
    this.hourlyForecasts,
    this.feedCreation,
    this.metric,
  });

  factory WheatherModel.fromJson(String str) =>
      WheatherModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory WheatherModel.fromMap(Map<String, dynamic> json) => new WheatherModel(
        hourlyForecasts: json["hourlyForecasts"] == null
            ? null
            : HourlyForecasts.fromMap(json["hourlyForecasts"]),
        feedCreation: json["feedCreation"] == null
            ? null
            : DateTime.parse(json["feedCreation"]),
        metric: json["metric"] == null ? null : json["metric"],
      );

  Map<String, dynamic> toMap() => {
        "hourlyForecasts":
            hourlyForecasts == null ? null : hourlyForecasts.toMap(),
        "feedCreation":
            feedCreation == null ? null : feedCreation.toIso8601String(),
        "metric": metric == null ? null : metric,
      };
}

class HourlyForecasts {
  ForecastLocation forecastLocation;

  HourlyForecasts({
    this.forecastLocation,
  });

  factory HourlyForecasts.fromJson(String str) =>
      HourlyForecasts.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory HourlyForecasts.fromMap(Map<String, dynamic> json) =>
      new HourlyForecasts(
        forecastLocation: json["forecastLocation"] == null
            ? null
            : ForecastLocation.fromMap(json["forecastLocation"]),
      );

  Map<String, dynamic> toMap() => {
        "forecastLocation":
            forecastLocation == null ? null : forecastLocation.toMap(),
      };
}

class ForecastLocation {
  List<Forecast> forecast;
  String country;
  String state;
  String city;
  double latitude;
  double longitude;
  double distance;
  int timezone;

  ForecastLocation({
    this.forecast,
    this.country,
    this.state,
    this.city,
    this.latitude,
    this.longitude,
    this.distance,
    this.timezone,
  });

  factory ForecastLocation.fromJson(String str) =>
      ForecastLocation.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ForecastLocation.fromMap(Map<String, dynamic> json) =>
      new ForecastLocation(
        forecast: json["forecast"] == null
            ? null
            : new List<Forecast>.from(
                json["forecast"].map((x) => Forecast.fromMap(x))),
        country: json["country"] == null ? null : json["country"],
        state: json["state"] == null ? null : json["state"],
        city: json["city"] == null ? null : json["city"],
        latitude: json["latitude"] == null ? null : json["latitude"].toDouble(),
        longitude:
            json["longitude"] == null ? null : json["longitude"].toDouble(),
        distance: json["distance"] == null ? null : json["distance"],
        timezone: json["timezone"] == null ? null : json["timezone"],
      );

  Map<String, dynamic> toMap() => {
        "forecast": forecast == null
            ? null
            : new List<dynamic>.from(forecast.map((x) => x.toMap())),
        "country": country == null ? null : country,
        "state": state == null ? null : state,
        "city": city == null ? null : city,
        "latitude": latitude == null ? null : latitude,
        "longitude": longitude == null ? null : longitude,
        "distance": distance == null ? null : distance,
        "timezone": timezone == null ? null : timezone,
      };
}

class Forecast {
  String daylight;
  String description;
  String skyInfo;
  String skyDescription;
  String temperature;
  String temperatureDesc;
  String comfort;
  String humidity;
  String dewPoint;
  String precipitationProbability;
  String precipitationDesc;
  String rainFall;
  String snowFall;
  String airInfo;
  String airDescription;
  String windSpeed;
  String windDirection;
  String windDesc;
  String windDescShort;
  String visibility;
  String icon;
  String iconName;
  String iconLink;
  String dayOfWeek;
  String weekday;
  DateTime utcTime;
  String localTime;
  String localTimeFormat;

  Forecast({
    this.daylight,
    this.description,
    this.skyInfo,
    this.skyDescription,
    this.temperature,
    this.temperatureDesc,
    this.comfort,
    this.humidity,
    this.dewPoint,
    this.precipitationProbability,
    this.precipitationDesc,
    this.rainFall,
    this.snowFall,
    this.airInfo,
    this.airDescription,
    this.windSpeed,
    this.windDirection,
    this.windDesc,
    this.windDescShort,
    this.visibility,
    this.icon,
    this.iconName,
    this.iconLink,
    this.dayOfWeek,
    this.weekday,
    this.utcTime,
    this.localTime,
    this.localTimeFormat,
  });

  factory Forecast.fromJson(String str) => Forecast.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Forecast.fromMap(Map<String, dynamic> json) => new Forecast(
        daylight: json["daylight"] == null ? null : json["daylight"],
        description: json["description"] == null ? null : json["description"],
        skyInfo: json["skyInfo"] == null ? null : json["skyInfo"],
        skyDescription:
            json["skyDescription"] == null ? null : json["skyDescription"],
        temperature: json["temperature"] == null ? null : json["temperature"],
        temperatureDesc:
            json["temperatureDesc"] == null ? null : json["temperatureDesc"],
        comfort: json["comfort"] == null ? null : json["comfort"],
        humidity: json["humidity"] == null ? null : json["humidity"],
        dewPoint: json["dewPoint"] == null ? null : json["dewPoint"],
        precipitationProbability: json["precipitationProbability"] == null
            ? null
            : json["precipitationProbability"],
        precipitationDesc: json["precipitationDesc"] == null
            ? null
            : json["precipitationDesc"],
        rainFall: json["rainFall"] == null ? null : json["rainFall"],
        snowFall: json["snowFall"] == null ? null : json["snowFall"],
        airInfo: json["airInfo"] == null ? null : json["airInfo"],
        airDescription:
            json["airDescription"] == null ? null : json["airDescription"],
        windSpeed: json["windSpeed"] == null ? null : json["windSpeed"],
        windDirection:
            json["windDirection"] == null ? null : json["windDirection"],
        windDesc: json["windDesc"] == null ? null : json["windDesc"],
        windDescShort:
            json["windDescShort"] == null ? null : json["windDescShort"],
        visibility: json["visibility"] == null ? null : json["visibility"],
        icon: json["icon"] == null ? null : json["icon"],
        iconName: json["iconName"] == null ? null : json["iconName"],
        iconLink: json["iconLink"] == null ? null : json["iconLink"],
        dayOfWeek: json["dayOfWeek"] == null ? null : json["dayOfWeek"],
        weekday: json["weekday"] == null ? null : json["weekday"],
        utcTime:
            json["utcTime"] == null ? null : DateTime.parse(json["utcTime"]),
        localTime: json["localTime"] == null ? null : json["localTime"],
        localTimeFormat:
            json["localTimeFormat"] == null ? null : json["localTimeFormat"],
      );

  Map<String, dynamic> toMap() => {
        "daylight": daylight == null ? null : daylight,
        "description": description == null ? null : description,
        "skyInfo": skyInfo == null ? null : skyInfo,
        "skyDescription": skyDescription == null ? null : skyDescription,
        "temperature": temperature == null ? null : temperature,
        "temperatureDesc": temperatureDesc == null ? null : temperatureDesc,
        "comfort": comfort == null ? null : comfort,
        "humidity": humidity == null ? null : humidity,
        "dewPoint": dewPoint == null ? null : dewPoint,
        "precipitationProbability":
            precipitationProbability == null ? null : precipitationProbability,
        "precipitationDesc":
            precipitationDesc == null ? null : precipitationDesc,
        "rainFall": rainFall == null ? null : rainFall,
        "snowFall": snowFall == null ? null : snowFall,
        "airInfo": airInfo == null ? null : airInfo,
        "airDescription": airDescription == null ? null : airDescription,
        "windSpeed": windSpeed == null ? null : windSpeed,
        "windDirection": windDirection == null ? null : windDirection,
        "windDesc": windDesc == null ? null : windDesc,
        "windDescShort": windDescShort == null ? null : windDescShort,
        "visibility": visibility == null ? null : visibility,
        "icon": icon == null ? null : icon,
        "iconName": iconName == null ? null : iconName,
        "iconLink": iconLink == null ? null : iconLink,
        "dayOfWeek": dayOfWeek == null ? null : dayOfWeek,
        "weekday": weekday == null ? null : weekday,
        "utcTime": utcTime == null ? null : utcTime.toIso8601String(),
        "localTime": localTime == null ? null : localTime,
        "localTimeFormat": localTimeFormat == null ? null : localTimeFormat,
      };
}
