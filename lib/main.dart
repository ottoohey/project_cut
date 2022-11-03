import 'package:flutter/material.dart';
import 'package:project_cut/controller/cycle_configuration_controller.dart';
import 'package:project_cut/database/db.dart';
import 'package:project_cut/theme.dart';
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
  int? value;

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  //Loading counter value on start
  Future<void> _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      value = (prefs.getInt('counter'));
    });
  }

  @override
  Widget build(BuildContext context) {
    if (value == null) {
      return ChangeNotifierProvider(
        create: (context) => CycleConfigurationController(),
        child: const CycleConfiguration(),
      );
    } else {
      print('nothing there :(');
    }

    return Scaffold(
      body: Center(
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
                height: 32,
              ),
              Container(
                color: Theme.of(context).colorScheme.onSecondary,
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: const Center(
                  child: Text(
                    'GRAPH',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 32,
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
                height: 24,
              ),
              const WeeksRemainingIndicator(),
              const SizedBox(
                height: 32,
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
                        child: const NeumorphicCard(
                          title: 'SETTINGS',
                          value: '',
                          amount: '',
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
                          value: '',
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
                        onPressed: () => BiometricsDatabase.biometricsDatabase
                            .insertBiometric(const Biometric(
                                id: 2,
                                currentWeight: 74,
                                bodyFat: 29,
                                dateTime: 'hello',
                                weekId: 132)),
                      ),
                      MaterialButton(
                        child: const Text('delete'),
                        onPressed: () => BiometricsDatabase.biometricsDatabase
                            .deleteBiometrics(0),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // ignore: avoid_print
          print(await BiometricsDatabase.biometricsDatabase.getBiometrics());
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
