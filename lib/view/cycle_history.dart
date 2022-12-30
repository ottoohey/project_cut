import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_cut/controller/cycle_history_controller.dart';
import 'package:project_cut/model/cycle.dart';
import 'package:provider/provider.dart';

class CycleHistory extends StatefulWidget {
  const CycleHistory({Key? key}) : super(key: key);

  @override
  State<CycleHistory> createState() => _CycleHistoryState();
}

class _CycleHistoryState extends State<CycleHistory> {
  final dateFormat = DateFormat('dd-MM-yyyy');
  Future? _biometricHistoryFuture;

  Future<void> _getBiometricHistory() async {
    await Provider.of<CycleHistoryController>(context, listen: false)
        .setCycleHistory();
  }

  @override
  void initState() {
    super.initState();
    _biometricHistoryFuture = _getBiometricHistory();
  }

  void _showAlertDialog(
      BuildContext context, CycleHistoryController cycleProvider, int id) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Delete Cut Cycle?'),
        content:
            const Text('This will delete all data associated with this cycle.'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            /// This parameter indicates this action is the default,
            /// and turns the action's text to bold text.
            isDefaultAction: true,
            isDestructiveAction: true,
            onPressed: () async {
              await cycleProvider.deleteCut(id).then((value) =>
                  Navigator.popUntil(context, (route) => route.isFirst));
            },
            child: const Text('Delete'),
          ),
          CupertinoDialogAction(
            /// This parameter indicates the action would perform
            /// a destructive action such as deletion, and turns
            /// the action's text color to red.
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cycle History",
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
              return Consumer<CycleHistoryController>(
                builder: (context, cycleHistoryProvider, child) {
                  List<Cycle> cycleHistory = cycleHistoryProvider.cycleHistory;
                  int currentCycleId = cycleHistoryProvider.currentCycleId;
                  return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: cycleHistory.length,
                    itemBuilder: (context, index) {
                      Cycle cycle = cycleHistory[index];
                      bool currentCycle = true;
                      cycle.id == currentCycleId
                          ? currentCycle = true
                          : currentCycle = false;
                      return ListTile(
                        textColor: Colors.black,
                        tileColor: Theme.of(context).colorScheme.secondary,
                        title: Row(
                          children: [
                            Text(
                              'Cycle #${cycle.id.toString()}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            currentCycle
                                ? const Icon(
                                    Icons.circle,
                                    color: Colors.green,
                                    size: 10,
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              width: 16,
                            ),
                            GestureDetector(
                              onTap: () {
                                _showAlertDialog(
                                    context, cycleHistoryProvider, cycle.id!);
                              },
                              child: const Icon(
                                Icons.delete_forever,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          '${dateFormat.format(DateTime.parse(cycle.startDateTime))} to ${dateFormat.format(DateTime.parse(cycle.endDateTime))}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        // trailing: const Icon(Icons.edit),
                        onTap: () async {
                          await cycleHistoryProvider
                              .setCurrentCycleId(cycle.id!)
                              .then((value) => Navigator.popUntil(
                                  context, (route) => route.isFirst));
                        },
                      );
                    },
                  );
                },
              );
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }
}
