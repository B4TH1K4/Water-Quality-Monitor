// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_gauges/gauges.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:water_quality_monitor/screens/dashboard.dart';

// final DatabaseReference databaseRef = FirebaseDatabase.instance.ref("sensorData");

// class DetailsScreen extends StatefulWidget {
//   final String title;

//   const DetailsScreen({Key? key, required this.title}) : super(key: key);

//   @override
//   _DetailsScreenState createState() => _DetailsScreenState();
// }

// class _DetailsScreenState extends State<DetailsScreen> {
//   Map<String, dynamic>? sensorData;

//   @override
//   void initState() {
//     super.initState();

//     // Listen to the database in real-time
//     databaseRef.onValue.listen((DatabaseEvent event) {
//       setState(() {
//         sensorData = Map<String, dynamic>.from(event.snapshot.value as Map);
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.title)),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children:[sensorData == null
//             ? CircularProgressIndicator() // Show loading indicator while data is being fetched
//             : buildGaugeView(widget.title),]
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed:()=>{Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) =>const DashboardScreen(
//             ),
//           ),
//         ),} ,
//         tooltip: 'Home',
//         child: const Icon(Icons.home, 
//                             size: 40.0, // Change size
//                             color: Colors.blue, // Change color
//                             semanticLabel: 'Temperature Icon', // Accessibility label),
//         ),
//       ),
//     );
//   }

//   Widget buildGaugeView(String title) {
//     String requiredValue = valueSelector(title);
//     double value = _extractNumericValue(requiredValue);

//     return Container(
//       width: 400,
//       height: 350,
//       padding: EdgeInsets.all(10),
//       child: SfRadialGauge(
//         axes: <RadialAxis>[
//           RadialAxis(
//             minimum: getGaugeSettings(title)["minSpeed"],
//             maximum: getGaugeSettings(title)["maxSpeed"],
//             ranges: <GaugeRange>[
//               GaugeRange(
//                 startValue: getGaugeSettings(title)["minSpeed"],
//                 endValue: getGaugeSettings(title)["maxSpeed"],
//                 color: Colors.grey[300]!,
//                 startWidth: 20,
//                 endWidth: 20,
//               ),
//             ],
//             pointers: <GaugePointer>[
//               NeedlePointer(
//                 value: value,
//                 needleColor: Colors.black,
//                 knobStyle: KnobStyle(color: Colors.black),
//                 needleLength: 0.75,
//               ),
//             ],
//             annotations: <GaugeAnnotation>[
//               GaugeAnnotation(
//                 widget: Text(
//                   '${value.toStringAsFixed(1)} ${getGaugeSettings(title)["unitOfMeasurement"]}',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 angle: 90,
//                 positionFactor: 0.5,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   double _extractNumericValue(String value) {
//     if (value.isEmpty) return 0.0; // Handle empty or invalid value
//     try {
//       return double.tryParse(value) ?? 0.0; // Safe conversion
//     } catch (e) {
//       print('Error parsing value: $e');
//       return 0.0;
//     }
//   }

//   String valueSelector(String title) {
//     switch (title) {
//       case "Temperature":
//         return sensorData?['temperature']?.toString() ?? "0";
//       case "Turbidity":
//         return sensorData?['turbidity']?.toString() ?? "0";
//       case "TDS":
//         return sensorData?['tds']?.toString() ?? "0";
//       case "pH Level":
//         return sensorData?['ph']?.toString() ?? "0";
//       default:
//         return "0";
//     }
//   }

//   Map<String, dynamic> getGaugeSettings(String title) {
//   switch (title) {
//     case "Temperature":
//       return {
//         "minSpeed": -10.0, // Ensure these are double values
//         "maxSpeed": 50.0, // Ensure these are double values
//         "unitOfMeasurement": "°C",
//       };
//     case "Turbidity":
//       return {
//         "minSpeed": 0.0, // Ensure these are double values
//         "maxSpeed": 100.0, // Ensure these are double values
//         "unitOfMeasurement": "%",
//       };
//     case "TDS":
//       return {
//         "minSpeed": 0.0, // Ensure these are double values
//         "maxSpeed": 2000.0, // Ensure these are double values
//         "unitOfMeasurement": "ppm",
//       };
//     case "pH Level":
//       return {
//         "minSpeed": 0.0, // Ensure these are double values
//         "maxSpeed": 14.0, // Ensure these are double values
//         "unitOfMeasurement": "pH",
//       };
//     default:
//       return {
//         "minSpeed": 0.0, // Ensure these are double values
//         "maxSpeed": 100.0, // Ensure these are double values
//         "unitOfMeasurement": "",
//       };
//   }
// }

// }
