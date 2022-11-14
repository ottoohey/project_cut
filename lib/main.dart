import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_cut/controller/biometrics_history_controller.dart';
import 'package:project_cut/database/db.dart';
import 'package:project_cut/theme.dart';
import 'package:project_cut/view/biometrics_history.dart';
import 'package:project_cut/view/cycle_configuration.dart';
import 'package:project_cut/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/biometric.dart';

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
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  double? value;

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  //Loading counter value on start
  Future<void> _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      value = (prefs.getDouble('age'));
    });
  }

  @override
  Widget build(BuildContext context) {
    bool needSetup = false;
    if (value == null) {
      needSetup = true;
    }

    return Stack(
      children: [
        Scaffold(
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
                    const NeumorphicCard(
                      title: 'CURRENT WEIGHT',
                      value: '79.4',
                      amount: 'kg',
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ChangeNotifierProvider(
                      create: (context) => BiometricsHistoryController(),
                      child: WeightLineGraph(),
                    ),
                    const WeeksRemainingIndicator(),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2 - 24,
                          height: 100,
                          child: const NeumorphicCard(
                            title: 'CALORIE DEFICIT',
                            value: '300',
                            amount: 'cals/day',
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2 - 24,
                          height: 100,
                          child: const NeumorphicCard(
                            title: 'WEIGHT LOSS',
                            value: '0.3',
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
                              child: const NeumorphicCard(
                                title: 'BODY FAT % GOAL',
                                value: '9',
                                amount: '%',
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2 - 24,
                              height: 100,
                              child: const NeumorphicCard(
                                title: 'WEIGHT GOAL',
                                value: '76',
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
                                        builder: (context) =>
                                            ChangeNotifierProvider(
                                              create: (context) =>
                                                  BiometricsHistoryController(),
                                              child: const BiometricsHistory(),
                                            ))),
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
                              onPressed: () => BiometricsDatabase
                                  .biometricsDatabase
                                  .insertBiometric(
                                const Biometric(
                                    id: 6,
                                    currentWeight: 74.5,
                                    bodyFat: 9,
                                    dateTime: '2022-12-11 00:00:00',
                                    day: 6,
                                    weekId: 0),
                              ),
                            ),
                            MaterialButton(
                              child: const Text('delete'),
                              // onPressed: () => BiometricsDatabase
                              //     .biometricsDatabase
                              //     .deleteAllBiometrics(),
                              onPressed: () async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                prefs.clear();
                              },
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
            onPressed: () async {
              // print(
              //   await BiometricsDatabase.biometricsDatabase
              //       .getBiometricsForWeek(0),
              // );
              print(((int.parse(DateFormat('D').format(DateTime.now())) -
                          DateTime.now().weekday +
                          10) /
                      7)
                  .floor());
            },
            tooltip: 'Increment',
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
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
