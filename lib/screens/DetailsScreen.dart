import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart' as gauges;
import 'package:firebase_database/firebase_database.dart';
import 'package:water_quality_monitor/screens/EditSettings.dart';
import 'package:water_quality_monitor/widgets/chart_container.dart';

final DatabaseReference databaseRef =
    FirebaseDatabase.instance.ref("sensorData");

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
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'TEMP Alarm',
                      style: TextStyle(color: Colors.white),
                    ),
                    Divider(
                      color: Colors.white,
                      height: 15,
                      thickness: 0.5,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.device_thermostat,
                          color: Colors.deepOrange,
                        ),
                        Text(
                          'TEMP HIGH alarm value: ',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text('  30°C', style: TextStyle(color: Colors.white))
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.device_thermostat,
                          color: Colors.lightBlueAccent,
                        ),
                        Text(
                          'TEMP LOW alarm value: ',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text('  30°C', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                child: ChartContainer(),
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

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white.withOpacity(0.1),),
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
            minimum: getGaugeSettings(title)["minSpeed"],
            maximum: getGaugeSettings(title)["maxSpeed"],
            onLabelCreated: (gauges.AxisLabelCreatedArgs args) {
              // Show only minimum and maximum labels
              if (args.text !=
                      getGaugeSettings(title)["minSpeed"].toStringAsFixed(0) &&
                  args.text !=
                      getGaugeSettings(title)["maxSpeed"].toStringAsFixed(0)) {
                args.text = ''; // Hide other labels
              }
            },
            axisLabelStyle: const gauges.GaugeTextStyle(
              color: Color.fromARGB(
                  255, 255, 255, 255), // Set the label color to red
              fontSize: 18,
            ),
            axisLineStyle: const gauges.AxisLineStyle(
              thickness: 0.13, // Decrease the thickness of the axis
              thicknessUnit: gauges.GaugeSizeUnit.factor,
              cornerStyle: gauges
                  .CornerStyle.bothCurve, // Use factor for relative thickness
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
                      color: Color.fromARGB(255, 255, 255, 255)),
                ),
                angle: 90,
                positionFactor: 0,
              ),
            ],
          ),
        ],
      ),
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
          "minSpeed": -10.0, // Ensure these are double values
          "maxSpeed": 50.0, // Ensure these are double values
          "unitOfMeasurement": "°C",
        };
      case "Turbidity":
        return {
          "minSpeed": 0.0, // Ensure these are double values
          "maxSpeed": 100.0, // Ensure these are double values
          "unitOfMeasurement": "%",
        };
      case "TDS":
        return {
          "minSpeed": 0.0, // Ensure these are double values
          "maxSpeed": 2000.0, // Ensure these are double values
          "unitOfMeasurement": "ppm",
        };
      case "pH Level":
        return {
          "minSpeed": 0.0, // Ensure these are double values
          "maxSpeed": 14.0, // Ensure these are double values
          "unitOfMeasurement": "pH"
        };
      default:
        return {
          "minSpeed": 0.0, // Ensure these are double values
          "maxSpeed": 100.0, // Ensure these are double values
          "unitOfMeasurement": "",
        };
    }
  }
}
