import 'package:flutter/material.dart';
import 'package:project_cut/controller/biometrics_data_controller.dart';
import 'package:project_cut/model/biometric.dart';
import 'package:project_cut/model/cycle.dart';
import 'package:project_cut/model/week.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CurrentWeightNeumorphicCard extends StatelessWidget {
  const CurrentWeightNeumorphicCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).splashColor,
            offset: const Offset(-1, -1),
            blurRadius: 15,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Theme.of(context).shadowColor,
            offset: const Offset(3, 3),
            blurRadius: 5,
            spreadRadius: 0.5,
          ),
        ],
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.contain,
              child: Text(
                'CURRENT WEIGHT',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16,
                ),
              ),
            ),
            Consumer<BiometricsDataController>(
              builder: (context, provider, child) {
                return Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: provider.currentWeight.toString(),
                        style: TextStyle(
                          fontSize: 40,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      TextSpan(
                        text: 'amount',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                  textHeightBehavior:
                      const TextHeightBehavior(applyHeightToFirstAscent: false),
                  textAlign: TextAlign.center,
                  softWrap: false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class NeumorphicCardGrid extends StatelessWidget {
  const NeumorphicCardGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BiometricsDataController>(
      builder: (context, controller, child) {
        return Container(
          height: ((MediaQuery.of(context).size.width / 2) * (2 / 3) * 3) - 24,
          width: MediaQuery.of(context).size.width,
          child: GridView.count(
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(8),
            children: <Widget>[
              Card(
                color: Theme.of(context).colorScheme.primary,
                shadowColor: Colors.white,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          'title',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'value',
                              style: TextStyle(
                                fontSize: 40,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            TextSpan(
                              text: 'amount',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                        textHeightBehavior: const TextHeightBehavior(
                            applyHeightToFirstAscent: false),
                        textAlign: TextAlign.center,
                        softWrap: false,
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
}

class NeumorphicCard extends StatelessWidget {
  const NeumorphicCard(
      {Key? key,
      required this.title,
      required this.value,
      required this.amount})
      : super(key: key);

  final String title;
  final String value;
  final String amount;

  @override
  Widget build(BuildContext context) {
    Icon icon;
    switch (value) {
      case 'settings_icon':
        icon = Icon(
          Icons.settings,
          size: 40,
          color: Theme.of(context).colorScheme.onPrimary,
        );
        break;
      default:
        icon = Icon(
          Icons.camera_alt,
          size: 40,
          color: Theme.of(context).colorScheme.onPrimary,
        );
    }
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).splashColor,
            offset: const Offset(-1, -1),
            blurRadius: 15,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Theme.of(context).shadowColor,
            offset: const Offset(3, 3),
            blurRadius: 5,
            spreadRadius: 0.5,
          ),
        ],
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.contain,
              child: Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16,
                ),
              ),
            ),
            value == 'settings_icon' || value == 'progress_pic_icon'
                ? Padding(
                    padding: const EdgeInsets.all(4),
                    child: icon,
                  )
                : Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: value,
                          style: TextStyle(
                            fontSize: 40,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        TextSpan(
                          text: amount,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                    textHeightBehavior: const TextHeightBehavior(
                        applyHeightToFirstAscent: false),
                    textAlign: TextAlign.center,
                    softWrap: false,
                  ),
          ],
        ),
      ),
    );
  }
}

class WeightLineGraph extends StatefulWidget {
  const WeightLineGraph({Key? key}) : super(key: key);

  @override
  State<WeightLineGraph> createState() => WeightLineGraphState();
}

class WeightLineGraphState extends State<WeightLineGraph> {
  Future? dataFuture;
  Future? testFuture;
  DateTime currentDateTime = DateTime.now();
  int sliderValue = 0;

  String getWeekday(int day) {
    String weekday;
    switch (day) {
      case 1:
        weekday = 'MON';
        break;
      case 2:
        weekday = 'TUE';
        break;
      case 3:
        weekday = 'WED';
        break;
      case 4:
        weekday = 'THU';
        break;
      case 5:
        weekday = 'FRI';
        break;
      case 6:
        weekday = 'SAT';
        break;
      default:
        weekday = 'SUN';
    }

    return weekday;
  }

  @override
  void initState() {
    super.initState();
    dataFuture = Provider.of<BiometricsDataController>(context, listen: false)
        .updateGraphData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BiometricsDataController>(
      builder: (context, controller, child) {
        sliderValue =
            Provider.of<BiometricsDataController>(context, listen: false)
                .getSliderValue
                .toInt();
        if (sliderValue < 0) {
          sliderValue = 1;
        }
        return FutureBuilder(
          future: dataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              List<Biometric> biometrics = controller.biometrics;
              List<Week> weeks = controller.weeks;
              Cycle cycle = controller.cycle;
              biometrics = biometrics
                  .where((element) => element.weekId == sliderValue)
                  .toList();

              DateTime endDateTime = DateTime.parse(cycle.endDateTime);
              int remaining =
                  (endDateTime.difference(currentDateTime).inDays / 7).ceil();
              int total = remaining - controller.getSliderValue.toInt();

              return Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: SfCartesianChart(
                      primaryXAxis:
                          CategoryAxis(labelPlacement: LabelPlacement.onTicks),
                      series: <ChartSeries>[
                        SplineSeries<Biometric, String>(
                            dataSource: biometrics,
                            animationDuration: 0,
                            xValueMapper: (Biometric biometric, _) =>
                                getWeekday(biometric.day),
                            yValueMapper: (Biometric biometric, _) =>
                                biometric.currentWeight,
                            pointColorMapper: (Biometric biometric, index) =>
                                biometric.estimated == 1
                                    ? Colors.lightBlue[200]
                                    : Colors.blue,
                            markerSettings:
                                const MarkerSettings(isVisible: true)),
                        SplineSeries<Biometric, String>(
                          dataSource: biometrics,
                          animationDuration: 0,
                          xValueMapper: (Biometric biometric, _) =>
                              getWeekday(biometric.day),
                          yValueMapper: (datum, index) =>
                              weeks[sliderValue].weightGoal,
                          dashArray: const <double>[5, 5],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Slider(
                        value: sliderValue.toDouble(),
                        max: remaining.toDouble(),
                        min: 1,
                        divisions: remaining - 1,
                        activeColor: Theme.of(context).colorScheme.onPrimary,
                        inactiveColor: Theme.of(context)
                            .colorScheme
                            .onPrimary
                            .withOpacity(0.3),
                        thumbColor: Theme.of(context).colorScheme.onPrimary,
                        onChanged: (double value) {
                          controller.setSliderValue(value);
                        },
                      ),
                      Text(
                        '$total WEEKS REMAINING',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary),
                      )
                    ],
                  ),
                  MaterialButton(
                    child: const Text('test'),
                    onPressed: () => print(biometrics),
                  ),
                ],
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        );
      },
    );
  }
}
