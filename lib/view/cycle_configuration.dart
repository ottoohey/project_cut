import 'package:flutter/material.dart';
import 'package:project_cut/controller/biometrics_data_controller.dart';
import 'package:project_cut/controller/cycle_configuration_controller.dart';
import 'package:project_cut/model/cycle.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class CycleConfiguration extends StatefulWidget {
  const CycleConfiguration({Key? key}) : super(key: key);

  static const String heightTitle = 'HEIGHT';
  static const String ageTitle = 'AGE';
  static const String startingWeightTitle = 'STARTING WEIGHT';
  static const String startingBodyfatTitle = 'BODYFAT %';
  static const String goalBodyfatTitle = 'GOAL BODYFAT %';

  @override
  State<CycleConfiguration> createState() => _CycleConfigurationState();
}

class _CycleConfigurationState extends State<CycleConfiguration> {
  PageController pageController = PageController(initialPage: 0);

  List<bool> isSelected = [true, false];

  List<String> sexes = ['MALE', 'FEMALE'];

  String height = '';

  String age = '';

  String startingWeight = '';

  String startingBodyfat = '';

  String goalBodyfat = '';

  Widget toggleButtonWidget(String title) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width / 2) - 64,
      child: Center(child: Text(title)),
    );
  }

  Widget textInputWidget(BuildContext context, String hint, String unit,
      [CycleConfigurationController? cycleProvider]) {
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;
    String? value;
    bool canEdit = true;
    bool decimal = false;

    double width = MediaQuery.of(context).size.width - 128;

    switch (hint) {
      case CycleConfiguration.ageTitle:
        value = age;
        break;
      case CycleConfiguration.startingWeightTitle:
        value = startingWeight;
        decimal = true;
        break;
      case CycleConfiguration.startingBodyfatTitle:
        value = startingBodyfat;
        width = MediaQuery.of(context).size.width / 2 - 64;
        break;
      case CycleConfiguration.goalBodyfatTitle:
        value = goalBodyfat;
        width = MediaQuery.of(context).size.width / 2 - 64;
        break;
      default:
        value = height;
    }

    if (hint == 'TIMEFRAME') {
      value = cycleProvider!.getTimeFrame.toString();
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
              print('update');
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

  Widget gaugeWidget(CycleConfigurationController cycleProvider) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 260,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text('Recommended Cut Time'),
              Text(
                '${cycleProvider.timeFrame} Weeks',
                style: const TextStyle(fontSize: 32),
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 300,
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
                    color:
                        Theme.of(context).colorScheme.onPrimary.withBlue(125),
                  ),
                  GaugeRange(
                    startValue: 10,
                    endValue: 14,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  GaugeRange(
                    startValue: 14,
                    endValue: 18,
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withOpacity(0.5),
                  ),
                ],
                pointers: <GaugePointer>[
                  NeedlePointer(
                    enableDragging: true,
                    value: cycleProvider.getTimeFrame,
                    onValueChanged: (double newValue) async {
                      cycleProvider.setTimeFrame(newValue);
                      print('update timeframe');
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
        ),
      ],
    );
  }

  Widget scrollToNextPageButton(int pageNumber) {
    switch (pageNumber) {
      case 3:
        return MaterialButton(
          child: const Text('Start Cut'),
          onPressed: () {
            int timeFrame = Provider.of<CycleConfigurationController>(context,
                    listen: false)
                .getTimeFrame
                .toInt();
            Cycle cycle = Cycle(
              startWeight: double.parse(startingWeight),
              goalWeight: 0,
              startBodyFat: double.parse(startingBodyfat),
              goalBodyFat: double.parse(goalBodyfat),
              startDateTime: DateTime.now().toLocal().toString(),
              endDateTime: DateTime.now()
                  .add(Duration(days: timeFrame * 7))
                  .toLocal()
                  .toString(),
            );
            Provider.of<CycleConfigurationController>(context, listen: false)
                .startCut(cycle)
                .whenComplete(() => Navigator.of(context).pop());
          },
        );
      default:
        return MaterialButton(
          child: const Text('Next'),
          onPressed: () {
            pageController.animateToPage(pageNumber,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic);
          },
        );
    }
  }

  Widget scrollToPreviousPageButton(int pageNumber) {
    switch (pageNumber) {
      case 999:
        return MaterialButton(
          child: const Text('Back'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        );
      default:
        return MaterialButton(
          child: const Text('Back'),
          onPressed: () => pageController.animateToPage(pageNumber,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic),
        );
    }
  }

  Widget pageOne(CycleConfigurationController cycleProvider) {
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
                    cycleProvider.setSex(sexes[newIndex]);
                    print('update sex');
                  },
                ),
              ),
              const SizedBox(
                height: 64,
              ),
              textInputWidget(context, CycleConfiguration.heightTitle, 'cm'),
              const SizedBox(
                height: 32,
              ),
              textInputWidget(context, CycleConfiguration.ageTitle, 'yrs'),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              scrollToPreviousPageButton(999),
              scrollToNextPageButton(1),
            ],
          ),
        ],
      ),
    );
  }

  Widget pageTwo(CycleConfigurationController cycleProvider) {
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
              textInputWidget(context, CycleConfiguration.startingWeightTitle,
                  'kg', cycleProvider),
              const SizedBox(
                height: 32,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  textInputWidget(
                      context,
                      CycleConfiguration.startingBodyfatTitle,
                      '%',
                      cycleProvider),
                  const Icon(
                    Icons.arrow_forward,
                    size: 32,
                  ),
                  textInputWidget(context, CycleConfiguration.goalBodyfatTitle,
                      '%', cycleProvider),
                ],
              ),
              const SizedBox(
                height: 64,
              ),
              MaterialButton(
                  child: const Text('Calculate BF%'),
                  onPressed: () => print('Calculate BF%'))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              scrollToPreviousPageButton(0),
              scrollToNextPageButton(2),
            ],
          ),
        ],
      ),
    );
  }

  Widget pageThree(CycleConfigurationController cycleProvider) {
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
                  gaugeWidget(cycleProvider),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => cycleProvider.removeWeekFromTimeFrame(),
                        child: const Card(
                          child: Icon(
                            Icons.remove,
                            size: 40,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => cycleProvider.addWeekToTimeFrame(),
                        child: const Card(
                          child: Icon(
                            Icons.add,
                            size: 40,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  scrollToPreviousPageButton(1),
                  scrollToNextPageButton(3),
                ],
              )
            ]));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CycleConfigurationController, BiometricsDataController>(
      builder: (context, cycleProvider, biometricsProvider, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: PageView(
              controller: pageController,
              scrollDirection: Axis.vertical,
              children: [
                Container(
                  color: Colors.amber,
                  child: Center(
                    child: MaterialButton(
                      child: Text('test'),
                      onPressed: () => biometricsProvider
                          .testChangeWeight()
                          .then((value) => Navigator.pop(context)),
                    ),
                  ),
                ),
                pageOne(cycleProvider),
                pageTwo(cycleProvider),
                pageThree(cycleProvider),
              ],
              onPageChanged: (value) {
                value == 2 ? cycleProvider.estimateTimeFrame() : null;
                if (value == 2) {
                  cycleProvider.estimateTimeFrame();
                }
              }),
        );
      },
    );
  }
}
