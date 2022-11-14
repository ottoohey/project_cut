import 'package:flutter/material.dart';
import 'package:project_cut/controller/biometrics_history_controller.dart';
import 'package:project_cut/database/db.dart';
import 'package:project_cut/model/biometric.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
                    padding: EdgeInsets.all(4),
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

class WeeksRemainingIndicator extends StatefulWidget {
  const WeeksRemainingIndicator({Key? key}) : super(key: key);

  @override
  State<WeeksRemainingIndicator> createState() =>
      _WeeksRemainingIndicatorState();
}

class _WeeksRemainingIndicatorState extends State<WeeksRemainingIndicator> {
  final DateTime currentDate = DateTime.now();
  final DateTime startDate = DateTime.utc(2022, 09, 01);
  final DateTime endDate = DateTime.utc(2022, 12, 25);

  late int progress = (currentDate.difference(startDate).inDays / 7).ceil();
  late int remaining = (endDate.difference(currentDate).inDays / 7).ceil();
  late int total = progress + remaining;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
          value: progress.toDouble(),
          max: total.toDouble(),
          divisions: total.toInt(),
          label: progress.round().toString(),
          activeColor: Theme.of(context).colorScheme.onPrimary,
          inactiveColor:
              Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
          thumbColor: Theme.of(context).colorScheme.onPrimary,
          onChanged: (double value) {
            setState(() {
              progress = value.toInt();
              remaining = total - progress;
            });
          },
        ),
        Text(
          '$remaining WEEKS REMAINING',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        )
      ],
    );
  }
}

class WeightLineGraph extends StatefulWidget {
  WeightLineGraph({Key? key}) : super(key: key);

  @override
  State<WeightLineGraph> createState() => WeightLineGraphState();
}

class WeightLineGraphState extends State<WeightLineGraph> {
  List<Biometric> biometrics = [];

  @override
  void initState() {
    super.initState();
    getBiometricsData();
  }

  Future<void> getBiometricsData() async {
    biometrics =
        await BiometricsDatabase.biometricsDatabase.getBiometricsForWeek(0);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BiometricsHistoryController>(
      builder: (context, controller, child) {
        return FutureBuilder(
          future: controller.getBiometrics,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return CircularProgressIndicator();
            } else {
              return Container(
                height: 200,
                child: SfCartesianChart(
                  primaryXAxis: NumericAxis(),
                  series: <ChartSeries>[
                    // Renders line chart
                    LineSeries<Biometric, int>(
                      dataSource: biometrics,
                      xValueMapper: (Biometric biometric, _) => biometric.day,
                      yValueMapper: (Biometric biometric, _) =>
                          biometric.currentWeight,
                    )
                  ],
                ),
              );
            }
          },
        );
      },
    );
  }
}
