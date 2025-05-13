import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/dashboard_viewmodel.dart';

class AddWeight extends StatefulWidget {
  const AddWeight({super.key});

  @override
  State<AddWeight> createState() => _AddWeightState();
}

class _AddWeightState extends State<AddWeight> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _weightController = TextEditingController();
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    final dashboardViewModel = Provider.of<DashboardViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Weight"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/dashboard'); // Navigate back to the previous screen
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check), // Confirm button icon
            onPressed: () async {
              if (_formKey.currentState!.validate() && _selectedDate != null) {
                // Validate that the selected date is not in the future
                if (_selectedDate!.isAfter(DateTime.now())) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Date cannot be in the future')),
                  );
                  return;
                }

                final weight = double.parse(_weightController.text);
                final formattedDate =
                    DateFormat('yyyy-MM-dd').format(_selectedDate!);

                // Add the weight log via the ViewModel
                await dashboardViewModel.addWeightLog(
                  context: context,
                  weight: weight,
                  date: formattedDate,
                  progressPhoto: "example.jpg", // Static photo for now
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
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Weight (kg)",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your weight';
                  }
                  final weight = double.tryParse(value);
                  if (weight == null) {
                    return 'Please enter a valid number';
                  }
                  if (weight > 200) {
                    return 'Weight cannot exceed 200 kg';
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
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  TextButton(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate:
                            DateTime.now(), // Prevent selecting future dates
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
