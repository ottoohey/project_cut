import 'package:flutter/material.dart';
import 'package:project_cut/controller/cycle_configuration_controller.dart';
import 'package:project_cut/model/cycle.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class CycleConfiguration extends StatefulWidget {
  const CycleConfiguration({Key? key}) : super(key: key);

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

  static const String heightTitle = 'HEIGHT';
  static const String ageTitle = 'AGE';
  static const String startingWeightTitle = 'STARTING WEIGHT';
  static const String startingBodyfatTitle = 'BODYFAT %';
  static const String goalBodyfatTitle = 'GOAL BODYFAT %';

  Widget toggleButtonWidget(String title) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width / 2) - 64,
      child: Center(child: Text(title)),
    );
  }

  Widget textInputWidget(BuildContext context, String hint, String unit,
      CycleConfigurationController cycleProvider) {
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;
    String value = '';
    bool canEdit = true;
    bool decimal = false;

    double width = MediaQuery.of(context).size.width - 128;

    switch (hint) {
      case ageTitle:
        value = cycleProvider.age.toString();
        break;
      case startingWeightTitle:
        decimal = true;
        value = cycleProvider.startingWeight.toString();
        break;
      case startingBodyfatTitle:
        width = MediaQuery.of(context).size.width / 2 - 64;
        value = cycleProvider.startingBodyFat.toString();
        break;
      case goalBodyfatTitle:
        width = MediaQuery.of(context).size.width / 2 - 64;
        value = cycleProvider.goalBodyFat.toString();
        break;
      default:
        value = cycleProvider.height.toString();
    }

    if (value == '0' || value == '0.0') {
      value = '';
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
            onChanged: (enteredValue) {
              if (enteredValue == '') {
                enteredValue = '0';
              }

              value = enteredValue;

              switch (hint) {
                case ageTitle:
                  cycleProvider.setAge(enteredValue);
                  break;
                case startingWeightTitle:
                  cycleProvider.setStartingWeight(enteredValue);
                  break;
                case startingBodyfatTitle:
                  cycleProvider.setStartingBodyFat(enteredValue);
                  break;
                case goalBodyfatTitle:
                  cycleProvider.setGoalBodyFat(enteredValue);
                  break;
                default:
                  cycleProvider.setHeight(enteredValue);
              }
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
        SizedBox(
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
        SizedBox(
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
                    value: cycleProvider.timeFrame,
                    onValueChanged: (double newValue) async {
                      cycleProvider.setTimeFrame(newValue);
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
                .timeFrame
                .toInt();
            Cycle cycle = Cycle(
              startWeight: Provider.of<CycleConfigurationController>(context,
                      listen: false)
                  .startingWeight,
              goalWeight: 0,
              startBodyFat: Provider.of<CycleConfigurationController>(context,
                      listen: false)
                  .startingBodyFat,
              goalBodyFat: Provider.of<CycleConfigurationController>(context,
                      listen: false)
                  .goalBodyFat,
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

  Widget bodyFatCalculationTextEntry(
      String hint, CycleConfigurationController cycleProvider) {
    String value = '';
    switch (hint) {
      case 'NECK':
        value = cycleProvider.neck.toString();
        break;
      case 'WAIST':
        value = cycleProvider.waist.toString();
        break;
      default:
        value = cycleProvider.hips.toString();
    }

    if (value == '0' || value == '0.0') {
      value = '';
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width / 2 - 32,
      // height: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Consumer<CycleConfigurationController>(
            builder: (context, cycleProvider, child) {
              return TextField(
                showCursor: true,
                cursorColor: Colors.white,
                maxLines: 1,
                textAlign: TextAlign.end,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                controller: TextEditingController(text: value),
                enabled: true,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                ),
                decoration: const InputDecoration(
                  suffix: Text(
                    'cm',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                onChanged: (enteredValue) {
                  if (enteredValue == '') {
                    enteredValue = '0';
                  }
                  value = enteredValue;

                  switch (hint) {
                    case 'NECK':
                      cycleProvider.setNeck(value);
                      break;
                    case 'WAIST':
                      cycleProvider.setWaist(value);
                      break;
                    default:
                      cycleProvider.setHips(value);
                      break;
                  }
                },
              );
            },
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            hint,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget pageOne() {
    return Consumer<CycleConfigurationController>(
      builder: (context, cycleProvider, child) {
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
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 64,
                  ),
                  textInputWidget(context, heightTitle, 'cm', cycleProvider),
                  const SizedBox(
                    height: 32,
                  ),
                  textInputWidget(context, ageTitle, 'yrs', cycleProvider),
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
      },
    );
  }

  Widget pageTwo() {
    return Consumer<CycleConfigurationController>(
      builder: (context, cycleProvider, child) {
        return Stack(
          children: [
            Container(
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
                      textInputWidget(
                          context, startingWeightTitle, 'kg', cycleProvider),
                      const SizedBox(
                        height: 32,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          textInputWidget(context, startingBodyfatTitle, '%',
                              cycleProvider),
                          const Icon(
                            Icons.arrow_forward,
                            size: 32,
                          ),
                          textInputWidget(
                              context, goalBodyfatTitle, '%', cycleProvider),
                        ],
                      ),
                      const SizedBox(
                        height: 64,
                      ),
                      MaterialButton(
                          child: const Text('Calculate BF%'),
                          onPressed: () => cycleProvider.setExpanded())
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
            ),
            Align(
              alignment: Alignment.topCenter,
              child: AnimatedContainer(
                curve: Curves.easeOutCirc,
                // TODO: Text in dropdown container overflowing whilst container expanding
                duration: const Duration(milliseconds: 400),
                height: cycleProvider.expanded
                    ? MediaQuery.of(context).size.height
                    : 0,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: cycleProvider.expanded
                    ? Card(
                        color: Colors.transparent,
                        shadowColor: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 50,
                              ),
                              Text(
                                'US Navy Bodyfat % Calculator',
                                style: TextStyle(
                                    fontSize: 36,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Text(
                                'This bodyfat calculator uses the US Navy method, which is fairly accurate with little equipment',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Column(
                                children: [
                                  bodyFatCalculationTextEntry(
                                      'NECK', cycleProvider),
                                  bodyFatCalculationTextEntry(
                                      'WAIST', cycleProvider),
                                  cycleProvider.sex == 'FEMALE'
                                      ? bodyFatCalculationTextEntry(
                                          'HIPS', cycleProvider)
                                      : const SizedBox(),
                                ],
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              MaterialButton(
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                ),
                                onPressed: () {
                                  cycleProvider.calculateBodyFatPercentage();
                                  cycleProvider.setExpanded();
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget pageThree() {
    return Consumer<CycleConfigurationController>(
      builder: (context, cycleProvider, child) {
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
                            onTap: () =>
                                cycleProvider.removeWeekFromTimeFrame(),
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CycleConfigurationController>(
      builder: (context, cycleProvider, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: PageView(
              controller: pageController,
              scrollDirection: Axis.vertical,
              children: [
                // Container(
                //   color: Colors.amber,
                //   child: Center(
                //     child: MaterialButton(
                //       child: Text('test'),
                //       onPressed: () => biometricsProvider
                //           .testChangeWeight()
                //           .then((value) => Navigator.pop(context)),
                //     ),
                //   ),
                // ),
                pageOne(),
                pageTwo(),
                pageThree(),
              ],
              onPageChanged: (value) {
                value == 2 ? cycleProvider.estimateTimeFrame() : null;
              }),
        );
      },
    );
  }
}
