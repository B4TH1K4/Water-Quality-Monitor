import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsPage extends StatefulWidget {
  final String title;
  const SettingsPage({Key? key, required this.title}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController _minValueController = TextEditingController();
  final TextEditingController _maxValueController = TextEditingController();
  final TextEditingController _minAlarmController = TextEditingController();
  final TextEditingController _maxAlarmController = TextEditingController();
  final TextEditingController _alarmValueController = TextEditingController();

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    try {
      DocumentSnapshot snapshot = await _firestore.collection("settings").doc(widget.title.toLowerCase()).get();
      if (snapshot.exists) {
        Map<String, dynamic> settings = snapshot.data() as Map<String, dynamic>;
        setState(() {
          _minValueController.text = settings["min"].toString();
          _maxValueController.text = settings["max"].toString();
          _minAlarmController.text = settings["minAlarm"].toString();
          _maxAlarmController.text = settings["maxAlarm"].toString();
          _alarmValueController.text = settings["alarm"].toString();
        });
      }
    } catch (e) {
      _showErrorDialog("Failed to load settings: $e");
    }
  }

  void _saveSettings() async {
    if (_formKey.currentState!.validate()) {
      double minValue = double.parse(_minValueController.text);
      double maxValue = double.parse(_maxValueController.text);
      double minAlarm = double.parse(_minAlarmController.text);
      double maxAlarm = double.parse(_maxAlarmController.text);
      double alarmValue = double.parse(_alarmValueController.text);

      // Validation: Ensure min < max
      if (minValue >= maxValue) {
        _showErrorDialog("Minimum value must be less than Maximum value.");
        return;
      }

      // Validation: Ensure minAlarm >= minValue and minAlarm <= maxValue
      if (minAlarm < minValue || minAlarm > maxValue) {
        _showErrorDialog("Minimum Alarm value must be between Min and Max values.");
        return;
      }

      // Validation: Ensure maxAlarm >= minValue and maxAlarm <= maxValue
      if (maxAlarm < minValue || maxAlarm > maxValue) {
        _showErrorDialog("Maximum Alarm value must be between Min and Max values.");
        return;
      }

      // Validation: Ensure minAlarm <= maxAlarm
      if (minAlarm > maxAlarm) {
        _showErrorDialog("Minimum Alarm value must be less than or equal to Maximum Alarm value.");
        return;
      }

      // Save settings to Firestore
      try {
        // Create a map of the settings
        Map<String, dynamic> settingsData = {
          "min": minValue,
          "max": maxValue,
          "minAlarm": minAlarm,
          "maxAlarm": maxAlarm,
          "alarm": alarmValue,
          "title": widget.title,
        };

        await _firestore.collection("settings").doc(widget.title.toLowerCase()).set(settingsData);

        _showSuccessDialog("Settings saved successfully!");
      } catch (e) {
        _showErrorDialog("Failed to save settings: $e");
      }
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
  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Success"),
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
      backgroundColor: const Color.fromRGBO(24, 29, 51, 1),
      appBar: AppBar(
        title: Text("Settings for ${widget.title}"),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromRGBO(36, 42, 64, 1),
      ),
      body: SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField("Minimum Value", _minValueController),
              const SizedBox(height: 15),
              _buildTextField("Maximum Value", _maxValueController),
              const SizedBox(height: 15),
              _buildTextField("Minimum Alarm Value", _minAlarmController),
              const SizedBox(height: 15),
              _buildTextField("Maximum Alarm Value", _maxAlarmController),
              const SizedBox(height: 15),
              _buildTextField("Alarming Value", _alarmValueController),
              const SizedBox(height: 25),
              // Save Button
              Center(
                child: ElevatedButton(
                  onPressed: _saveSettings,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 48, 67, 102),
                    foregroundColor: Colors.white,
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
      ),
      
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(5.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(5.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(5.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter a value";
        }
        if (double.tryParse(value) == null) {
          return "Enter a valid number";
        }
        return null;
      },
    );
  }
}