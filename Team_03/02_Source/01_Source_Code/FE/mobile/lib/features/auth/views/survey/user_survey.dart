import 'package:flutter/material.dart';
import 'package:mobile/common/widgets/tonal_button/tonal_button.dart';
import 'package:go_router/go_router.dart';
import 'step_one.dart';
import 'step_two.dart';
import 'step_three.dart';
import 'step_four.dart';
import 'step_five.dart';
import 'package:mobile/features/auth/viewmodels/survey_viewmodel.dart';
import 'package:mobile/features/auth/viewmodels/auth_viewmodel.dart';

class UserSurvey extends StatefulWidget {
  final String email;
  final String password;

  const UserSurvey({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  // ignore: library_private_types_in_public_api
  _UserSurveyState createState() => _UserSurveyState();
}

class _UserSurveyState extends State<UserSurvey> {
  int _currentStep = 0;
  final SurveyViewModel surveyViewModel = SurveyViewModel();
  final AuthViewModel authViewModel = AuthViewModel();

  final GlobalKey<FormState> _stepOneKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _stepTwoKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _stepThreeKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _stepFourKey = GlobalKey<FormState>();

  void _previousStep() {
    setState(() {
      if (_currentStep > 0) {
        _currentStep--;
      }
      if (_currentStep == 0) {
        authViewModel.logout();
        context.go('/welcome');
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
        if (!(_stepTwoKey.currentState?.validate() ?? false)) {
          return;
        }
      }
      if (_currentStep == 2) {
        if (!(_stepThreeKey.currentState?.validate() ?? false)) {
          return;
        }
      }
      if (_currentStep == 3) {
        if (!(_stepFourKey.currentState?.validate() ?? false)) {
          return;
        }
      }

      if (_currentStep < 5) {
        _currentStep++;
      } else {
        // Submit survey data and handle success or failure
        surveyViewModel.sendSurveyData().then((success) {
          if (success) {
            context.go('/dashboard'); // Navigate to dashboard on success
          } else {
            // Show error message if submission fails
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text("Failed to submit survey. Please try again.")),
            );
          }
        }).catchError((error) {
          // Handle unexpected errors
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error submitting survey: $error")),
          );
        });
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
          children: [
            LinearProgressIndicator(
              value: (_currentStep + 1) / 6,
              color: Colors.green,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _currentStep == 0
                  ? StepOne(
                      nameController:
                          TextEditingController(text: surveyViewModel.name),
                      formKey: _stepOneKey,
                      onNameChanged: (value) {
                        surveyViewModel.name = value;
                      },
                    )
                  : _currentStep == 1
                      ? StepTwo(
                          formKey: _stepTwoKey,
                          selectedGoal: surveyViewModel.goal,
                          onGoalSelected: (goal) {
                            setState(() {
                              surveyViewModel.goal = goal;
                            });
                          },
                        )
                      : _currentStep == 2
                          ? StepThree(
                              formKey: _stepThreeKey,
                              selectedGender: surveyViewModel.gender,
                              onGenderSelected: (gender) {
                                setState(() {
                                  surveyViewModel.gender = gender;
                                });
                              },
                              ageController: TextEditingController(
                                  text: surveyViewModel.age.toString()),
                              heightController: TextEditingController(
                                  text: surveyViewModel.height.toString()),
                              weightController: TextEditingController(
                                  text: surveyViewModel.weight.toString()),
                              onAgeChanged: (value) {
                                surveyViewModel.age = int.tryParse(value) ?? 0;
                              },
                              onHeightChanged: (value) {
                                surveyViewModel.height =
                                    double.tryParse(value) ?? 0.0;
                              },
                              onWeightChanged: (value) {
                                surveyViewModel.weight =
                                    double.tryParse(value) ?? 0.0;
                              },
                            )
                          : _currentStep == 3
                              ? StepFour(
                                  formKey: _stepFourKey,
                                  weightGoalController: TextEditingController(
                                      text: surveyViewModel.weightGoal
                                          .toString()),
                                  weightController: TextEditingController(
                                      text: surveyViewModel.weight.toString()),
                                  goal: surveyViewModel.goal,
                                  goalPerWeek: surveyViewModel.goalPerWeek,
                                  onGoalPerWeekSelected: (goal) {
                                    setState(() {
                                      surveyViewModel.goalPerWeek = goal;
                                    });
                                  },
                                  onWeightGoalChanged: (value) {
                                    surveyViewModel.weightGoal =
                                        double.tryParse(value) ?? 0.0;
                                  },
                                )
                              : _currentStep == 4
                                  ? StepFive(
                                      selectedActivityLevel:
                                          surveyViewModel.activityLevel,
                                      onActivityLevelSelected: (activityLevel) {
                                        setState(() {
                                          surveyViewModel.activityLevel =
                                              activityLevel;
                                        });
                                      },
                                    )
                                  : Summary(
                                      surveyViewModel: surveyViewModel,
                                    ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TonalButton(
                  onPressed: _previousStep,
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
  final SurveyViewModel surveyViewModel;

  const Summary({
    super.key,
    required this.surveyViewModel,
  });

  @override
  Widget build(BuildContext context) {
    // Use calculateCalorieGoal() from the viewmodel
    double calorieGoal = surveyViewModel.calculateCalorieGoal();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          Text(
            'Congratulations! You have completed the survey',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'Your daily net calorie goal (kcal) is:',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 50),
          Text(
            calorieGoal.toStringAsFixed(2),
            style: Theme.of(context).textTheme.displayLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 50),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Details information:',
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: TextAlign.left,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Card(
                  elevation: Theme.of(context).cardTheme.elevation,
                  shape: Theme.of(context).cardTheme.shape,
                  color: Theme.of(context).cardTheme.color,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name: ${surveyViewModel.name}',
                            style: Theme.of(context).textTheme.bodyMedium),
                        Text('Gender: ${surveyViewModel.gender}',
                            style: Theme.of(context).textTheme.bodyMedium),
                        Text('Age: ${surveyViewModel.age}',
                            style: Theme.of(context).textTheme.bodyMedium),
                        Text('Height: ${surveyViewModel.height} cm',
                            style: Theme.of(context).textTheme.bodyMedium),
                        Text('Weight: ${surveyViewModel.weight} kg',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Card(
                  elevation: Theme.of(context).cardTheme.elevation,
                  shape: Theme.of(context).cardTheme.shape,
                  color: Theme.of(context).cardTheme.color,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(surveyViewModel.activityLevel,
                            style: Theme.of(context).textTheme.bodyMedium),
                        Text('Goal: ${surveyViewModel.goal}',
                            style: Theme.of(context).textTheme.bodyMedium),
                        Text('Weight Goal: ${surveyViewModel.weightGoal} kg',
                            style: Theme.of(context).textTheme.bodyMedium),
                        Text(
                            'Goal per Week: ${surveyViewModel.goalPerWeek.toString()} kg',
                            style: Theme.of(context).textTheme.bodyMedium),
                        const Text(' '),
                      ],
                    ),
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
