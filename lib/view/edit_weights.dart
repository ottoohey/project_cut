import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_cut/controller/biometrics_data_controller.dart';
import 'package:project_cut/controller/edit_biometrics_history_controller.dart';
import 'package:project_cut/model/biometric.dart';
import 'package:provider/provider.dart';

class EditWeights extends StatefulWidget {
  const EditWeights({Key? key}) : super(key: key);

  @override
  State<EditWeights> createState() => _EditWeightsState();
}

class _EditWeightsState extends State<EditWeights> {
  final dateFormat = DateFormat('yyyy-MM-dd');
  Future? _biometricHistoryFuture;

  Future<void> _getBiometricHistory() async {
    await Provider.of<EditBiometricsHistoryController>(context, listen: false)
        .setAllBiometrics();
  }

  @override
  void initState() {
    super.initState();
    _biometricHistoryFuture = _getBiometricHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Weights",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        shadowColor: Colors.transparent,
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: FutureBuilder(
          future: _biometricHistoryFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Consumer<EditBiometricsHistoryController>(
                builder: (context, editBiometricsProvider, child) {
                  List<Biometric> allBiometrics =
                      editBiometricsProvider.allBiometrics;
                  double initialWeight = editBiometricsProvider.weight;
                  TextEditingController textEditingController =
                      TextEditingController(text: initialWeight.toString());
                  textEditingController.selection = TextSelection.collapsed(
                      offset: initialWeight.toString().length);
                  return Stack(
                    children: [
                      ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: allBiometrics.length,
                        itemBuilder: (context, index) {
                          Biometric biometric = allBiometrics[index];
                          return ListTile(
                            textColor: Colors.black,
                            tileColor: Theme.of(context).colorScheme.secondary,
                            title: Row(
                              children: [
                                Text(
                                  biometric.currentWeight.toString(),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  biometric.estimated == 1 ? '(estimated)' : '',
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  biometric.weekId.toString(),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              dateFormat
                                  .format(DateTime.parse(biometric.dateTime)),
                            ),
                            trailing: const Icon(Icons.edit),
                            onTap: () {
                              editBiometricsProvider.setExpanded();
                              editBiometricsProvider
                                  .setBiometricIdToEdit(biometric.id!);
                            },
                          );
                        },
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: AnimatedContainer(
                          curve: Curves.easeOutCirc,
                          // TODO: Text in dropdown container overflowing whilst container expanding
                          duration: const Duration(milliseconds: 400),
                          height: editBiometricsProvider.expanded
                              ? MediaQuery.of(context).size.height
                              : 0,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          child: editBiometricsProvider.expanded
                              ? Card(
                                  color: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  child: Padding(
                                    padding: const EdgeInsets.all(32),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Edit Away :)',
                                          style: TextStyle(
                                              fontSize: 36,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        TextField(
                                          showCursor: true,
                                          cursorColor: Colors.white,
                                          maxLines: 1,
                                          textAlign: TextAlign.end,
                                          keyboardType: const TextInputType
                                              .numberWithOptions(decimal: true),
                                          controller: textEditingController,
                                          autofocus: true,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 32,
                                          ),
                                          decoration: const InputDecoration(
                                            suffix: Text(
                                              'kg',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          onChanged: (enteredValue) {
                                            if (enteredValue == '') {
                                              enteredValue = '0';
                                            }

                                            initialWeight =
                                                double.parse(enteredValue);

                                            editBiometricsProvider.setWeight(
                                                double.parse(enteredValue));
                                          },
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
                                            editBiometricsProvider.editWeight();
                                            editBiometricsProvider
                                                .setExpanded();
                                            Provider.of<BiometricsDataController>(
                                                    context,
                                                    listen: false)
                                                .setWeight(100);
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
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}
