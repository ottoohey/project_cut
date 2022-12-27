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
                  return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: cycleHistory.length,
                    itemBuilder: (context, index) {
                      Cycle cycle = cycleHistory[index];
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
              return CircularProgressIndicator();
            }
          }),
    );
  }
}
