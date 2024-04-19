import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_info.dart';
import 'package:weather_app/hourly_forecasr.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';
// ignore: must_be_immutable
class WeatherScreen extends StatefulWidget {
   const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;
  Future<Map<String, dynamic>> getCurrentWeather() async{
   try {
    String cityName = 'London';
    final res = await http.get(
      Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey'
      )
    );

    final data = jsonDecode(res.body);

    if(data['cod'] != '200'){
      throw 'An unexpected error occurred';
    }
    return data;
       //temp = data['list'][0]['main']['temp'];
    
   
   }catch(e){
     throw(e.toString());
   }
  }
  @override
  void initState(){
    super.initState();
    weather = getCurrentWeather();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: (){
              setState(() {
                weather = getCurrentWeather();
              });
            }, 
            icon: const Icon(Icons.refresh)
          )
        ],
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if(snapshot.hasError){
            return Center(child: Text(snapshot.error.toString()));
          }
          final data = snapshot.data!;
          final currentTemp = data['list'][0]['main']['temp'];
          final currenntSky = data['list'][0]['weather'][0]['main'];
          final currentPressure = data['list'][0]['main']['pressure'];
          final currentWindSpeed = data['list'][0]['wind']['speed'];
          final currentHumidity = data['list'][0]['main']['humidity'];


          return Padding(
          padding: const EdgeInsets.all(16.0),
          child:  Column(
            children: [
                //mainCard
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 10,
                          sigmaY: 10,
                        ),
                        child:  Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text('$currentTemp K',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold
                              ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Icon(
                                currenntSky == 'Clouds' || currenntSky == 'Rain'? Icons.cloud: Icons.sunny,
                              size: 64,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Text(
                                currenntSky,
                                style: const TextStyle(
                                fontSize: 20,
                              ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Hourly Forecast',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                /*SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for(int i=0; i<38; i++)
                           HourlyForecastItem(
                            time: '9:00',
                            icon1: data['list'][i+1]['weather'][0]['main'] == 'Clouds'||data['list'][i+1]['weather'][0]['main'] == 'Rain'? Icons.cloud : Icons.sunny,
                            value1: data['list'][i+1]['main']['temp'].toString(),
                           ),
                    ],
                  ),
                ),*/
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    itemCount: 8,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final hourlyForecast = data['list'][index+1];
                      final time = DateTime.parse(hourlyForecast['dt_txt']);
                      return HourlyForecastItem(
                        time: DateFormat.j().format(time), 
                        icon1: data['list'][index+1]['weather'][0]['main'] == 'Clouds'||data['list'][index+1]['weather'][0]['main'] == 'Rain'? Icons.cloud : Icons.sunny, 
                        value1: hourlyForecast['main']['temp'].toString()
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Additional Information',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:  [
                  AdditionalInfoItem(
                    icon: Icons.water_drop,
                    label: 'Humidity',
                    value: currentHumidity.toString(),
                  ),
                  AdditionalInfoItem(
                    icon: Icons.air,
                    label: 'Wind Speed',
                    value: currentWindSpeed.toString(),
                  ),
                  AdditionalInfoItem(
                    icon: Icons.beach_access,
                    label: 'Pressure',
                    value: currentPressure.toString(),
                  ),
                  ],
                )
            ]
          ),
        );
        },
      ),
    );
  }
}
