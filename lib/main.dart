import 'package:flutter/material.dart';
import 'package:project_cut/providers/biometrics_data_controller.dart';
import 'package:project_cut/providers/cycle_configuration_controller.dart';
import 'package:project_cut/providers/dropdown_controller.dart';
import 'package:project_cut/providers/progress_pics_controller.dart';
import 'package:project_cut/theme.dart';
import 'package:project_cut/view/cycle_configuration.dart';
import 'package:project_cut/view/progress_pics.dart';
import 'package:project_cut/view/settings.dart';
import 'package:project_cut/widgets.dart';
import 'package:project_cut/widgets/dropdown_data_entry.dart';
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
        title: 'Project Cut',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider(
                create: (context) => BiometricsDataController()),
            ChangeNotifierProvider(create: (context) => DropdownController()),
          ],
          child: const MyHomePage(title: 'Project Cut'),
        ),
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

  @override
  void initState() {
    _cycleConfigurationRequiredFuture = _cycleConfigurationRequired();
    super.initState();
  }

  Future _cycleConfigurationRequired() async {
    await Provider.of<BiometricsDataController>(context, listen: false)
        .setHomePageData();
  }

  Widget _buttonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        MaterialButton(
          color: Theme.of(context).colorScheme.secondary,
          height: (MediaQuery.of(context).size.width / 2) * (2 / 3) - 24,
          minWidth: MediaQuery.of(context).size.width / 2 - 32,
          padding: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 0,
          onPressed: () async {
            await Navigator.of(context)
                .push(
                  MaterialPageRoute(
                    builder: (context) =>
                        ChangeNotifierProvider<BiometricsDataController>(
                      create: (context) => BiometricsDataController(),
                      child: const Settings(),
                    ),
                  ),
                )
                .whenComplete(_cycleConfigurationRequired);
          },
          child: Column(
            children: [
              const Text('SETTINGS'),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(
                  Icons.settings,
                  size: 42,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
        MaterialButton(
          color: Theme.of(context).colorScheme.secondary,
          height: (MediaQuery.of(context).size.width / 2) * (2 / 3) - 24,
          minWidth: MediaQuery.of(context).size.width / 2 - 32,
          padding: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 0,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    ChangeNotifierProvider<ProgressPicsController>(
                  create: (context) => ProgressPicsController(),
                  child: const ProgressPictures(),
                ),
              ),
            );
          },
          child: Column(
            children: [
              const Text('PROGRESS PIC'),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(
                  Icons.camera_alt_rounded,
                  size: 42,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _cycleConfigurationRequiredFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          bool newCut = Provider.of<BiometricsDataController>(context).newCut;
          if (newCut) {
            bool firstCycle =
                Provider.of<BiometricsDataController>(context).firstCycle;
            return newCycleConfigurationScreen(context, firstCycle);
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
                              height: 50,
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
                            const SizedBox(
                              height: 24,
                            ),
                            _buttonRow(),
                            const SizedBox(
                              height: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  floatingActionButton: _addWeightFloatingActionButton(context),
                ),
                const DataEntryDropdown(
                  dropdownType: 'addDailyWeight',
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

  FloatingActionButton _addWeightFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Provider.of<DropdownController>(context, listen: false).setExpanded();
      },
      child: const Icon(Icons.add),
    );
  }

  Container newCycleConfigurationScreen(BuildContext context, bool firstCycle) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Theme.of(context).colorScheme.primary,
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 64,
                  ),
                  Text(
                    'PROJECT CUT',
                    style: Theme.of(context).textTheme.headline4,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Text(
                    'We just need to get a few bits of information to set everything up. All data is stored on your phone, so only you have access to it!',
                    style: Theme.of(context).textTheme.subtitle1,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.height / 3,
                child: Image(
                  image: AssetImage(MediaQuery.of(context).platformBrightness ==
                          Brightness.light
                      ? 'assets/icons/Project-Cut-1024x1024.png'
                      : 'assets/icons/Project-Cut-1024x1024-Dark.png'),
                ),
              ),
              firstCycle
                  ? MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      height: 52,
                      color: Theme.of(context).colorScheme.outline,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MultiProvider(
                              providers: [
                                ChangeNotifierProvider(
                                    create: (context) =>
                                        CycleConfigurationController()),
                                ChangeNotifierProvider(
                                    create: (context) => DropdownController()),
                              ],
                              child: const CycleConfiguration(),
                            ),
                          ),
                        );
                        await _cycleConfigurationRequired();
                      },
                      child: const Text(
                        'Get Started',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                          minWidth:
                              MediaQuery.of(context).size.width * 0.25 - 32,
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
                          onPressed: () async {
                            await Provider.of<BiometricsDataController>(context,
                                    listen: false)
                                .cancelNewCut();
                            await _cycleConfigurationRequired();
                          },
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        MaterialButton(
                          minWidth:
                              MediaQuery.of(context).size.width * 0.75 - 36,
                          height: 52,
                          color: Theme.of(context).colorScheme.outline,
                          elevation: 0,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5),
                            ),
                          ),
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
                                            DropdownController()),
                                  ],
                                  child: const CycleConfiguration(),
                                ),
                              ),
                            );
                            await _cycleConfigurationRequired();
                          },
                          child: const Text(
                            'Get Started',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
