import 'package:flutter/material.dart';
import 'package:mobile/common/widgets/select_box/select_box.dart';

class StepThree extends StatefulWidget {
  final String selectedGender;
  final ValueChanged<String> onGenderSelected;
  final TextEditingController ageController;
  final TextEditingController heightController;
  final TextEditingController weightController;
  final ValueChanged<String> onAgeChanged;
  final ValueChanged<String> onHeightChanged;
  final ValueChanged<String> onWeightChanged;
  final GlobalKey<FormState> formKey;

  const StepThree({
    super.key,
    required this.selectedGender,
    required this.onGenderSelected,
    required this.ageController,
    required this.heightController,
    required this.weightController,
    required this.onAgeChanged,
    required this.onHeightChanged,
    required this.onWeightChanged,
    required this.formKey,
  });

  @override
  _StepThreeState createState() => _StepThreeState();
}

class _StepThreeState extends State<StepThree> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Step 3: Tell us more about you'),
          FormField<String>(
            validator: (value) {
              if (widget.selectedGender.isEmpty) {
                return "Please select a gender";
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
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: SelectBox<String>(
                          title: 'Male',
                          value: 'MALE',
                          groupValue: widget.selectedGender,
                          onChanged: (value) {
                            widget.onGenderSelected(value);
                            fieldState.didChange(value);
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SelectBox<String>(
                          title: 'Female',
                          value: 'FEMALE',
                          groupValue: widget.selectedGender,
                          onChanged: (value) {
                            widget.onGenderSelected(value);
                            fieldState.didChange(value);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: widget.ageController,
            decoration: const InputDecoration(
              labelText: 'Enter your age',
            ),
            keyboardType: TextInputType.number,
            onChanged: widget.onAgeChanged,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Age cannot be empty";
              }
              final age = int.tryParse(value);
              if (age == null || age <= 0 || age > 150) {
                return "Please enter a valid age";
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: widget.heightController,
            decoration: const InputDecoration(
              labelText: 'Enter your height (cm)',
            ),
            keyboardType: TextInputType.number,
            onChanged: widget.onHeightChanged,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Height cannot be empty";
              }
              final height = double.tryParse(value);
              if (height == null || height <= 0 || height >= 250) {
                return "Please enter a valid height";
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: widget.weightController,
            decoration: const InputDecoration(
              labelText: 'Enter your weight (kg)',
            ),
            keyboardType: TextInputType.number,
            onChanged: widget.onWeightChanged,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Weight cannot be empty";
              }
              final weight = double.tryParse(value);
              if (weight == null || weight <= 0 || weight >= 300) {
                return "Please enter a valid weight";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
