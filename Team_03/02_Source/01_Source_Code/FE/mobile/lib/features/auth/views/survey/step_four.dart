import 'package:flutter/material.dart';
import 'package:mobile/common/widgets/select_box/select_box.dart';

class StepFour extends StatefulWidget {
  final TextEditingController weightGoalController; // Weight goal input
  final TextEditingController weightController; // Current weight from Step Three
  final String goal; // Goal type: Gain Weight, Maintain Weight, Lose Weight
  final double goalPerWeek;
  final ValueChanged<double> onGoalPerWeekSelected; // Callback for goal per week
  final ValueChanged<String> onWeightGoalChanged; // Callback for weight goal
  final GlobalKey<FormState> formKey;

  const StepFour({
    super.key,
    required this.weightGoalController,
    required this.weightController,
    required this.goal,
    required this.goalPerWeek,
    required this.onGoalPerWeekSelected,
    required this.onWeightGoalChanged, // Add this parameter
    required this.formKey,
  });

  @override
  _StepFourState createState() => _StepFourState();
}

class _StepFourState extends State<StepFour> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey, // Associate the Form with the GlobalKey
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Step 4: Enter your weight goal and goal per week'),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: widget.weightGoalController,
              decoration: InputDecoration(
                labelText:
                    'Enter your weight goal (kg) starting from ${widget.weightController.text}',
              ),
              keyboardType: TextInputType.number,
              onChanged: widget.onWeightGoalChanged, // Use the callback here
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Weight goal cannot be empty";
                }
                final weightGoal = double.tryParse(value);
                final currentWeight =
                    double.tryParse(widget.weightController.text);

                if (weightGoal == null || weightGoal <= 0) {
                  return "Please enter a valid weight goal";
                }

                // Validation based on the selected goal
                if (currentWeight != null) {
                  if (widget.goal == 'Gain Weight') {
                    if (weightGoal <= currentWeight) {
                      return "Weight goal must be greater than your current weight for gaining weight";
                    }
                  } else if (widget.goal == 'Lose Weight') {
                    if (weightGoal >= currentWeight) {
                      return "Weight goal must be less than your current weight for losing weight";
                    }
                  } else if (widget.goal == 'Maintain Weight') {
                    if ((weightGoal - currentWeight).abs() > 1) {
                      return "Weight goal must be close to your current weight for maintaining weight";
                    }
                  }
                }

                return null; // Return null if the input is valid
              },
            ),
          ),
          const SizedBox(height: 16),
          const Text('Select your goal per week:'),
          FormField<double>(
            validator: (value) {
              if (widget.goalPerWeek <= 0) {
                return "Please select a goal per week";
              }
              return null; // Return null if the input is valid
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
                  SelectBox<double>(
                    title: '0.2 kg per week',
                    value: 0.2,
                    groupValue: widget.goalPerWeek,
                    onChanged: (value) {
                      widget.onGoalPerWeekSelected(value);
                      fieldState.didChange(value); // Notify the FormField of the change
                    },
                  ),
                  const SizedBox(height: 10),
                  SelectBox<double>(
                    title: '0.5 kg per week',
                    value: 0.5,
                    groupValue: widget.goalPerWeek,
                    onChanged: (value) {
                      widget.onGoalPerWeekSelected(value);
                      fieldState.didChange(value); // Notify the FormField of the change
                    },
                  ),
                  const SizedBox(height: 10),
                  SelectBox<double>(
                    title: '1.0 kg per week',
                    value: 1.0,
                    groupValue: widget.goalPerWeek,
                    onChanged: (value) {
                      widget.onGoalPerWeekSelected(value);
                      fieldState.didChange(value); // Notify the FormField of the change
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
