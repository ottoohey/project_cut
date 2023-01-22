import 'package:flutter/material.dart';
import 'package:project_cut/providers/biometrics_data_controller.dart';
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
                        text: 'kg',
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

class WeeklyDataGrid extends StatelessWidget {
  const WeeklyDataGrid({Key? key}) : super(key: key);

  final String _calorieDeficit = 'CALORIE_DEFICIT';
  final String _weightLoss = 'WEIGHT_LOSS';
  final String _bodyFat = 'BODY_FAT';
  final String _weightGoal = 'WEIGHT_GOAL';

  @override
  Widget build(BuildContext context) {
    return Consumer<BiometricsDataController>(
      builder: (context, provider, child) {
        return SizedBox(
          height: ((MediaQuery.of(context).size.width / 2) * (2 / 3) * 2) - 24,
          width: MediaQuery.of(context).size.width,
          child: GridView.count(
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(8),
            children: <Widget>[
              WeeklyDataGridCard(
                card: _calorieDeficit,
              ),
              WeeklyDataGridCard(
                card: _weightLoss,
              ),
              WeeklyDataGridCard(
                card: _bodyFat,
              ),
              WeeklyDataGridCard(
                card: _weightGoal,
              ),
            ],
          ),
        );
      },
    );
  }
}

class WeeklyDataGridCard extends StatelessWidget {
  const WeeklyDataGridCard({Key? key, required this.card}) : super(key: key);

  final String card;

  String _getCardTitle() {
    switch (card) {
      case 'CALORIE_DEFICIT':
        return 'CALORIE DEFICIT';
      case 'WEIGHT_LOSS':
        return 'WEIGHT LOSS';
      case 'BODY_FAT':
        return 'BODY FAT';
      case 'WEIGHT_GOAL':
        return 'WEIGHT GOAL';
      default:
        return 'NO TITLE';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: card == 'SETTINGS' || card == 'PROGRESS_PIC'
              ? Theme.of(context).colorScheme.secondary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  _getCardTitle(),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16,
                  ),
                ),
              ),
              Consumer<BiometricsDataController>(
                builder: (context, provider, child) {
                  String cardValue = '0';
                  String cardAmount = '';
                  switch (card) {
                    case 'CALORIE_DEFICIT':
                      cardValue = provider.currentCalorieDeficit.toString();
                      cardAmount = 'cals/day';
                      break;
                    case 'WEIGHT_LOSS':
                      cardValue = provider.currentWeightLoss.toString();
                      cardAmount = 'kg/week';
                      break;
                    case 'BODY_FAT':
                      cardValue = provider.currentBodyFatGoal.toString();
                      cardAmount = '%';
                      break;
                    case 'WEIGHT_GOAL':
                      cardValue = provider.currentWeightGoal.toString();
                      cardAmount = 'kg';
                      break;
                    default:
                      cardValue = '0';
                      break;
                  }

                  return Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: cardValue,
                          style: TextStyle(
                            fontSize: 40,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        TextSpan(
                          text: cardAmount,
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
                  );
                },
              )
            ],
          ),
        ),
      ),
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
  Widget build(BuildContext context) {
    return Consumer<BiometricsDataController>(
      builder: (context, provider, child) {
        sliderValue =
            Provider.of<BiometricsDataController>(context, listen: false)
                .sliderValue
                .toInt();
        if (sliderValue <= 0) {
          sliderValue = 1;
        }
        List<Biometric> biometrics = provider.biometrics;
        List<Week> weeks = provider.weeks;
        Cycle cycle = provider.cycle;

        DateTime endDateTime = DateTime.parse(cycle.endDateTime);
        int remaining =
            (endDateTime.difference(currentDateTime).inDays / 7).ceil();
        int total = remaining - provider.sliderValue.toInt();

        double max = remaining.toDouble() - 1;
        int divisions = remaining - 2;

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
                      markerSettings: const MarkerSettings(isVisible: true)),
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
                // TODO: Sometimes causes error when new cut created and navigating to screen
                Slider(
                  value: sliderValue.toDouble(),
                  max: max <= 1 ? 2 : max,
                  min: 1,
                  divisions: divisions,
                  activeColor: Theme.of(context).colorScheme.onPrimary,
                  inactiveColor:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
                  thumbColor: Theme.of(context).colorScheme.onPrimary,
                  onChanged: (double value) {
                    provider.setSliderValue(value);
                  },
                ),
                Text(
                  '$total WEEKS REMAINING',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                )
              ],
            ),
          ],
        );
      },
    );
  }
}
