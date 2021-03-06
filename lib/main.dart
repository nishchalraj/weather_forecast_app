import 'package:flutter/material.dart';
import 'package:weather_forecast_app/forecast/background/app_bar.dart';
import 'package:weather_forecast_app/forecast/background/forecast.dart';
import 'package:weather_forecast_app/forecast/background/forecast_list.dart';
import 'package:weather_forecast_app/forecast/background/radial_list.dart';
import 'package:weather_forecast_app/forecast/background/week_drawer.dart';
import 'package:weather_forecast_app/generic_widget/sliding_drawer.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Weather',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.white,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {

  OpenableController openableController;
  SlidingRadialListController slidingListController;
  String selectedDay = 'Monday, August 26';

  @override
  void initState() {
    super.initState();

    openableController = new OpenableController(
      vsync: this,
      openDuration: const Duration(milliseconds: 250),
    )
      ..addListener(() => setState(() {}));

    slidingListController = new SlidingRadialListController(
      itemCount: forecastRadialList.items.length,
      vsync: this,
    )
      ..open();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          new Forecast(
            radialList: forecastRadialList,
            slidingListController: slidingListController,
          ),

          new Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: new ForecastAppBar(
              onDrawerArrowTap: openableController.open,
              selectedDay: selectedDay,
            ),
          ),

          new SlidingDrawer(
            openableController: openableController,
            drawer: new WeekDrawer(
              onDaySelected: (String title) {
                setState(() {
                  selectedDay = title.replaceAll('\n', ', ');
                });

                slidingListController
                    .close()
                    .then((_) => slidingListController.open());

                openableController.close();
              },
            ),
          ),
        ],
      ),
    );
  }
}