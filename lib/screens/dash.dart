// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:water_quality_monitor/widgets/sensor_card.dart';

// final DatabaseReference databaseRef = FirebaseDatabase.instance.ref("sensorData");

// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({Key? key}) : super(key: key);

//   @override
//   _DashboardScreenState createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   Map<String, dynamic>? sensorData;

//   @override
//   void initState() {
//     super.initState();

//     // Listen for Firebase updates
//     databaseRef.onValue.listen((DatabaseEvent event) {
//       setState(() {
//         sensorData = Map<String, dynamic>.from(event.snapshot.value as Map);
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     String overallHealth = checkOverallHealth(sensorData);

//     return Scaffold(
//       appBar: AppBar(title: const Text("Water Quality Monitor")),
//       body: sensorData == null
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   Text.rich(
//                     TextSpan(
//                       text: "Overall Status: ",
//                       style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
//                       children: [
//                         TextSpan(
//                           text: overallHealth,
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: overallHealth == "Normal" ? Colors.green : Colors.red,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Expanded(
//                     child: ListView(
//                       children: [
//                         SensorCard(
//                           title: "Temperature",
//                           value: sensorData?['temperature'] != null
//                               ? "${sensorData?['temperature']} °C"
//                               : "Loading...",
//                           progressValue: (sensorData?['temperature'] ?? 0) / 100,
//                           progressColor: (sensorData?['temperature'] ?? 0) > 35 ? Colors.red : Colors.green,
//                           icon:const Icon(
//                             Icons.thermostat, // Built-in icon
//                             size: 40.0, // Change size
//                             color: Colors.blue, // Change color
//                             semanticLabel: 'Temperature Icon', // Accessibility label
//                           ),
//                         ),
//                         SensorCard(
//                           title: "pH Level",
//                           value: sensorData?['ph'] != null ? "${sensorData?['ph']}" : "Loading...",
//                           progressValue: (sensorData?['ph'] ?? 0) / 14,
//                           progressColor: (sensorData?['ph'] != null &&
//                                   (sensorData!['ph'] >= 6.5 && sensorData!['ph'] <= 8.5))
//                               ? Colors.green
//                               : Colors.red,
//                           icon:const Icon(
//                             Icons.science, // Built-in icon
//                             size: 40.0, // Change size
//                             color: Colors.blue, // Change color
//                             semanticLabel: 'Temperature Icon', // Accessibility label
//                           ),
//                         ),
//                         SensorCard(
//                           title: "TDS",
//                           value: sensorData?['tds'] != null ? "${sensorData?['tds']} ppm" : "Loading...",
//                           progressValue: (sensorData?['tds'] ?? 0) / 1000,
//                           progressColor: (sensorData?['tds'] ?? 0) > 500 ? Colors.red : Colors.green,
//                           icon:const Icon(
//                             Icons.water_drop, // Built-in icon
//                             size: 40.0, // Change size
//                             color: Colors.blue, // Change color
//                             semanticLabel: 'Temperature Icon', // Accessibility label
//                           ),
//                         ),
//                         SensorCard(
//                           title: "Turbidity",
//                           value: sensorData?['turbidity'] != null ? "${sensorData?['turbidity']}%" : "Loading...",
//                           progressValue: (sensorData?['turbidity'] ?? 0) / 100,
//                           progressColor: (sensorData?['turbidity'] ?? 0) > 50 ? Colors.red : Colors.green,
//                           icon:const Icon(
//                             Icons.bubble_chart, // Built-in icon
//                             size: 40.0, // Change size
//                             color: Colors.blue, // Change color
//                             semanticLabel: 'Temperature Icon', // Accessibility label
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }

//   String checkOverallHealth(Map<String, dynamic>? sensorData) {
//     if (sensorData == null) {
//       return "Unknown";
//     } else if ((sensorData['temperature'] != null && sensorData['temperature'] < 35) &&
//         (sensorData['ph'] != null && (sensorData['ph'] >= 6.5 && sensorData['ph'] <= 8.5)) &&
//         (sensorData['turbidity'] < 50)) {
//       return "Normal";
//     } else {
//       return "Unhealthy";
//     }
//   }
// }
