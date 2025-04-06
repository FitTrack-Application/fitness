import 'package:flutter/material.dart';
import 'package:mobile/common/widgets/tonal_button/tonal_button.dart';
import 'package:mobile/cores/constants/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/auth/models/user_info.dart';  
import 'package:mobile/features/auth/services/api_service.dart';  
import 'step_one.dart';
import 'step_two.dart';
import 'step_three.dart';
import 'step_four.dart';
import 'step_five.dart';
class UserSurvey extends StatefulWidget {
  const UserSurvey({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserSurveyState createState() => _UserSurveyState();
}


class _UserSurveyState extends State<UserSurvey> {
  int _currentStep = 0;
  final TextEditingController _nameController = TextEditingController();
  String _selectedGoal = '';
  String _selectedGender = '';
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _weightGoalController = TextEditingController();
  final GlobalKey<FormState> _stepOneKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _stepTwoKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _stepThreeKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _stepFourKey = GlobalKey<FormState>();
  double _goalPerWeek = 0.2;
  String _selectedActivityLevel = '';
  final double _calorieGoal = 0.0; 
  final apiService = ApiService();
  void _previousStep() {
    setState(() {
      if (_currentStep > 0) {
        _currentStep--;
      }
    });
  }

  void _nextStep() {
    setState(() {
      if (_currentStep == 0) {
        if (!(_stepOneKey.currentState?.validate() ?? false)) {
          return; 
        }
      }
      if (_currentStep == 1) {
        // Validate StepTwo before moving to the next step
        if (!(_stepTwoKey.currentState?.validate() ?? false)) {
          return; // Prevent moving to the next step if validation fails
        }
      }
      if (_currentStep == 2) {
        // Validate StepThree before moving to the next step
        if (!(_stepThreeKey.currentState?.validate() ?? false)) {
          return; // Prevent moving to the next step if validation fails
        }
      }
      if (_currentStep == 3) {
        // Validate StepFour before moving to the next step
        if (!(_stepFourKey.currentState?.validate() ?? false)) {
          return; // Prevent moving to the next step if validation fails
        }
      }

      if (_currentStep < 5) {
        _currentStep++;
      } else {
        // Navigate to /dashboard when the last step is completed
        sendSurveyData(); 
        context.go('/dashboard');
      }
    });
  }
  void sendSurveyData() async {
    final String name = _nameController.text.trim();
    final int age = int.tryParse(_ageController.text.trim()) ?? 0;
    final String gender = _selectedGender;
    final double height = double.tryParse(_heightController.text.trim()) ?? 0.0;
    final double weight = double.tryParse(_weightController.text.trim()) ?? 0.0;
    final double weightGoal = double.tryParse(_weightGoalController.text.trim()) ?? 0.0;
    final String goal = _selectedGoal;
    final String activityLevel = _selectedActivityLevel;
    final double calorieGoal = _calorieGoal;
    final userInfo = UserInfo(
      userID: "12345", 
      name: name,
      age: age,
      gender: gender,
      height: height,
      weight: weight,
      goalType: goal,
      target: weightGoal,
      goalPerWeek: _goalPerWeek,
      activityLevel: activityLevel,
      calorieGoal: calorieGoal,
      imageURL: "https://example.com/avatar.jpg", // Optional field
    );

    try {
      await apiService.userSurvey(userInfo);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Survey data submitted successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error submitting survey: $e")),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Survey'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (_currentStep + 1) / 6,
              color: Colors.green,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _currentStep == 0
                  ? StepOne(nameController: _nameController, formKey: _stepOneKey,)
                  : _currentStep == 1
                      ? StepTwo(
                          formKey: _stepTwoKey,
                          selectedGoal: _selectedGoal,
                          onGoalSelected: (goal) {
                            setState(() {
                              _selectedGoal = goal;
                            });
                          },
                        )
                      : _currentStep == 2
                          ? StepThree(
                              formKey: _stepThreeKey,
                              selectedGender: _selectedGender,
                              onGenderSelected: (gender) {
                                setState(() {
                                  _selectedGender = gender;
                                });
                              },
                              ageController: _ageController,
                              heightController: _heightController,
                              weightController: _weightController,
                            )
                          : _currentStep == 3
                              ? StepFour(
                                  formKey: _stepFourKey,
                                  weightController: _weightController, // Pass current weight
                                  goal: _selectedGoal,
                                  weightGoalController: _weightGoalController,
                                  goalPerWeek: _goalPerWeek,
                                  onGoalPerWeekSelected: (goal) {
                                    setState(() {
                                      _goalPerWeek = goal;
                                    });
                                  },
                                )
                              : _currentStep == 4
                                  ? StepFive(
                                      selectedActivityLevel: _selectedActivityLevel,
                                      onActivityLevelSelected: (activityLevel) {
                                        setState(() {
                                          _selectedActivityLevel = activityLevel;
                                        });
                                      },
                                    )
                                  : Summary(
                                      name: _nameController.text,
                                      goal: _selectedGoal,
                                      gender: _selectedGender,
                                      age: _ageController.text,
                                      height: _heightController.text,
                                      weight: _weightController.text,
                                      weightGoal: _weightGoalController.text,
                                      goalPerWeek: _goalPerWeek,
                                      activityLevel: _selectedActivityLevel,
                                    ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TonalButton(
                  onPressed: _previousStep,
                  //icon: const Icon(Icons.arrow_back, color: HighlightColors.highlight500),
                  icon: Icons.arrow_back,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _nextStep,
                    child: const Text('Next'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Summary extends StatelessWidget {
  final String name;
  final String goal;
  final String gender;
  final String age;
  final String height;
  final String weight;
  final String weightGoal;
  final double goalPerWeek;
  final String activityLevel;

  const Summary({super.key,
    required this.name,
    required this.goal,
    required this.gender,
    required this.age,
    required this.height,
    required this.weight,
    required this.weightGoal,
    required this.goalPerWeek,
    required this.activityLevel,
  });

  double calculateGoal() {
    double weight = double.parse(this.weight);
    double height = double.parse(this.height);
    int age = int.parse(this.age);
    double calorieGoal;

    if (gender == 'Male') {
      calorieGoal = (10 * weight) + (6.25 * height) - (5 * age) + 5;
    } else {
      calorieGoal = (10 * weight) + (6.25 * height) - (5 * age) - 161;
    }

    double activityFactor;
    switch (activityLevel) {
      case 'Sedentary':
        activityFactor = 1.2;
        break;
      case 'Lightly active':
        activityFactor = 1.375;
        break;
      case 'Moderately active':
        activityFactor = 1.55;
        break;
      case 'Very active':
        activityFactor = 1.725;
        break;
      case 'Extra active':
        activityFactor = 1.9;
        break;
      default:
        activityFactor = 1.0;
    }
    calorieGoal = calorieGoal * activityFactor;
    switch (goal) {
      case 'Lose weight':
        calorieGoal -= goalPerWeek; // Subtract 500 calories for weight loss
        break;
      case 'Gain weight':
        calorieGoal += goalPerWeek; // Add 500 calories for weight gain
        break;
      case 'Maintain weight':
        break; // No change for maintenance
      default:
        break;
    }
    return calorieGoal;
  }

  @override
  Widget build(BuildContext context) {
    double calorieGoal = calculateGoal();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Summary', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: HighlightColors.highlight500), // Added border with HighlightColors.highlight500
                ),
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: $name', style: Theme.of(context).textTheme.bodyMedium),
                Text('Gender: $gender', style: Theme.of(context).textTheme.bodyMedium),
                Text('Age: $age', style: Theme.of(context).textTheme.bodyMedium),
              ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: HighlightColors.highlight500), // Added border with HighlightColors.highlight500
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Height: $height cm', style: Theme.of(context).textTheme.bodyMedium),
                    Text('Weight: $weight kg', style: Theme.of(context).textTheme.bodyMedium),
                    Text('$activityLevel', style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
            ),
          ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
            Expanded(
              child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: HighlightColors.highlight500), // Added border with HighlightColors.highlight500
              ),
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Goal: $goal', style: Theme.of(context).textTheme.bodyMedium),
              Text('Weight Goal: $weightGoal kg', style: Theme.of(context).textTheme.bodyMedium),
              Text('Goal per Week: ${goalPerWeek.toString()} kg', style: Theme.of(context).textTheme.bodyMedium),
            ],
              ),
              ),
            ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
            Expanded(
              child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: HighlightColors.highlight500), // Added border with HighlightColors.highlight500
              ),
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Calorie Goal per day (Remaining =  Goal - Food + Exercise): ${calorieGoal.toStringAsFixed(2)} kcal', style: Theme.of(context).textTheme.displayLarge), 
            ],
              ),
              ),
            ),
            ],
          ),
        ],
      ),
    );
  }
}