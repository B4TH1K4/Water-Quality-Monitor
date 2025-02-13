import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart' as gauges;
import 'package:firebase_database/firebase_database.dart';
import 'package:water_quality_monitor/screens/EditSettings.dart';
import 'package:water_quality_monitor/widgets/chart_container.dart';
import 'package:water_quality_monitor/screens/EditSettings.dart';

final DatabaseReference databaseRef =
    FirebaseDatabase.instance.ref("sensorData");
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class DetailsScreen extends StatefulWidget {
  final String title;

  const DetailsScreen({Key? key, required this.title}) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  Map<String, dynamic>? sensorData;

  @override
  void initState() {
    super.initState();

    // Listen to the database in real-time
    databaseRef.onValue.listen((DatabaseEvent event) {
      setState(() {
        sensorData = Map<String, dynamic>.from(event.snapshot.value as Map);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(24, 29, 51, 1),
      appBar: AppBar(
        title: Text(widget.title),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromRGBO(36, 42, 64, 1),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              sensorData == null
                  ? const CircularProgressIndicator() // Show loading indicator while data is being fetched
                  : Row(
                    
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        
                        Expanded(
                          child: buildGaugeView(widget.title),
                        ),
                      ],
                    ),
              Container(
                
                margin:
                    const EdgeInsets.only(top: 10, right: 20, bottom: 10, left: 20),
                padding:
                    const EdgeInsets.only(top: 20, right: 10, bottom: 20, left: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: FutureBuilder<double>(
                  future: loadSetting("maxAlarm"), // Fetch max alarm value
                  builder: (context, maxSnapshot) {
                    return FutureBuilder<double>(
                      future: loadSetting("minAlarm"), // Fetch min alarm value
                      builder: (context, minSnapshot) {
                        if (maxSnapshot.connectionState == ConnectionState.waiting ||
                            minSnapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator(); // Show a loader while fetching data
                        }

                        if (maxSnapshot.hasError || minSnapshot.hasError) {
                          return const Text(
                            "Error loading values",
                            style: TextStyle(color: Colors.red),
                          );
                        }

                        double maxAlarmValue = maxSnapshot.data ?? 0.0;
                        double minAlarmValue = minSnapshot.data ?? 0.0;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'TEMP Alarm',
                              style: TextStyle(color: Colors.white),
                            ),
                            const Divider(
                              color: Colors.white,
                              height: 15,
                              thickness: 0.5,
                            ),
                            Row(
                              children: <Widget>[
                                const Icon(
                                  Icons.device_thermostat,
                                  color: Colors.deepOrange,
                                ),
                                Text(
                                  '${widget.title} HIGH alarm value: ',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  '  ${maxAlarmValue.toStringAsFixed(1)} ${getGaugeSettings(widget.title)["unitOfMeasurement"]}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                const Icon(
                                  Icons.device_thermostat,
                                  color: Colors.lightBlueAccent,
                                ),
                                Text(
                                  '${widget.title} LOW alarm value: ',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  '  ${minAlarmValue.toStringAsFixed(1)} ${getGaugeSettings(widget.title)["unitOfMeasurement"]}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                )

              ),
              Container(
                child: const ChartContainer(),
              ),
            ]),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 48, 67, 102),
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SettingsPage(title: widget.title), 
            ),
          ),
        },
        tooltip: 'Home',
        child: const Icon(
          Icons.edit,
          size: 35.0, // Change size
          color: Color.fromARGB(255, 255, 255, 255), // Change color
          semanticLabel: 'Temperature Icon', // Accessibility label),
        ),
      ),
    );
  }

  Widget buildGaugeView(String title) {
  String requiredValue = valueSelector(title);
  double value = _extractNumericValue(requiredValue);

  return FutureBuilder<double>(
    future: loadSetting("max"), // Fetch max alarm value
    builder: (context, maxSnapshot) {
      return FutureBuilder<double>(
        future: loadSetting("min"), // Fetch min alarm value
        builder: (context, minSnapshot) {
          if (maxSnapshot.connectionState == ConnectionState.waiting ||
              minSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Show loader while fetching data
          }

          if (maxSnapshot.hasError || minSnapshot.hasError) {
            return const Center(
              child: Text(
                "Error loading values",
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          double max = maxSnapshot.data ?? 0.0;
          double min = minSnapshot.data ?? 0.0;

          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white.withOpacity(0.1),
            ),
            width: 300,
            height: 250,
            margin: const EdgeInsets.only(top: 20, left: 20, bottom: 10, right: 20),
            padding: const EdgeInsets.all(10),
            child: gauges.SfRadialGauge(
              axes: <gauges.RadialAxis>[
                gauges.RadialAxis(
                  showTicks: false,
                  showLastLabel: true,
                  labelsPosition: gauges.ElementsPosition.outside,
                  minimum: min,
                  maximum: max,
                  onLabelCreated: (gauges.AxisLabelCreatedArgs args) {
                    // Show only minimum and maximum labels
                    if (args.text !=
                            min.toStringAsFixed(0) &&
                        args.text !=
                            max.toStringAsFixed(0)) {
                      args.text = ''; // Hide other labels
                    }
                  },
                  axisLabelStyle: const gauges.GaugeTextStyle(
                    color: Colors.white, // Set label color
                    fontSize: 18,
                  ),
                  axisLineStyle: const gauges.AxisLineStyle(
                    thickness: 0.13, // Decrease thickness
                    thicknessUnit: gauges.GaugeSizeUnit.factor,
                    cornerStyle: gauges.CornerStyle.bothCurve,
                  ),
                  pointers: <gauges.GaugePointer>[
                    gauges.RangePointer(
                      enableAnimation: true,
                      value: value,
                      width: 0.13,
                      sizeUnit: gauges.GaugeSizeUnit.factor,
                      gradient: const SweepGradient(
                        colors: <Color>[
                          Color.fromARGB(255, 168, 207, 39),
                          Color.fromARGB(255, 218, 29, 29)
                        ],
                        stops: <double>[0.25, 0.75],
                      ),
                      cornerStyle: gauges.CornerStyle.bothCurve,
                    )
                  ],
                  annotations: <gauges.GaugeAnnotation>[
                    gauges.GaugeAnnotation(
                      widget: Text(
                        '${value.toStringAsFixed(1)} ${getGaugeSettings(title)["unitOfMeasurement"]}',
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      angle: 90,
                      positionFactor: 0,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}


  double _extractNumericValue(String value) {
    if (value.isEmpty) return 0.0; // Handle empty or invalid value
    try {
      return double.tryParse(value) ?? 0.0; // Safe conversion
    } catch (e) {
      print('Error parsing value: $e');
      return 0.0;
    }
  }

  String valueSelector(String title) {
    switch (title) {
      case "Temperature":
        return sensorData?['temperature']?.toString() ?? "0";
      case "Turbidity":
        return sensorData?['turbidity']?.toString() ?? "0";
      case "TDS":
        return sensorData?['tds']?.toString() ?? "0";
      case "pH Level":
        return sensorData?['ph']?.toString() ?? "0";
      default:
        return "0";
    }
  }

  Map<String, dynamic> getGaugeSettings(String title) {
    switch (title) {
      case "Temperature":
        return {
          // "minSpeed": -10.0, // Ensure these are double values
          // "maxSpeed": 50.0, // Ensure these are double values
          "unitOfMeasurement": "°C",
        };
      case "Turbidity":
        return {
          // "minSpeed": 0.0, // Ensure these are double values
          // "maxSpeed": 100.0, // Ensure these are double values
          "unitOfMeasurement": "%",
        };
      case "TDS":
        return {
          // "minSpeed": 0.0, // Ensure these are double values
          // "maxSpeed": 2000.0, // Ensure these are double values
          "unitOfMeasurement": "ppm",
        };
      case "pH Level":
        return {
          // "minSpeed": 0.0, // Ensure these are double values
          // "maxSpeed": 14.0, // Ensure these are double values
          "unitOfMeasurement": "pH"
        };
      default:
        return {
          // "minSpeed": 0.0, // Ensure these are double values
          // "maxSpeed": 100.0, // Ensure these are double values
          "unitOfMeasurement": "",
        };
    }
  }

 Future<double> loadSetting(String key) async {
  try {
    DocumentSnapshot snapshot = await _firestore
        .collection("settings")
        .doc(widget.title.toLowerCase())
        .get();

    if (snapshot.exists) {
      Map<String, dynamic> settings = snapshot.data() as Map<String, dynamic>;
      return (settings[key] ?? 0.0).toDouble(); // Ensure a double value is returned
    }
  } catch (e) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text("Failed to load settings: $e"),
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
  return 0.0; // Default value in case of failure
}

}
