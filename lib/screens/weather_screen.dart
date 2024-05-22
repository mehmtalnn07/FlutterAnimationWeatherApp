import "package:deneme/models/weather_model.dart";
import "package:deneme/sevice/weather_service.dart";
import "package:flutter/material.dart";
import "package:lottie/lottie.dart";

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final _weatherService = WeatherService('679976cba5665642cfa06833b662cf2a');
  Weather? _weather;

  _fetchWeather() async {
    String cityName = await _weatherService.getCurrencyCity();

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) {
      return 'assets/sunny.json';
    }
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  String getWeatherBackgroundAnimation(String? mainCondition) {
    if (mainCondition == null) {
      return 'assets/backgroundtwo.json';
    }
    switch (mainCondition.toLowerCase()) {
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/background.json';
      default:
        return 'assets/backgroundtwo.json';
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Mavi arka plan
          Container(
            color: Colors.blue,
            width: double.infinity,
            height: double.infinity,
          ),
          // Arka plan için Lottie animasyonu
          Lottie.asset(
            getWeatherBackgroundAnimation(_weather?.mainCondition),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Diğer içerikler
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 70.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    _weather?.cityName ?? "Loading City...",
                    style: const TextStyle(
                        fontSize: 50,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${_weather?.temperature.round()}°C',
                        style: const TextStyle(
                            fontSize: 50,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 70, // Genişlik değeri
                        height: 70, // Yükseklik değeri
                        child: Lottie.asset("assets/temperature.json"),
                      ),
                    ],
                  ),
                  Text(
                    _weather?.mainCondition ?? "",
                    style: const TextStyle(
                        fontSize: 50,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
