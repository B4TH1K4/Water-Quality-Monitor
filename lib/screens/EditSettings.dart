import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController _minValueController = TextEditingController();
  final TextEditingController _maxValueController = TextEditingController();
  final TextEditingController _alarmValueController = TextEditingController();

  void _saveSettings() {
    if (_formKey.currentState!.validate()) {
      double minValue = double.parse(_minValueController.text);
      double maxValue = double.parse(_maxValueController.text);
      double alarmValue = double.parse(_alarmValueController.text);

      // Validation: Ensure min < max and alarm is within range
      if (minValue >= maxValue) {
        _showErrorDialog("Minimum value must be less than Maximum value.");
        return;
      }

      if (alarmValue < minValue || alarmValue > maxValue) {
        _showErrorDialog("Alarming value must be between Min and Max values.");
        return;
      }

      // Save settings logic (Example: Print to console, store in database, etc.)
      print("Settings Saved: Min=$minValue, Max=$maxValue, Alarm=$alarmValue");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Settings saved successfully!")),
      );
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Min Value Input
              TextFormField(
                controller: _minValueController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Minimum Value",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a minimum value";
                  }
                  if (double.tryParse(value) == null) {
                    return "Enter a valid number";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Max Value Input
              TextFormField(
                controller: _maxValueController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Maximum Value",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a maximum value";
                  }
                  if (double.tryParse(value) == null) {
                    return "Enter a valid number";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Alarm Value Input
              TextFormField(
                controller: _alarmValueController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Alarming Value",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter an alarming value";
                  }
                  if (double.tryParse(value) == null) {
                    return "Enter a valid number";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25),

              // Save Button
              Center(
                child: ElevatedButton(
                  onPressed: _saveSettings,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text("Save Settings"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
