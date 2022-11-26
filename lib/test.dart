import 'package:flutter/material.dart';
import 'package:project_cut/controller/biometrics_history_controller.dart';
import 'package:provider/provider.dart';

class TesterWidget extends StatefulWidget {
  const TesterWidget({Key? key}) : super(key: key);

  @override
  State<TesterWidget> createState() => _TesterWidgetState();
}

class _TesterWidgetState extends State<TesterWidget> {
  Future? dataFuture;

  @override
  void initState() {
    super.initState();
    dataFuture =
        Provider.of<BiometricsHistoryController>(context, listen: false)
            .updateGraphData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BiometricsHistoryController>(
      builder: (context, controller, child) {
        return FutureBuilder(
          future: dataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              print(controller.getTestValue);
              var testValue = controller.getTestValue;
              return Container(
                width: 300,
                height: 300,
                color: Colors.red,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      onPressed: () => controller.updateTestValue(),
                      child: Text('test'),
                    ),
                    Text(
                      '$testValue',
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    )
                  ],
                ),
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        );
      },
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final DateTime year;
  final double sales;
}
