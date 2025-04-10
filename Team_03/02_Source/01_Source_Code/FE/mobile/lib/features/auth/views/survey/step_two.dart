import 'package:flutter/material.dart';
import 'package:mobile/common/widgets/select_box/select_box.dart';

class StepTwo extends StatefulWidget {
  final String selectedGoal;
  final ValueChanged<String> onGoalSelected;
  final GlobalKey<FormState> formKey;

  const StepTwo({
    super.key,
    required this.selectedGoal,
    required this.onGoalSelected,
    required this.formKey,
  });

  @override
  _StepTwoState createState() => _StepTwoState();
}

class _StepTwoState extends State<StepTwo> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Step 2: What is your goal?'),
          const SizedBox(height: 16),
          FormField<String>(
            validator: (value) {
              if (widget.selectedGoal.isEmpty) {
                return "Please select a goal";
              }
              return null;
            },
            builder: (fieldState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (fieldState.hasError)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        fieldState.errorText!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  SelectBox<String>(
                    title: 'Gain weight',
                    value: 'Gain weight',
                    groupValue: widget.selectedGoal,
                    onChanged: (value) {
                      widget.onGoalSelected(value);
                      fieldState.didChange(value);
                    },
                  ),
                  const SizedBox(height: 10),
                  SelectBox<String>(
                    title: 'Maintain weight',
                    value: 'Maintain weight',
                    groupValue: widget.selectedGoal,
                    onChanged: (value) {
                      widget.onGoalSelected(value);
                      fieldState.didChange(value);
                    },
                  ),
                  const SizedBox(height: 10),
                  SelectBox<String>(
                    title: 'Lose weight',
                    value: 'Lose weight',
                    groupValue: widget.selectedGoal,
                    onChanged: (value) {
                      widget.onGoalSelected(value);
                      fieldState.didChange(value);
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
