import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:project_cut/controller/biometrics_data_controller.dart';
import 'package:project_cut/controller/cycle_configuration_controller.dart';
import 'package:project_cut/database/db.dart';
import 'package:project_cut/model/biometric.dart';
import 'package:project_cut/theme.dart';
import 'package:project_cut/view/cycle_configuration.dart';
import 'package:project_cut/widgets.dart';
import 'package:provider/provider.dart';

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
        home: ChangeNotifierProvider<BiometricsDataController>(
            create: (context) => BiometricsDataController(),
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
  final enterWeightText = TextEditingController();
  Future? _cycleConfigurationRequiredFuture;
  bool expanded = false;

  @override
  void initState() {
    _cycleConfigurationRequiredFuture = _cycleConfigurationRequired();
    super.initState();
  }

  Future _cycleConfigurationRequired() async {
    await Provider.of<BiometricsDataController>(context, listen: false)
        .setHomePageData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _cycleConfigurationRequiredFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          double currentWeight =
              Provider.of<BiometricsDataController>(context).currentWeight;
          if (currentWeight == 0) {
            return Container(
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
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MultiProvider(
                                  providers: [
                                    ChangeNotifierProvider(
                                        create: (context) =>
                                            CycleConfigurationController()),
                                    ChangeNotifierProvider(
                                        create: (context) =>
                                            BiometricsDataController()),
                                  ],
                                  child: const CycleConfiguration(),
                                ),
                              ),
                            );
                            await _cycleConfigurationRequired();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
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
                            const CurrentWeightNeumorphicCard(),
                            const SizedBox(
                              height: 16,
                            ),
                            const WeightLineGraph(),
                            const SizedBox(
                              height: 24,
                            ),
                            const WeeklyDataGrid(),
                            Column(
                              children: [
                                const SizedBox(
                                  height: 16,
                                ),
                                Column(
                                  children: [
                                    MaterialButton(
                                      child: const Text('add'),
                                      onPressed: () async {
                                        // AppDatabase.db.addWeight(86.5);
                                        //   SharedPreferences sharedPreferences =
                                        //       await SharedPreferences.getInstance();
                                        //   sharedPreferences.setDouble(
                                        //       'currentWeight', 86.7);
                                        Biometric bio = const Biometric(
                                            id: 3,
                                            weekId: 1,
                                            cycleId: 1,
                                            currentWeight: 0,
                                            bodyFat: 20,
                                            dateTime:
                                                '2022-11-30 00:00:00.000000',
                                            day: 3,
                                            estimated: 0);
                                        await AppDatabase.db
                                            .updateBiometric(bio);
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
                                        // var bio =
                                        //     await AppDatabase.db.getWeeks();
                                        // SharedPreferences sharedPreferences =
                                        //     await SharedPreferences.getInstance();

                                        print(bio);
                                      },
                                    ),
                                    MaterialButton(
                                        child: const Text('delete'),
                                        onPressed: () {
                                          AppDatabase.db.deleteBiometrics(7);
                                          AppDatabase.db.deleteBiometrics(8);
                                        }
                                        // onPressed: () async {
                                        //   final prefs = await SharedPreferences
                                        //       .getInstance();
                                        //   prefs.clear();
                                        //   AppDatabase.db.deleteAll();
                                        // },
                                        ),
                                    MaterialButton(
                                      child: const Text('Cycle Config'),
                                      onPressed: () =>
                                          Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => MultiProvider(
                                            providers: [
                                              ChangeNotifierProvider(
                                                  create: (context) =>
                                                      CycleConfigurationController()),
                                              ChangeNotifierProvider(
                                                  create: (context) =>
                                                      BiometricsDataController()),
                                            ],
                                            child: const CycleConfiguration(),
                                          ),
                                        ),
                                      ),
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
                GestureDetector(
                  onTap: () {
                    expanded = false;
                    setState(() {});
                  },
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: AnimatedContainer(
                      curve: Curves.easeOutCirc,
                      duration: const Duration(milliseconds: 300),
                      height: expanded
                          ? MediaQuery.of(context).size.height - 340 - 32
                          : 0,
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    TextField(
                                      controller: enterWeightText,
                                      autofocus: true,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      style: const TextStyle(fontSize: 36),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Consumer<BiometricsDataController>(
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
                                            double weight = double.parse(
                                                enterWeightText.text);
                                            await controller.addWeight(weight);
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
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
