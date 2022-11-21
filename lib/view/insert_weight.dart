import 'package:flutter/material.dart';
import 'package:project_cut/database/db.dart';

class InsertWeightScreen extends StatelessWidget {
  const InsertWeightScreen({Key? key}) : super(key: key);

  void insertWeight() {}

  @override
  Widget build(BuildContext context) {
    double enteredWeight = 0;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Enter Weight'),
            TextField(
              showCursor: true,
              maxLines: 1,
              textAlign: TextAlign.end,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              // controller: TextEditingController(text: value),
              enabled: true,
              style: TextStyle(
                // color: onPrimary,
                fontSize: 32,
              ),
              decoration: InputDecoration(
                suffix: Text(
                  'kg',
                  // style: TextStyle(color: onPrimary),
                ),
                helperText: 'WEIGHT',
              ),
              onChanged: (value) => enteredWeight = double.parse(value),
            ),
            MaterialButton(
              child: Text('Save'),
              onPressed: () async {
                await AppDatabase.db.addWeight(enteredWeight);
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
  }
}
