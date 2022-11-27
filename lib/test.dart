import 'package:flutter/material.dart';
import 'package:project_cut/controller/cycle_configuration_controller.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class TesterWidget extends StatefulWidget {
  const TesterWidget({Key? key}) : super(key: key);

  @override
  State<TesterWidget> createState() => _TesterWidgetState();
}

class _TesterWidgetState extends State<TesterWidget> {
  PageController pageController = PageController(initialPage: 0);
  List<bool> isSelected = [true, false];
  List<String> sexes = ['MALE', 'FEMALE'];

  // Text Field Titles
  static const String heightTitle = 'HEIGHT';
  static const String ageTitle = 'AGE';
  static const String startingWeightTitle = 'STARTING WEIGHT';
  static const String goalWeightTitle = 'GOAL WEIGHT';
  static const String startingBodyfatTitle = 'BODYFAT %';
  static const String goalBodyfatTitle = 'GOAL BODYFAT %';
  static const String timeFrameTitle = 'TIMEFRAME';

  String height = '';
  String age = '';
  String startingWeight = '';
  String goalWeight = '';
  String startingBodyfat = '';
  String goalBodyfat = '';
  int timeFrame = 0;

  SharedPreferences? sharedPreferences;

  @override
  void initState() {
    super.initState();
    _getSharedPreferences();
  }

  Future<void> _getSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<void> _updateSharedPreferences(String newValue, String field,
      CycleConfigurationController config) async {
    switch (field) {
      case ageTitle:
        age = newValue;
        await sharedPreferences!.setInt('age', int.parse(newValue));
        break;
      case startingWeightTitle:
        startingWeight = newValue;
        await sharedPreferences!
            .setDouble('startingWeight', double.parse(newValue));
        await sharedPreferences!
            .setDouble('currentWeight', double.parse(newValue));
        config.startingWeight = double.parse(newValue);
        break;
      case goalWeightTitle:
        goalWeight = newValue;
        await sharedPreferences!
            .setDouble('goalWeight', double.parse(newValue));
        break;
      case startingBodyfatTitle:
        startingBodyfat = newValue;
        await sharedPreferences!
            .setDouble('startingBodyfat', double.parse(newValue));
        config.startingBodyFat = double.parse(newValue);
        break;
      case goalBodyfatTitle:
        goalBodyfat = newValue;
        await sharedPreferences!
            .setDouble('goalBodyFat', double.parse(newValue));
        config.goalBodyFat = double.parse(newValue);
        break;
      default:
        height = newValue;
        await sharedPreferences!.setInt('height', int.parse(newValue));
    }
  }

  Widget toggleButtonWidget(String title) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width / 2) - 64,
      child: Center(child: Text(title)),
    );
  }

  Widget textInputWidget(BuildContext context, String hint, String unit,
      [CycleConfigurationController? config]) {
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;
    String? value;
    bool canEdit = true;
    bool decimal = false;

    double width = MediaQuery.of(context).size.width - 128;

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
        width = MediaQuery.of(context).size.width / 2 - 64;
        break;
      case goalBodyfatTitle:
        value = goalBodyfat;
        width = MediaQuery.of(context).size.width / 2 - 64;
        break;
      default:
        value = height;
    }

    if (hint == 'TIMEFRAME') {
      value = config!.getTimeFrame.toString();
      canEdit = false;
    }

    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextField(
            showCursor: true,
            cursorColor: Colors.blue,
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
            ),
            onChanged: (value) {
              if (value == '') {
                value = '0';
              }
              _updateSharedPreferences(value, hint, config!);
            },
          ),
          const SizedBox(
            height: 8,
          ),
          Text(hint),
        ],
      ),
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
            maximum: 16,
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

  Widget scrollToNextPageButton(int pageNumber,
      [CycleConfigurationController? config]) {
    return MaterialButton(
        child: const Text('Next'),
        onPressed: () {
          pageNumber == 2 ? config!.newStartCut() : null;
          pageController.animateToPage(pageNumber,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic);
        });
  }

  Widget scrollToPreviousPageButton(int pageNumber) {
    return MaterialButton(
      child: const Text('Back'),
      onPressed: () => pageController.animateToPage(pageNumber,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic),
    );
  }

  Widget pageOne(CycleConfigurationController config) {
    return Container(
      padding: const EdgeInsets.all(32),
      color: Theme.of(context).colorScheme.primary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              Center(
                child: ToggleButtons(
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
                  ],
                  onPressed: (int newIndex) async {
                    isSelected = [false];
                    isSelected.insert(newIndex, true);
                    config.setSex(sexes[newIndex]);
                    await sharedPreferences!.setString('sex', sexes[newIndex]);
                  },
                ),
              ),
              const SizedBox(
                height: 64,
              ),
              textInputWidget(context, heightTitle, 'cm'),
              const SizedBox(
                height: 32,
              ),
              textInputWidget(context, ageTitle, 'yrs'),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              scrollToPreviousPageButton(0),
              scrollToNextPageButton(1),
            ],
          ),
        ],
      ),
    );
  }

  Widget pageTwo(CycleConfigurationController config) {
    return Container(
      padding: const EdgeInsets.all(32),
      color: Theme.of(context).colorScheme.primary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              textInputWidget(context, startingWeightTitle, 'kg', config),
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
              const SizedBox(
                height: 64,
              ),
              MaterialButton(
                  child: Text('Calculate BF%'),
                  onPressed: () => print('Calculate BF%'))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              scrollToPreviousPageButton(0),
              scrollToNextPageButton(2, config),
            ],
          ),
        ],
      ),
    );
  }

  Widget pageThree(CycleConfigurationController config) {
    return Container(
        padding: const EdgeInsets.all(32),
        color: Theme.of(context).colorScheme.primary,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  gaugeWidget(config),
                  const SizedBox(
                    width: 16,
                  ),
                  textInputWidget(context, timeFrameTitle, 'weeks', config),
                  MaterialButton(
                      child: Text('start cut'),
                      onPressed: () => config.newStartCut())
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  scrollToPreviousPageButton(1),
                  scrollToNextPageButton(2),
                ],
              )
            ]));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CycleConfigurationController>(
      builder: (context, config, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: PageView(
            controller: pageController,
            scrollDirection: Axis.vertical,
            children: [
              pageOne(config),
              pageTwo(config),
              pageThree(config),
            ],
          ),
        );
      },
    );
  }
}
