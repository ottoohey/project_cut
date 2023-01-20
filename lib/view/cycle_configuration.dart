import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_cut/controller/cycle_configuration_controller.dart';
import 'package:project_cut/model/cycle.dart';
import 'package:project_cut/widgets/custom_ios_segemented_control.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

enum Sex { male, female }

class CycleConfiguration extends StatefulWidget {
  const CycleConfiguration({Key? key}) : super(key: key);

  @override
  State<CycleConfiguration> createState() => _CycleConfigurationState();
}

class _CycleConfigurationState extends State<CycleConfiguration> {
  final PageController _pageController = PageController(initialPage: 0);
  // List<bool> _isSelected = [true, false];
  // final List<String> _sexes = ['MALE', 'FEMALE'];
  String height = '';
  String age = '';
  String startingWeight = '';
  String startingBodyfat = '';
  String goalBodyfat = '';

  static const String _heightTitle = 'HEIGHT';
  static const String _ageTitle = 'AGE';
  static const String _weightTitle = 'WEIGHT';
  static const String _startingBodyFatTitle = 'BODYFAT %';
  static const String _goalBodyFatTitle = 'GOAL BODYFAT %';
  static const String _neckTitle = 'NECK';
  static const String _waistTitle = 'WAIST';
  static const String _hipsTitle = 'HIPS';

  static const String _cmUnit = 'cm';
  static const String _kgUnit = 'kg';
  static const String _yearsUnit = 'yrs';
  static const String _percentageUnit = '%';

  Sex _selectedSegment = Sex.male;

  Widget _textInputWidget(BuildContext context, String hint, String unit,
      CycleConfigurationController cycleProvider) {
    String value = '';
    bool canEdit = true;
    bool decimal = true;

    switch (hint) {
      case _ageTitle:
        decimal = false;
        value = cycleProvider.age.toString();
        break;
      case _weightTitle:
        value = cycleProvider.startingWeight.toString();
        break;
      case _startingBodyFatTitle:
        value = cycleProvider.startingBodyFat.toString();
        break;
      case _goalBodyFatTitle:
        value = cycleProvider.goalBodyFat.toString();
        break;
      case _neckTitle:
        value = cycleProvider.neck.toString();
        break;
      case _waistTitle:
        value = cycleProvider.waist.toString();
        break;
      case _hipsTitle:
        value = cycleProvider.hips.toString();
        break;
      default:
        value = cycleProvider.height.toString();
    }

    if (value == '0' || value == '0.0') {
      value = '';
    }

    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(hint),
          const SizedBox(
            height: 8,
          ),
          Container(
            height: 52,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: TextField(
                showCursor: true,
                cursorColor: Theme.of(context).colorScheme.onPrimary,
                maxLines: 1,
                textAlign: TextAlign.end,
                keyboardType: TextInputType.numberWithOptions(decimal: decimal),
                controller: TextEditingController(text: value),
                enabled: canEdit,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            const BorderSide(color: Colors.transparent)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onPrimary)),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    suffix: Text(unit)),
                onChanged: (enteredValue) {
                  if (enteredValue == '') {
                    enteredValue = '0';
                  }

                  value = enteredValue;

                  switch (hint) {
                    case _ageTitle:
                      cycleProvider.setAge(enteredValue);
                      break;
                    case _weightTitle:
                      cycleProvider.setStartingWeight(enteredValue);
                      break;
                    case _startingBodyFatTitle:
                      cycleProvider.setStartingBodyFat(enteredValue);
                      break;
                    case _goalBodyFatTitle:
                      cycleProvider.setGoalBodyFat(enteredValue);
                      break;
                    case _neckTitle:
                      cycleProvider.setNeck(value);
                      break;
                    case _waistTitle:
                      cycleProvider.setWaist(value);
                      break;
                    case _hipsTitle:
                      cycleProvider.setHips(value);
                      break;
                    default:
                      cycleProvider.setHeight(enteredValue);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _gaugeWidget(CycleConfigurationController cycleProvider) {
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
                    color: Theme.of(context).colorScheme.errorContainer,
                  ),
                  GaugeRange(
                    startValue: 10,
                    endValue: 14,
                    color: Theme.of(context).indicatorColor,
                  ),
                  GaugeRange(
                    startValue: 14,
                    endValue: 18,
                    color: Theme.of(context).colorScheme.errorContainer,
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

  bool _checkFieldsCompleted(int timeFrame, double startWeight,
      double startBodyFat, double goalBodyFat, double height) {
    if (timeFrame == 0 ||
        startWeight == 0 ||
        startBodyFat == 0 ||
        goalBodyFat == 0 ||
        height == 0) {
      return false;
    }

    return true;
  }

  void _showAlertDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Fields Missing'),
        content: const Text('Please make sure you fill out all the fields!'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
            },
            isDefaultAction: true,
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _scrollToNextPageButton(int pageNumber) {
    int timeFrame =
        Provider.of<CycleConfigurationController>(context, listen: false)
            .timeFrame
            .toInt();
    double startWeight =
        Provider.of<CycleConfigurationController>(context, listen: false)
            .startingWeight;
    double startBodyFat =
        Provider.of<CycleConfigurationController>(context, listen: false)
            .startingBodyFat;
    double goalBodyFat =
        Provider.of<CycleConfigurationController>(context, listen: false)
            .goalBodyFat;
    double height =
        Provider.of<CycleConfigurationController>(context, listen: false)
            .height;

    switch (pageNumber) {
      case 3:
        return MaterialButton(
          minWidth: MediaQuery.of(context).size.width * 0.75 - 36,
          height: 52,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(15),
              bottomRight: Radius.circular(15),
              topLeft: Radius.circular(5),
              bottomLeft: Radius.circular(5),
            ),
          ),
          color: Theme.of(context).colorScheme.outline,
          child: const Text(
            'Start Cut',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            bool fieldsCompleted = _checkFieldsCompleted(
                timeFrame, startWeight, startBodyFat, goalBodyFat, height);

            if (fieldsCompleted) {
              Cycle cycle = Cycle(
                startWeight: startWeight,
                goalWeight: 0,
                startBodyFat: startBodyFat,
                goalBodyFat: goalBodyFat,
                startDateTime: DateTime.now().toLocal().toString(),
                endDateTime: DateTime.now()
                    .add(Duration(days: timeFrame * 7))
                    .toLocal()
                    .toString(),
              );
              Provider.of<CycleConfigurationController>(context, listen: false)
                  .startCut(cycle)
                  .whenComplete(() => Navigator.of(context).pop());
            } else {
              // Alert
              _showAlertDialog(context);
            }
          },
        );
      default:
        return MaterialButton(
          minWidth: MediaQuery.of(context).size.width * 0.75 - 36,
          height: 52,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(15),
              bottomRight: Radius.circular(15),
              topLeft: Radius.circular(5),
              bottomLeft: Radius.circular(5),
            ),
          ),
          color: Theme.of(context).colorScheme.outline,
          onPressed: () {
            _pageController.animateToPage(pageNumber,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic);
          },
          child: const Text(
            'Next',
            style: TextStyle(color: Colors.white),
          ),
        );
    }
  }

  Widget _scrollToPreviousPageButton(int pageNumber) {
    switch (pageNumber) {
      case 999:
        return MaterialButton(
          minWidth: MediaQuery.of(context).size.width * 0.25 - 32,
          height: 52,
          color: Theme.of(context).colorScheme.errorContainer,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              bottomLeft: Radius.circular(15),
              topRight: Radius.circular(5),
              bottomRight: Radius.circular(5),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        );
      default:
        return MaterialButton(
          minWidth: MediaQuery.of(context).size.width * 0.25 - 32,
          height: 52,
          color: Theme.of(context).colorScheme.errorContainer,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              bottomLeft: Radius.circular(15),
              topRight: Radius.circular(5),
              bottomRight: Radius.circular(5),
            ),
          ),
          onPressed: () => _pageController.animateToPage(pageNumber,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic),
          child: const Icon(
            Icons.arrow_upward_rounded,
            color: Colors.white,
          ),
        );
    }
  }

  Widget _pageOne() {
    return SingleChildScrollView(
      child: Consumer<CycleConfigurationController>(
        builder: (context, cycleProvider, child) {
          return Container(
            padding: const EdgeInsets.all(32),
            height: MediaQuery.of(context).size.height,
            color: Theme.of(context).colorScheme.primary,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 64,
                    ),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: CustomCupertinoSlidingSegmentedControl(
                          backgroundColor: CupertinoColors.systemGrey5,
                          thumbColor: Theme.of(context).colorScheme.primary,
                          groupValue: _selectedSegment,
                          onValueChanged: (Sex? value) {
                            if (value != null) {
                              _selectedSegment = value;
                              if (value == Sex.male) {
                                cycleProvider.setSex(value.name);
                              } else {
                                cycleProvider.setSex(value.name);
                              }
                            }
                          },
                          children: const <Sex, Widget>{
                            Sex.male: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 0),
                              child: Text(
                                'MALE',
                              ),
                            ),
                            Sex.female: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 0),
                              child: Text(
                                'FEMALE',
                              ),
                            ),
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    _textInputWidget(
                      context,
                      _heightTitle,
                      _cmUnit,
                      cycleProvider,
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    _textInputWidget(
                      context,
                      _weightTitle,
                      _kgUnit,
                      cycleProvider,
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    _textInputWidget(
                      context,
                      _ageTitle,
                      _yearsUnit,
                      cycleProvider,
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _scrollToPreviousPageButton(999),
                    const SizedBox(
                      width: 4,
                    ),
                    _scrollToNextPageButton(1),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _pageTwo() {
    return SingleChildScrollView(
      child: Consumer<CycleConfigurationController>(
        builder: (context, cycleProvider, child) {
          return Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                height: MediaQuery.of(context).size.height,
                color: Theme.of(context).colorScheme.primary,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(
                          height: 64,
                        ),
                        _textInputWidget(
                          context,
                          _startingBodyFatTitle,
                          _percentageUnit,
                          cycleProvider,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () => cycleProvider.setExpanded(),
                            child: Text(
                              'Don\'t know your bodyfat percentage?',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.outline),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        _textInputWidget(
                          context,
                          _goalBodyFatTitle,
                          _percentageUnit,
                          cycleProvider,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _scrollToPreviousPageButton(0),
                        const SizedBox(
                          width: 4,
                        ),
                        _scrollToNextPageButton(2),
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
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: cycleProvider.expanded
                      ? Card(
                          color: Theme.of(context).colorScheme.primary,
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    const SizedBox(
                                      height: 50,
                                    ),
                                    const Text(
                                      'US Navy Bodyfat % Calculator',
                                      style: TextStyle(
                                        fontSize: 36,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    const Text(
                                      'This bodyfat calculator uses the US Navy method, which is fairly accurate with little equipment',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Column(
                                      children: [
                                        _textInputWidget(
                                          context,
                                          _neckTitle,
                                          _cmUnit,
                                          cycleProvider,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'Measure circumference just underneath Adam\'s apple',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 32,
                                        ),
                                        _textInputWidget(
                                          context,
                                          _waistTitle,
                                          _cmUnit,
                                          cycleProvider,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            cycleProvider.sex == Sex.female.name
                                                ? 'Circumference of narrowest part of the abdomen'
                                                : 'Circumference at the level of the navel',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 32,
                                        ),
                                        cycleProvider.sex == Sex.female.name
                                            ? Column(
                                                children: [
                                                  _textInputWidget(
                                                    context,
                                                    _hipsTitle,
                                                    _cmUnit,
                                                    cycleProvider,
                                                  ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Text(
                                                      'Measured at the widest part of the buttocks or hips',
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                MaterialButton(
                                  minWidth: MediaQuery.of(context).size.width,
                                  height: 52,
                                  color: Theme.of(context).colorScheme.outline,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  onPressed: () {
                                    cycleProvider.calculateBodyFatPercentage();
                                    cycleProvider.setExpanded();
                                  },
                                  child: const Text(
                                    'Save',
                                    style: TextStyle(color: Colors.white),
                                  ),
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
      ),
    );
  }

  Widget _pageThree() {
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
                      _gaugeWidget(cycleProvider),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () =>
                                cycleProvider.removeWeekFromTimeFrame(),
                            child: Container(
                              height: 52,
                              width: 104,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(15)),
                              child: const Icon(
                                Icons.remove,
                                size: 40,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          GestureDetector(
                            onTap: () => cycleProvider.addWeekToTimeFrame(),
                            child: Container(
                              height: 52,
                              width: 104,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(15)),
                              child: const Icon(
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
                      _scrollToPreviousPageButton(1),
                      const SizedBox(
                        width: 4,
                      ),
                      _scrollToNextPageButton(3),
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
          resizeToAvoidBottomInset: true,
          body: PageView(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _pageOne(),
                _pageTwo(),
                _pageThree(),
              ],
              onPageChanged: (value) {
                value == 2 ? cycleProvider.estimateTimeFrame() : null;
              }),
        );
      },
    );
  }
}
