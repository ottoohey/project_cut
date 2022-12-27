import 'package:flutter/material.dart';
import 'package:project_cut/controller/biometrics_data_controller.dart';
import 'package:project_cut/controller/cycle_history_controller.dart';
import 'package:project_cut/controller/edit_biometrics_history_controller.dart';
import 'package:project_cut/view/cycle_history.dart';
import 'package:project_cut/view/edit_weights.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  static final List<String> _settings = [
    'Edit weights',
    'View previous cut',
    'Start new cut',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        shadowColor: Colors.transparent,
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(16),
          height: 220,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(25)),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _settings.length,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    onPressed: () {
                      if (index == 0) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MultiProvider(
                              providers: [
                                ChangeNotifierProvider(
                                  create: (context) =>
                                      EditBiometricsHistoryController(),
                                ),
                                ChangeNotifierProvider(
                                  create: (context) =>
                                      BiometricsDataController(),
                                )
                              ],
                              child: const EditWeights(),
                            ),
                          ),
                        );
                      } else if (index == 1) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MultiProvider(
                              providers: [
                                ChangeNotifierProvider(
                                  create: (context) => CycleHistoryController(),
                                ),
                                ChangeNotifierProvider(
                                  create: (context) =>
                                      BiometricsDataController(),
                                )
                              ],
                              child: const CycleHistory(),
                            ),
                          ),
                        );
                      } else if (index == 2) {
                        Provider.of<BiometricsDataController>(context,
                                listen: false)
                            .startNewCut()
                            .then((value) => Navigator.pop(context));
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Card(
                          color: Colors.transparent,
                          shadowColor: Colors.transparent,
                          child: Text(
                            _settings[index],
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        const SizedBox(
                          child: Icon(Icons.arrow_forward_ios_rounded),
                        ),
                      ],
                    ),
                  ),
                  index == _settings.length - 1
                      ? const SizedBox()
                      : const Divider(),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
