import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_cut/controller/cycle_configuration_controller.dart';
import 'package:project_cut/model/cycle.dart';
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
  int timeFrame = 0;
  List<String> sexes = ['MALE', 'FEMALE', 'OTHER'];

  // Text Field Titles
  static const String heightTitle = 'HEIGHT';
  static const String ageTitle = 'AGE';
  static const String startingWeightTitle = 'STARTING WEIGHT';
  static const String goalWeightTitle = 'GOAL WEIGHT';
  static const String startingBodyfatTitle = 'STARTING BODYFAT %';
  static const String goalBodyfatTitle = 'GOAL BODYFAT %';
  static const String timeFrameTitle = 'TIMEFRAME';

  String height = '';
  String age = '';
  String startingWeight = '';
  String goalWeight = '';
  String startingBodyfat = '';
  String goalBodyfat = '';

  SharedPreferences? sharedPreferences;

  @override
  void initState() {
    super.initState();
    _getSharedPreferences();
  }

  bool checkEnteredValues() {
    if (height == '' ||
        age == '' ||
        startingWeight == '' ||
        goalWeight == '' ||
        startingBodyfat == '' ||
        goalBodyfat == '' ||
        timeFrame == 0) {
      return false;
    }

    return true;
  }

  Future<void> _getSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<void> _updateSharedPreferences(String newValue, String field) async {
    switch (field) {
      case ageTitle:
        age = newValue;
        await sharedPreferences!.setInt('age', int.parse(newValue));
        break;
      case startingWeightTitle:
        startingWeight = newValue;
        await sharedPreferences!
            .setDouble('startingWeight', double.parse(newValue));
        break;
      case goalWeightTitle:
        goalWeight = newValue;
        await sharedPreferences!
            .setDouble('goalWeight', double.parse(newValue));
        break;
      case startingBodyfatTitle:
        startingBodyfat = newValue;
        await sharedPreferences!.setInt('startingBodyfat', int.parse(newValue));
        break;
      case goalBodyfatTitle:
        goalBodyfat = newValue;
        await sharedPreferences!.setInt('goalBodyFat', int.parse(newValue));
        break;
      default:
        height = newValue;
        await sharedPreferences!.setInt('height', int.parse(newValue));
    }
  }

  Widget textInputWidget(BuildContext context, String hint, String unit,
      CycleConfigurationController? config) {
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;
    String? value;
    bool canEdit = true;
    bool decimal = false;

    switch (hint) {
      case ageTitle:
        value = age;
        break;
      case startingWeightTitle:
        value = startingWeight;
        decimal = true;
        break;
      case goalWeightTitle:
        value = goalWeight;
        decimal = true;
        break;
      case startingBodyfatTitle:
        value = startingBodyfat;
        break;
      case goalBodyfatTitle:
        value = goalBodyfat;
        break;
      default:
        value = height;
    }

    if (hint == 'TIMEFRAME') {
      value = config!.getTimeFrame.toString();
      canEdit = false;
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width / 2 - 64,
      child: TextField(
        showCursor: true,
        maxLines: 1,
        textAlign: TextAlign.end,
        keyboardType: TextInputType.numberWithOptions(decimal: decimal),
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
          _updateSharedPreferences(value, hint);
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

  Widget gaugeWidget(CycleConfigurationController config) {
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
                value: config.getTimeFrame,
                onValueChanged: (double newValue) async {
                  config.setTimeFrame(newValue);
                  await sharedPreferences!
                      .setInt('timeFrame', newValue.roundToDouble().toInt());
                  timeFrame = newValue.toInt();
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
    return ChangeNotifierProvider(
      create: (context) => CycleConfigurationController(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
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
                        toggleButtonWidget(sexes[0]),
                        toggleButtonWidget(sexes[1]),
                        toggleButtonWidget(sexes[2]),
                      ],
                      onPressed: (int newIndex) async {
                        isSelected = [false, false];
                        isSelected.insert(newIndex, true);
                        config.setSex(sexes[newIndex]);
                        await sharedPreferences!
                            .setString('sex', sexes[newIndex]);
                      },
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        textInputWidget(context, heightTitle, 'cm', null),
                        const SizedBox(
                          width: 32,
                        ),
                        textInputWidget(context, ageTitle, 'yrs', null),
                      ],
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        textInputWidget(
                            context, startingWeightTitle, 'kg', null),
                        const Icon(
                          Icons.arrow_forward,
                          size: 32,
                        ),
                        textInputWidget(context, goalWeightTitle, 'kg', null),
                      ],
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        textInputWidget(
                            context, startingBodyfatTitle, '%', null),
                        const Icon(
                          Icons.arrow_forward,
                          size: 32,
                        ),
                        textInputWidget(context, goalBodyfatTitle, '%', null),
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
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                                fontSize: 16),
                          ),
                          onPressed: () => print('instructions'),
                        ),
                      ],
                    ),
                    Consumer<CycleConfigurationController>(
                        builder: (context, config, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          textInputWidget(
                              context, timeFrameTitle, 'weeks', config),
                          const SizedBox(
                            width: 32,
                          ),
                          gaugeWidget(config),
                        ],
                      );
                    }),
                    CupertinoButton(
                      color: Theme.of(context).colorScheme.secondary,
                      child: Text(
                        'Start Cut',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary,
                            fontSize: 16),
                      ),
                      onPressed: () {
                        int cycleDays = timeFrame * 7;
                        String endDateTime = DateTime.now()
                            .add(Duration(days: cycleDays))
                            .toLocal()
                            .toString();

                        Cycle cycle = Cycle(
                          startWeight: double.parse(startingWeight),
                          goalWeight: double.parse(goalWeight),
                          startBodyFat: int.parse(startingBodyfat),
                          goalBodyFat: int.parse(goalBodyfat),
                          startDateTime: DateTime.now().toLocal().toString(),
                          endDateTime: endDateTime,
                        );

                        // print(cycle);

                        checkEnteredValues()
                            ? config.startCut(cycle).then((value) =>
                                Navigator.pop(context, int.parse(age)))
                            : print('not all values filled out');
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
