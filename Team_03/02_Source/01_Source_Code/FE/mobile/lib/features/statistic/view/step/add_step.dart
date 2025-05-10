import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import 'package:provider/provider.dart';

class AddStep extends StatefulWidget {
  const AddStep({super.key});

  @override
  State<AddStep> createState() => _AddStepState();
}

class _AddStepState extends State<AddStep> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _stepsController = TextEditingController();
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    final dashboardViewModel = Provider.of<DashboardViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Step"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/dashboard'); // Navigate back to the previous screen
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check), // Confirm button icon
            onPressed: () {
              if (_formKey.currentState!.validate() && _selectedDate != null) {
                final steps = int.parse(_stepsController.text);
                final formattedDate =
                    DateFormat('yyyy-MM-dd').format(_selectedDate!);

                // Add the step log via the ViewModel
                dashboardViewModel.addStepLog(
                  context: context,
                  steps: steps,
                  date: formattedDate,
                );

                // Navigate back to the dashboard
                context.go('/dashboard');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill in all fields')),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _stepsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Steps",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of steps';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedDate == null
                        ? "Select Date"
                        : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextButton(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _selectedDate = pickedDate;
                        });
                      }
                    },
                    child: const Text("Pick Date"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
