import 'package:flutter/material.dart';
import 'package:mobile/constants/app_color.dart';
import 'package:mobile/views/select_box.dart';
import 'package:mobile/api_service.dart';
import 'package:mobile/models/user_info.dart';

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
  double _goalPerWeek = 0.2;
  String _selectedActivityLevel = '';

  void _previousStep() {
    setState(() {
      if (_currentStep > 0) {
        _currentStep--;
      }
    });
  }

  void _nextStep() {
    setState(() {
      if (_currentStep < 5) {
        _currentStep++;
      }
    });
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
          children: <Widget>[
            LinearProgressIndicator(
              value: (_currentStep + 1) / 6,
              color: Colors.green,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _currentStep == 0
                  ? StepOne(nameController: _nameController)
                  : _currentStep == 1
                      ? StepTwo(
                          selectedGoal: _selectedGoal,
                          onGoalSelected: (goal) {
                            setState(() {
                              _selectedGoal = goal;
                            });
                          },
                        )
                      : _currentStep == 2
                          ? StepThree(
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
              children: <Widget>[
                ElevatedButton(
                  onPressed: _previousStep,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(16),
                    backgroundColor: AppColors.secondaryColor,
                  ),
                  child: const Icon(Icons.arrow_back, color: AppColors.primaryColor),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                    ),
                    child: const Text('Next', style: TextStyle(color: AppColors.inverseTextColor)),
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

class StepOne extends StatelessWidget {
  final TextEditingController nameController;

  const StepOne({super.key, required this.nameController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('First, What can we call you?'),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter your name',
            ),
            style: const TextStyle(color: AppColors.defaultTextColor),
          ),
        ),
      ],
    );
  }
}

class StepTwo extends StatelessWidget {
  final String selectedGoal;
  final ValueChanged<String> onGoalSelected;

  const StepTwo({super.key, required this.selectedGoal, required this.onGoalSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('Step 2: What is your goal?'),
        SelectBox<String>(
          title: 'Gain Weight',
          value: 'Gain Weight',
          groupValue: selectedGoal,
          onChanged: onGoalSelected,
        ),
        SelectBox<String>(
          title: 'Lose Weight',
          value: 'Lose Weight',
          groupValue: selectedGoal,
          onChanged: onGoalSelected,
        ),
      ],
    );
  }
}

class StepThree extends StatelessWidget {
  final String selectedGender;
  final ValueChanged<String> onGenderSelected;
  final TextEditingController ageController;
  final TextEditingController heightController;
  final TextEditingController weightController;

  const StepThree({super.key, 
    required this.selectedGender,
    required this.onGenderSelected,
    required this.ageController,
    required this.heightController,
    required this.weightController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('Step 3: Tell us more about you'),
        Row(
          children: <Widget>[
            Expanded(
              child: SelectBox<String>(
                title: 'Male',
                value: 'Male',
                groupValue: selectedGender,
                onChanged: onGenderSelected,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SelectBox<String>(
                title: 'Female',
                value: 'Female',
                groupValue: selectedGender,
                onChanged: onGenderSelected,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: ageController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter your age',
            ),
            keyboardType: TextInputType.number,
            style: const TextStyle(color: AppColors.defaultTextColor),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: heightController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter your height (cm)',
            ),
            keyboardType: TextInputType.number,
            style: const TextStyle(color: AppColors.defaultTextColor),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: weightController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter your weight (kg)',
            ),
            keyboardType: TextInputType.number,
            style: const TextStyle(color: AppColors.defaultTextColor),
          ),
        ),
      ],
    );
  }
}

class StepFour extends StatelessWidget {
  final TextEditingController weightGoalController;
  final double goalPerWeek;
  final ValueChanged<double> onGoalPerWeekSelected;

  const StepFour({super.key, 
    required this.weightGoalController,
    required this.goalPerWeek,
    required this.onGoalPerWeekSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('Step 4: Enter your weight goal and goal per week'),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: weightGoalController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter your weight goal (kg)',
            ),
            keyboardType: TextInputType.number,
            style: const TextStyle(color: AppColors.defaultTextColor),
          ),
        ),
        SelectBox<double>(
          title: '0.2 kg per week',
          value: 0.2,
          groupValue: goalPerWeek,
          onChanged: onGoalPerWeekSelected,
        ),
        SelectBox<double>(
          title: '0.5 kg per week',
          value: 0.5,
          groupValue: goalPerWeek,
          onChanged: onGoalPerWeekSelected,
        ),
      ],
    );
  }
}

class StepFive extends StatelessWidget {
  final String selectedActivityLevel;
  final ValueChanged<String> onActivityLevelSelected;

  const StepFive({super.key, 
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
          title: 'Sedentary (little or no exercise): BMR × 1.2',
          value: 'Sedentary',
          groupValue: selectedActivityLevel,
          onChanged: onActivityLevelSelected,
        ),
        SelectBox<String>(
          title: 'Lightly active (light exercise/sports 1-3 days/week): BMR × 1.375',
          value: 'Lightly active',
          groupValue: selectedActivityLevel,
          onChanged: onActivityLevelSelected,
        ),
        SelectBox<String>(
          title: 'Moderately active (moderate exercise/sports 3-5 days/week): BMR × 1.55',
          value: 'Moderately active',
          groupValue: selectedActivityLevel,
          onChanged: onActivityLevelSelected,
        ),
        SelectBox<String>(
          title: 'Very active (hard exercise/sports 6-7 days a week): BMR × 1.725',
          value: 'Very active',
          groupValue: selectedActivityLevel,
          onChanged: onActivityLevelSelected,
        ),
        SelectBox<String>(
          title: 'Extra active (very hard exercise/sports & physical job or 2x training): BMR × 1.9',
          value: 'Extra active',
          groupValue: selectedActivityLevel,
          onChanged: onActivityLevelSelected,
        ),
      ],
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

  double calculateBMR() {
    double weight = double.parse(this.weight);
    double height = double.parse(this.height);
    int age = int.parse(this.age);
    double bmr;

    if (gender == 'Male') {
      bmr = (10 * weight) + (6.25 * height) - (5 * age) + 5;
    } else {
      bmr = (10 * weight) + (6.25 * height) - (5 * age) - 161;
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

    return bmr * activityFactor;
  }

  void sendUserInfoToApi(BuildContext context) async {
    final apiService = ApiService();
    double bmr = calculateBMR();

    UserInfo userInfo = UserInfo(
      name: name,
      goal: goal,
      gender: gender,
      age: int.parse(age),
      height: double.parse(height),
      weight: double.parse(weight),
      weightGoal: double.parse(weightGoal),
      goalPerWeek: goalPerWeek,
      activityLevel: activityLevel,
      bmr: bmr,
    );

    try {
      await apiService.createUser(userInfo);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double bmr = calculateBMR();
    sendUserInfoToApi(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Summary', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor2,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Name: $name', style: const TextStyle(fontSize: 18)),
                    Text('Gender: $gender', style: const TextStyle(fontSize: 18)),
                    Text('Age: $age', style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor2,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Height: $height cm', style: const TextStyle(fontSize: 18)),
                    Text('Weight: $weight kg', style: const TextStyle(fontSize: 18)),
                    Text('Activity Level: $activityLevel', style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ),
          ],),
          const SizedBox(height: 10),         
            Row(
              children: [
              Expanded(
                child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor2,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                  Text('Goal: $goal', style: const TextStyle(fontSize: 18)),
                  Text('Weight Goal: $weightGoal kg', style: const TextStyle(fontSize: 18)),
                  Text('Goal per Week: ${goalPerWeek.toString()} kg', style: const TextStyle(fontSize: 18)),
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
                  color: AppColors.secondaryColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('BMR: ${bmr.toStringAsFixed(2)} kcal/day', style: const TextStyle(fontSize: 36, color: AppColors.inverseTextColor)),
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