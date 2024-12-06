import 'package:flutter/material.dart';
import 'package:habit_tracker/add_habit_page.dart/local/models.dart';
import 'package:habit_tracker/helper_classes/db_helper.dart';

class AddhabitPage extends StatefulWidget {
  const AddhabitPage({super.key});

  @override
  State<AddhabitPage> createState() => _AddhabitPageState();
}

class _AddhabitPageState extends State<AddhabitPage> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController _habitNameController = TextEditingController();
  final TextEditingController _habitDescriptionController = TextEditingController();

  // Currently selected frequency
  String _selectedFrequency = 'daily'; // Changed to String to match database

  @override
  void dispose() {
    // Clean up controllers
    _habitNameController.dispose();
    _habitDescriptionController.dispose();
    super.dispose();
  }

  void _saveHabit() async {
    // Validate the form
    if (_formKey.currentState!.validate()) {
      // Create a new Habit object
      final habit = Habit(
        name: _habitNameController.text,
        description: _habitDescriptionController.text.isEmpty 
            ? null 
            : _habitDescriptionController.text,
        frequency: _selectedFrequency,
        isDone: 0
      );

      // Insert habit into database
      try {
        final id = await DatabaseHelper.instance.insertHabit(habit);
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Habit added successfully with ID: $id')),
        );

        // Clear form or navigate back
        Navigator.of(context).pop();
      } catch (e) {
        // Show error message if insertion fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add habit: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Habit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Habit Name Field
              TextFormField(
                controller: _habitNameController,
                decoration: InputDecoration(
                  labelText: 'Habit Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a habit name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Habit Description Field
              TextFormField(
                controller: _habitDescriptionController,
                decoration: InputDecoration(
                  labelText: 'Habit Description (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16),

              // Frequency Dropdown
              DropdownButtonFormField<String>(
                value: _selectedFrequency,
                decoration: InputDecoration(
                  labelText: 'Frequency',
                  border: OutlineInputBorder(),
                ),
                items: [
                  'daily',
                  'weekly',
                  'monthly',
                  'custom'
                ].map((frequency) => DropdownMenuItem(
                      value: frequency,
                      child: Text(frequency.toUpperCase()),
                    )).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedFrequency = value!;
                  });
                },
              ),
              SizedBox(height: 24),

              // Save Button
              ElevatedButton(
                onPressed: _saveHabit,
                child: Text('Save Habit'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}