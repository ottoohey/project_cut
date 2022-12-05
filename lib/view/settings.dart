import 'package:flutter/material.dart';
import 'package:project_cut/controller/biometrics_data_controller.dart';
import 'package:project_cut/controller/edit_biometrics_history_controller.dart';
import 'package:project_cut/view/edit_weights.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  static final List<String> _settings = [
    'Start new cut',
    'View previous cut',
    'Edit weights'
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
          // height: 200,
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
                        print('start new cut');
                      } else if (index == 1) {
                        print('View previous cut');
                      } else if (index == 2) {
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
                              child: EditWeights(),
                            ),
                          ),
                        );
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
