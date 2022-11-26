import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:project_cut/controller/biometrics_history_controller.dart';
import 'package:project_cut/database/db.dart';
import 'package:project_cut/model/cycle.dart';
import 'package:project_cut/model/week.dart';
import 'package:project_cut/test.dart';
import 'package:project_cut/theme.dart';
import 'package:project_cut/view/biometrics_history.dart';
import 'package:project_cut/view/cycle_configuration.dart';
import 'package:project_cut/view/insert_weight.dart';
import 'package:project_cut/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: ChangeNotifierProvider<BiometricsHistoryController>(
            create: (context) => BiometricsHistoryController(),
            child: const MyHomePage(title: 'Flutter Demo Home Page')),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int? value;
  double currentWeight = 0;
  Week week = const Week(
      cycleId: 0,
      week: 0,
      calorieDeficit: 0,
      weightLoss: 0,
      weightGoal: 0,
      bodyFatGoal: 0);
  bool expanded = false;

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  //Loading counter value on start
  Future<void> _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    Cycle currentCycle = await AppDatabase.db.getCurrentCycle();
    DateTime currentDateTime = DateTime.now();
    Duration difference =
        currentDateTime.difference(DateTime.parse(currentCycle.startDateTime));
    int currentWeekId = (difference.inDays / 7).ceilToDouble().toInt();
    Week newWeek = await AppDatabase.db.getWeekById(currentWeekId);

    setState(() {
      value = (prefs.getInt('age'));
      currentWeight = prefs.getDouble('currentWeight')!;
      week = newWeek;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool needSetup = true;
    if (value != null) {
      needSetup = false;
    }

    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 75,
                    ),
                    NeumorphicCard(
                      title: 'CURRENT WEIGHT',
                      value: currentWeight.toString(),
                      amount: 'kg',
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    !needSetup
                        ? WeightLineGraph(initialWeek: week.id!)
                        : Container(),
                    const SizedBox(
                      height: 24,
                    ),
                    const Text('Weekly Goals'),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2 - 24,
                          height: 100,
                          child: NeumorphicCard(
                            title: 'CALORIE DEFICIT',
                            value: week.calorieDeficit.toString(),
                            amount: 'cals/day',
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2 - 24,
                          height: 100,
                          child: NeumorphicCard(
                            title: 'WEIGHT LOSS',
                            value: week.weightLoss.toString(),
                            amount: 'kg/week',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2 - 24,
                              height: 100,
                              child: NeumorphicCard(
                                title: 'BODY FAT % GOAL',
                                value: week.bodyFatGoal.toString(),
                                amount: '%',
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2 - 24,
                              height: 100,
                              child: NeumorphicCard(
                                title: 'WEIGHT GOAL',
                                value: week.weightGoal.toString(),
                                amount: 'kg',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2 - 24,
                              height: 100,
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const TesterWidget(),
                                  ),
                                ),
                                child: const NeumorphicCard(
                                  title: 'SETTINGS',
                                  value: 'settings_icon',
                                  amount: '',
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2 - 24,
                              height: 100,
                              child: const NeumorphicCard(
                                title: 'PROGRESS PIC',
                                value: 'progress_pic_icon',
                                amount: '',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            MaterialButton(
                              child: const Text('add'),
                              onPressed: () async {
                                // AppDatabase.db.addWeight(86.5);
                                //   SharedPreferences sharedPreferences =
                                //       await SharedPreferences.getInstance();
                                //   sharedPreferences.setDouble(
                                //       'currentWeight', 86.7);
                                Cycle cycle = const Cycle(
                                    id: 1,
                                    startWeight: 87,
                                    goalWeight: 76,
                                    startBodyFat: 20,
                                    goalBodyFat: 8,
                                    startDateTime: '2022-11-17 00:00:00.000000',
                                    endDateTime: '2023-03-05 00:00:00.000000');
                                AppDatabase.db.updateCycle(cycle);
                              },
                            ),
                            MaterialButton(
                              child: const Text('data'),
                              onPressed: () async {
                                var bio = await AppDatabase.db
                                    .getBiometricsForWeek(1);
                                // var bio = await AppDatabase.db.getWeekById(2);
                                // var bio =
                                //     await AppDatabase.db.getCurrentCycle();
                                // var bio = await AppDatabase.db.getWeeks();
                                // SharedPreferences sharedPreferences =
                                //     await SharedPreferences.getInstance();

                                print(bio);
                              },
                            ),
                            MaterialButton(
                              child: const Text('delete'),
                              onPressed: () =>
                                  AppDatabase.db.deleteBiometrics(11),
                              // onPressed: () async {
                              //   final prefs =
                              //       await SharedPreferences.getInstance();
                              //   prefs.clear();
                              //   AppDatabase.db.deleteAll();
                              // },
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            // onPressed: () => Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const InsertWeightScreen(),
            //   ),
            // ),
            onPressed: () {
              if (expanded) {
                expanded = false;
              } else {
                expanded = true;
              }

              setState(() {});
            },
            child: const Icon(Icons.add),
          ),
        ),
        needSetup
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.white54,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Center(
                    child: Container(
                      height: 300,
                      width: MediaQuery.of(context).size.width - 32,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Theme.of(context).colorScheme.onPrimary),
                      child: Column(
                        children: [
                          Text(
                            'Welcome to Project Cut :)',
                            style: Theme.of(context).textTheme.headline4,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'We just need to get a few bits of information to set everything up. All data is stored on your phone, so only you have access to it!',
                            style: Theme.of(context).textTheme.subtitle1,
                            textAlign: TextAlign.center,
                          ),
                          MaterialButton(
                            child: const Text('Get Started'),
                            onPressed: () async {
                              value = await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CycleConfiguration(),
                                ),
                              );
                              setState(() {});
                            },
                          ),
                          MaterialButton(
                            child: const Text('tester button'),
                            onPressed: () async {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              prefs.clear();
                              AppDatabase.db.deleteAll();
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
        GestureDetector(
          onTap: () {
            expanded = false;
            print('touched');
            setState(() {});
          },
          child: Align(
            alignment: Alignment.topCenter,
            child: AnimatedContainer(
              curve: Curves.easeOutCirc,
              duration: const Duration(milliseconds: 300),
              height:
                  expanded ? MediaQuery.of(context).size.height - 340 - 32 : 0,
              width: MediaQuery.of(context).size.width - 32,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSecondary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: expanded
                  ? Card(
                      color: Colors.transparent,
                      shadowColor: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Todays Weight :)',
                              style: TextStyle(
                                  fontSize: 42,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            const TextField(
                              autofocus: true,
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              style: TextStyle(fontSize: 36),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Consumer<BiometricsHistoryController>(
                              builder: (context, controller, child) {
                                return MaterialButton(
                                  child: Text(
                                    'Save',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                  ),
                                  onPressed: () async {
                                    expanded = false;
                                    await controller.addWeight(86);
                                    setState(() {});
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ),
          ),
        ),
      ],
    );
  }
}
