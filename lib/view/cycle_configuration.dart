import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_cut/controller/cycle_configuration_controller.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class CycleConfiguration extends StatefulWidget {
  const CycleConfiguration({Key? key}) : super(key: key);

  @override
  State<CycleConfiguration> createState() => _CycleConfigurationState();
}

class _CycleConfigurationState extends State<CycleConfiguration> {
  List<bool> isSelected = [true, false, false];
  double earliestTime = 8;
  double latestTime = 18;
  double timeFrame = 0;

  // Text Field Titles
  static const String heightTitle = 'HEIGHT';
  static const String ageTitle = 'AGE';
  static const String startingWeightTitle = 'STARTING WEIGHT';
  static const String goalWeightTitle = 'GOAL WEIGHT';
  static const String startingBodyfatTitle = 'STARTING BODYFAT %';
  static const String goalBodyfatTitle = 'GOAL BODYFAT %';

  SharedPreferences? sharedPreferences;

  @override
  void initState() {
    super.initState();
    getSharedPreferences();
  }

  Future<void> getSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<void> updateSharedPreferences(String newValue, String field) async {
    String preference;
    switch (field) {
      case ageTitle:
        preference = 'age';
        break;
      case startingWeightTitle:
        preference = 'startingWeight';
        break;
      case goalWeightTitle:
        preference = 'goalWeight';
        break;
      case startingBodyfatTitle:
        preference = 'startingBodyfat';
        break;
      case goalBodyfatTitle:
        preference = 'goalBodyfat';
        break;
      default:
        preference = 'height';
    }

    await sharedPreferences!.setDouble(preference, double.parse(newValue));
  }

  Future<void> updateGauge(String value) async {
    setState(() {
      timeFrame = double.parse(value);
    });
  }

  Widget textInputWidget(BuildContext context, String hint, String unit,
      CycleConfigurationController config) {
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;
    String? value;
    bool canEdit = true;

    if (hint == 'TIMEFRAME') {
      value = timeFrame.toInt().toString();
      canEdit = false;
    }

    switch (hint) {
      case ageTitle:
        value = config.getAge;
        break;
      case startingWeightTitle:
        value = config.startingWeight;
        break;
      case goalWeightTitle:
        value = config.goalWeight;
        break;
      case startingBodyfatTitle:
        value = config.startingBodyfat;
        break;
      case goalBodyfatTitle:
        value = config.getGoalBodyfat;
        break;
      default:
        value = config.getHeight;
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width / 2 - 64,
      child: TextField(
        showCursor: true,
        maxLines: 1,
        textAlign: TextAlign.end,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        controller: TextEditingController(text: value),
        enabled: canEdit,
        style: TextStyle(
          color: onPrimary,
          fontSize: 32,
        ),
        decoration: InputDecoration(
          suffix: Text(
            unit,
            style: TextStyle(color: onPrimary),
          ),
          helperText: hint,
        ),
        onChanged: (value) {
          updateSharedPreferences(value, hint);
        },
      ),
    );
  }

  Widget toggleButtonWidget(String title) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width / 3) - 24,
      child: Center(child: Text(title)),
    );
  }

  Widget gaugeWidget() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2 - 32,
      height: 200,
      child: SfRadialGauge(
        axes: [
          RadialAxis(
            minimum: 8,
            maximum: 18,
            startAngle: 180,
            endAngle: 360,
            showLastLabel: true,
            axisLabelStyle: GaugeTextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            majorTickStyle: MajorTickStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            minorTickStyle: MinorTickStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            ranges: <GaugeRange>[
              GaugeRange(
                startValue: 8,
                endValue: 10,
                color: Theme.of(context).colorScheme.onPrimary.withBlue(125),
              ),
              GaugeRange(
                startValue: 10,
                endValue: 14,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              GaugeRange(
                startValue: 14,
                endValue: 18,
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
              ),
            ],
            pointers: <GaugePointer>[
              NeedlePointer(
                enableDragging: true,
                value: timeFrame,
                onValueChanged: (double newValue) {
                  setState(() {
                    timeFrame = newValue.roundToDouble();
                  });
                },
                needleLength: 0.5,
                needleColor: Theme.of(context).colorScheme.onPrimary,
                knobStyle: KnobStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<CycleConfigurationController>(
            builder: (context, config, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 100,
              ),
              ToggleButtons(
                isSelected: isSelected,
                selectedColor: Theme.of(context).colorScheme.primary,
                color: Theme.of(context).colorScheme.onPrimary,
                fillColor: Theme.of(context).colorScheme.onPrimary,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
                renderBorder: true,
                borderColor: Theme.of(context).colorScheme.onPrimary,
                borderWidth: 0.5,
                borderRadius: BorderRadius.circular(10),
                children: [
                  toggleButtonWidget('MALE'),
                  toggleButtonWidget('FEMALE'),
                  toggleButtonWidget('OTHER'),
                ],
                onPressed: (int newIndex) {
                  isSelected = [false, false];
                  isSelected.insert(newIndex, true);
                  setState(
                    () {
                      isSelected;
                    },
                  );
                },
              ),
              const SizedBox(
                height: 32,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  textInputWidget(context, heightTitle, 'cm', config),
                  const SizedBox(
                    width: 32,
                  ),
                  textInputWidget(context, ageTitle, 'yrs', config),
                ],
              ),
              const SizedBox(
                height: 32,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  textInputWidget(context, startingWeightTitle, 'kg', config),
                  const Icon(
                    Icons.arrow_forward,
                    size: 32,
                  ),
                  textInputWidget(context, goalWeightTitle, 'kg', config),
                ],
              ),
              const SizedBox(
                height: 32,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  textInputWidget(context, startingBodyfatTitle, '%', config),
                  const Icon(
                    Icons.arrow_forward,
                    size: 32,
                  ),
                  textInputWidget(context, goalBodyfatTitle, '%', config),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  CupertinoButton(
                    child: Text(
                      'How to calculate Body Fat %',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontSize: 16),
                    ),
                    onPressed: () => print('instructions'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textInputWidget(context, 'TIMEFRAME', 'weeks', config),
                  const SizedBox(
                    width: 32,
                  ),
                  gaugeWidget(),
                ],
              ),
              CupertinoButton(
                child: Text(
                  'Shared Preferences',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 16),
                ),
                onPressed: () =>
                    print(sharedPreferences!.getDouble('age') ?? 0),
              ),
            ],
          );
        }),
      ),
    );
  }
}
