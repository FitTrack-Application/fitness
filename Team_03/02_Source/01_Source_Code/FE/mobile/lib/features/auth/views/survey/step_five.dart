import 'package:flutter/material.dart';
import 'package:mobile/common/widgets/select_box/select_box.dart';

class StepFive extends StatelessWidget {
  final String selectedActivityLevel;
  final ValueChanged<String> onActivityLevelSelected;

  const StepFive({
    super.key,
    required this.selectedActivityLevel,
    required this.onActivityLevelSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('Step 5: Select your activity level'),
        SelectBox<String>(
          title: 'Sedentary ',
          value: 'SEDENTARY',
          groupValue: selectedActivityLevel,
          onChanged: onActivityLevelSelected,
        ),
        const SizedBox(height: 10),
        SelectBox<String>(
          title: 'Lightly active',
          value: 'LIGHT',
          groupValue: selectedActivityLevel,
          onChanged: onActivityLevelSelected,
        ),
        const SizedBox(height: 10),
        SelectBox<String>(
          title: 'Moderately active',
          value: 'MODERATE',
          groupValue: selectedActivityLevel,
          onChanged: onActivityLevelSelected,
        ),
        const SizedBox(height: 10),
        SelectBox<String>(
          title: 'Active',
          value: 'ACTIVE',
          groupValue: selectedActivityLevel,
          onChanged: onActivityLevelSelected,
        ),
        const SizedBox(height: 10),
        SelectBox<String>(
          title: 'Very active ',
          value: 'VERY_ACTIVE',
          groupValue: selectedActivityLevel,
          onChanged: onActivityLevelSelected,
        ),
      ],
    );
  }
}
