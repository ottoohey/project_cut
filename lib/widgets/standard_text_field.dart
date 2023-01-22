import 'package:flutter/material.dart';
import 'package:project_cut/providers/biometrics_data_controller.dart';
import 'package:project_cut/providers/cycle_configuration_controller.dart';
import 'package:project_cut/providers/edit_biometrics_history_controller.dart';
import 'package:provider/provider.dart';

class StandardisedTextField extends StatelessWidget {
  final String action;
  final String hint;
  final String unit;
  final bool decimal;

  const StandardisedTextField(
      {Key? key,
      required this.action,
      required this.hint,
      required this.unit,
      required this.decimal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String value = _getInitialValue(context);
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(hint),
          const SizedBox(
            height: 8,
          ),
          Container(
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: TextField(
                showCursor: true,
                cursorColor: Theme.of(context).colorScheme.onPrimary,
                maxLines: 1,
                textAlign: TextAlign.end,
                keyboardType: TextInputType.numberWithOptions(decimal: decimal),
                controller: TextEditingController(text: value),
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            const BorderSide(color: Colors.transparent)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onPrimary)),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    suffix: Text(unit)),
                onChanged: (enteredValue) {
                  if (enteredValue == '') {
                    enteredValue = '0';
                  }
                  value = enteredValue;
                  _setTextFieldValue(context, enteredValue);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _setTextFieldValue(BuildContext context, String value) {
    switch (action) {
      case 'addDailyWeight':
        Provider.of<BiometricsDataController>(context, listen: false)
            .setTempWeight(double.parse(value));
        break;
      case 'addHeight':
        Provider.of<CycleConfigurationController>(context, listen: false)
            .setHeight(value);
        break;
      case 'addWeight':
        Provider.of<CycleConfigurationController>(context, listen: false)
            .setStartingWeight(value);
        break;
      case 'addAge':
        Provider.of<CycleConfigurationController>(context, listen: false)
            .setAge(value);
        break;
      case 'addNeckCircumference':
        Provider.of<CycleConfigurationController>(context, listen: false)
            .setNeck(value);
        break;
      case 'addWaistCircumference':
        Provider.of<CycleConfigurationController>(context, listen: false)
            .setWaist(value);
        break;
      case 'addHipsCircumference':
        Provider.of<CycleConfigurationController>(context, listen: false)
            .setHips(value);
        break;
      case 'addStartingBodyfat':
        Provider.of<CycleConfigurationController>(context, listen: false)
            .setStartingBodyFat(value);
        break;
      case 'addGoalBodyfat':
        Provider.of<CycleConfigurationController>(context, listen: false)
            .setGoalBodyFat(value);
        break;
      case 'editWeight':
        Provider.of<EditBiometricsHistoryController>(context, listen: false)
            .setWeight(double.parse(value));
        break;
      default:
    }
  }

  String _getInitialValue(BuildContext context) {
    switch (action) {
      case 'addDailyWeight':
        return Provider.of<BiometricsDataController>(context)
            .currentWeight
            .toString();
      case 'addHeight':
        return Provider.of<CycleConfigurationController>(context)
            .height
            .toString();
      case 'addWeight':
        return Provider.of<CycleConfigurationController>(context)
            .startingWeight
            .toString();
      case 'addAge':
        return Provider.of<CycleConfigurationController>(context)
            .age
            .toString();
      case 'addNeckCircumference':
        return Provider.of<CycleConfigurationController>(context)
            .neck
            .toString();
      case 'addWaistCircumference':
        return Provider.of<CycleConfigurationController>(context)
            .waist
            .toString();
      case 'addHipsCircumference':
        return Provider.of<CycleConfigurationController>(context)
            .hips
            .toString();
      case 'addStartingBodyfat':
        return Provider.of<CycleConfigurationController>(context)
            .startingBodyFat
            .toString();
      case 'addGoalBodyfat':
        return Provider.of<CycleConfigurationController>(context)
            .goalBodyFat
            .toString();
      case 'editWeight':
        return Provider.of<EditBiometricsHistoryController>(context)
            .weight
            .toString();
      default:
        return '0';
    }
  }
}
