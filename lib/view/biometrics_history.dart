import 'package:flutter/material.dart';
import 'package:project_cut/controller/biometrics_history_controller.dart';
import 'package:project_cut/database/db.dart';
import 'package:project_cut/model/biometric.dart';
import 'package:provider/provider.dart';

class BiometricsHistory extends StatefulWidget {
  const BiometricsHistory({Key? key}) : super(key: key);

  @override
  State<BiometricsHistory> createState() => _BiometricsHistoryState();
}

class _BiometricsHistoryState extends State<BiometricsHistory> {
  List<Biometric> biometrics = [];
  @override
  void initState() {
    super.initState();
  }

  Future<void> modifyBiometric(Biometric oldValue) async {
    Biometric biometric = Biometric(
      id: oldValue.id,
      weekId: oldValue.weekId,
      cycleId: oldValue.cycleId,
      currentWeight: 76.3,
      bodyFat: oldValue.bodyFat,
      dateTime: oldValue.dateTime,
      day: oldValue.day,
      estimated: oldValue.estimated,
    );

    await AppDatabase.db.updateBiometric(biometric);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BiometricsHistoryController>(
      builder: (context, controller, child) {
        return Scaffold(
          body: Column(
            children: [
              const SizedBox(
                height: 150,
              ),
              MaterialButton(
                child: const Text('Clear database'),
                onPressed: () {
                  AppDatabase.db.deleteAll();
                },
              ),
              SizedBox(
                height: 300,
                child: FutureBuilder(
                  future: controller.getBiometrics,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const CircularProgressIndicator();
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => modifyBiometric(snapshot.data![index]),
                            child: Container(
                              height: 50,
                              color: Colors.amber[index * 100],
                              child: Center(
                                child: Text(
                                  snapshot.data![index].currentWeight
                                      .toString(),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
