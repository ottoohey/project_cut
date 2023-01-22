import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_cut/providers/dropdown_controller.dart';
import 'package:project_cut/providers/edit_biometrics_history_controller.dart';
import 'package:project_cut/model/biometric.dart';
import 'package:project_cut/model/week.dart';
import 'package:project_cut/widgets/dropdown_data_entry.dart';
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
    return Stack(
      children: [
        Scaffold(
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
                              Week week = editBiometricsProvider.weeks
                                  .where(
                                    (element) => element.id == biometric.weekId,
                                  )
                                  .first;
                              return Column(
                                children: [
                                  index == 0 ||
                                          biometric.weekId !=
                                              allBiometrics[index - 1].weekId
                                      ? Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 32, 32, 8),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Week ${week.week}",
                                              style:
                                                  const TextStyle(fontSize: 18),
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                  ListTile(
                                    textColor: Colors.black,
                                    tileColor:
                                        Theme.of(context).colorScheme.secondary,
                                    title: Row(
                                      children: [
                                        Text(
                                          '${biometric.currentWeight.toString()}kg',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          biometric.estimated == 1
                                              ? '(estimated)'
                                              : '',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitle: Text(
                                      dateFormat.format(
                                          DateTime.parse(biometric.dateTime)),
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                    ),
                                    trailing: Icon(
                                      Icons.edit,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                                    onTap: () {
                                      Provider.of<DropdownController>(context,
                                              listen: false)
                                          .setExpanded();
                                      editBiometricsProvider
                                          .setBiometricIdToEdit(biometric.id!);
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              }),
        ),
        const DataEntryDropdown(dropdownType: 'editWeight'),
      ],
    );
  }
}
