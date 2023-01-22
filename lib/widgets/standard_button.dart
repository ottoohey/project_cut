import 'package:flutter/material.dart';
import 'package:project_cut/providers/biometrics_data_controller.dart';
import 'package:project_cut/providers/cycle_configuration_controller.dart';
import 'package:project_cut/providers/dropdown_controller.dart';
import 'package:project_cut/providers/edit_biometrics_history_controller.dart';
import 'package:provider/provider.dart';

class StandardisedButton extends StatelessWidget {
  final String action;
  const StandardisedButton({Key? key, required this.action}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: MediaQuery.of(context).size.width,
      height: 52,
      color: Theme.of(context).colorScheme.outline,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      onPressed: () {
        _buttonAction(context);
      },
      child: const Text(
        'Save',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  void _buttonAction(BuildContext context) {
    switch (action) {
      case 'addDailyWeight':
        Provider.of<BiometricsDataController>(context, listen: false)
            .addWeight();
        break;
      case 'calculateBodyfat':
        Provider.of<CycleConfigurationController>(context, listen: false)
            .calculateBodyFatPercentage();
        break;
      case 'editWeight':
        Provider.of<EditBiometricsHistoryController>(context, listen: false)
            .editWeight();
        break;
      default:
    }

    Provider.of<DropdownController>(context, listen: false).setExpanded();
  }
}
