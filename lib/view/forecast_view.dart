// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:weatherreport/controller/forecast_controller.dart';
import 'package:weatherreport/model/city_model.dart';
import 'package:weatherreport/model/weather_model.dart';
import 'package:flutter/material.dart';
import 'package:weatherreport/view/location_not_found.view.dart';
import 'package:date_format/date_format.dart';

class ForecastView extends StatefulWidget {
  final CityModel? actualCity;
  final ValueSetter<CityModel> updateSelectedCityCallback;
  final VoidCallback getLocationCallback;
  final ValueSetter<int> changeScreenCallback;
  final ValueSetter<String> setCityNameToTittleCallback;

  const ForecastView({
    super.key,
    required this.actualCity,
    required this.updateSelectedCityCallback,
    required this.getLocationCallback,
    required this.changeScreenCallback,
    required this.setCityNameToTittleCallback,
  });

  @override
  State<ForecastView> createState() => _ForecastViewState();
}

class _ForecastViewState extends State<ForecastView> {
  final ForecastController _forecastController = ForecastController();

  Future<CityModel>? selectedCityWeather;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getWeatherForSelectedCity(),
      builder: (context, snapshot) {
        if (snapshot.hasError ||
            snapshot.connectionState != ConnectionState.done) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (!snapshot.hasData) {
          return LocationNotFoundView(
              getLocationCallback: widget.getLocationCallback,
              changeScreenCallback: widget.changeScreenCallback);
        }
        CityModel weatherReport = snapshot.data as CityModel;
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            weatherReport.actualWeather.temperature,
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          const Spacer(),
                          ImageIcon(
                            weatherReport.actualWeather.icon,
                            size: MediaQuery.of(context).size.width * 0.25,
                          ),
                        ],
                      ),
                      const Divider(thickness: 2),
                      Text(
                        formatDate(weatherReport.actualWeather.dateTime,
                            [dd, '/', mm, '/', yyyy]),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          WeatherModel().weekdays[
                              weatherReport.actualWeather.dateTime.weekday - 1],
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                      const Divider(thickness: 2),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          children: [
                            const Icon(Icons.cloud_circle),
                            Text(
                              " " +
                                  weatherReport.actualWeather.clouds +
                                  " de nuvens",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          children: [
                            const Icon(Icons.water_drop),
                            Text(
                              " " +
                                  weatherReport.actualWeather.humidity +
                                  " de humidade",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          children: [
                            const Icon(Icons.lock_clock),
                            Text(
                              " " +
                                  formatDate(
                                      weatherReport.actualWeather.dateTime,
                                      [HH, ':', nn]),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          children: [
                            const Icon(Icons.cloud),
                            Text(
                              " O tempo esta: " +
                                  weatherReport.actualWeather.sky,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      weatherReport.actualWeather.rain1h == "0"
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.water_sharp),
                                  Text(
                                    " Millimitros chovidos na ultima hora: " +
                                        weatherReport.actualWeather.rain1h,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                      weatherReport.actualWeather.rain3h == "0"
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.water_sharp),
                                  Text(
                                    " Millimitros chovidos nas ultimas 3 horas: " +
                                        weatherReport.actualWeather.rain3h,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          children: [
                            const Icon(Icons.circle),
                            Text(
                              " Sensação termica de " +
                                  weatherReport.actualWeather.feelsLike,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          children: [
                            const Icon(Icons.wind_power),
                            Text(
                              " Ventos de " +
                                  weatherReport.actualWeather.windSpeed +
                                  " - " +
                                  weatherReport.actualWeather.windDegree,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  getWeatherForSelectedCity() async {
    if (widget.actualCity == null) {
      return null;
    }
    CityModel response = await _forecastController
        .getWeatherForSelectedCity(widget.actualCity as CityModel);
    widget.setCityNameToTittleCallback(response.name == null
        ? 'Cidade'
        : response.name +
            (response.state == null ? "" : (" - " + response.state)) +
            " - " +
            response.country);
    selectedCityWeather = Future.value(response);
    widget.updateSelectedCityCallback(response);
    return selectedCityWeather;
  }
}
