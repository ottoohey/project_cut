import 'package:flutter/material.dart';
import 'package:project_cut/providers/cycle_configuration_controller.dart';
import 'package:project_cut/providers/dropdown_controller.dart';
import 'package:project_cut/widgets/standard_button.dart';
import 'package:project_cut/widgets/standard_text_field.dart';
import 'package:provider/provider.dart';

class DataEntryDropdown extends StatefulWidget {
  final String dropdownType;

  const DataEntryDropdown({Key? key, required this.dropdownType})
      : super(key: key);

  @override
  State<DataEntryDropdown> createState() => _DataEntryDropdownState();
}

class _DataEntryDropdownState extends State<DataEntryDropdown> {
  final enterWeightText = TextEditingController();
  @override
  Widget build(BuildContext context) {
    bool expanded = Provider.of<DropdownController>(context).expanded;
    return Align(
      alignment: Alignment.topCenter,
      child: AnimatedContainer(
        curve: Curves.easeOutCirc,
        // TODO: Text in dropdown container overflowing whilst container expanding
        duration: const Duration(milliseconds: 400),
        height: expanded ? MediaQuery.of(context).size.height : 0,
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).colorScheme.primary,
        child: expanded ? _dropdownScaffold() : Container(),
      ),
    );
  }

  Material _dropdownScaffold() {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            dropdownContent(),
            StandardisedButton(action: widget.dropdownType),
          ],
        ),
      ),
    );
  }

  Column dropdownContent() {
    switch (widget.dropdownType) {
      case 'addDailyWeight':
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            SizedBox(
              height: 64,
            ),
            Text(
              'Todays Weight :)',
              style: TextStyle(
                fontSize: 42,
              ),
            ),
            SizedBox(
              height: 32,
            ),
            StandardisedTextField(
                action: 'addDailyWeight',
                hint: 'WEIGHT',
                unit: 'kg',
                decimal: true),
          ],
        );
      case 'calculateBodyfat':
        String sex = Provider.of<CycleConfigurationController>(context).sex;
        return Column(
          children: [
            const SizedBox(
              height: 64,
            ),
            const Text(
              'US Navy Bodyfat % Calculator',
              style: TextStyle(
                fontSize: 36,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'This bodyfat calculator uses the US Navy method, which is fairly accurate with little equipment',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            const StandardisedTextField(
                action: 'addNeckCircumference',
                hint: 'NECK',
                unit: 'cm',
                decimal: true),
            const SizedBox(
              height: 16,
            ),
            const StandardisedTextField(
                action: 'addWaistCircumference',
                hint: 'WAIST',
                unit: 'cm',
                decimal: true),
            const SizedBox(
              height: 16,
            ),
            sex.toLowerCase() != 'male'
                ? const StandardisedTextField(
                    action: 'addHipsCircumference',
                    hint: 'HIPS',
                    unit: 'cm',
                    decimal: true)
                : const SizedBox(),
          ],
        );
      case 'editWeight':
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            SizedBox(
              height: 64,
            ),
            Text(
              'Edit Weight',
              style: TextStyle(
                fontSize: 42,
              ),
            ),
            SizedBox(
              height: 32,
            ),
            StandardisedTextField(
                action: 'editWeight',
                hint: 'WEIGHT',
                unit: 'kg',
                decimal: true),
          ],
        );
      default:
        return Column();
    }
  }
}
