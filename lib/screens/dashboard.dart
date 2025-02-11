// import 'package:flutter/material.dart';
// import 'package:water_quality_monitor/widgets/sensor_card.dart';
// import 'package:firebase_database/firebase_database.dart';

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

//     // Listen to Firebase updates
//     databaseRef.onValue.listen((DatabaseEvent event) {
//       setState(() {
//         sensorData = Map<String, dynamic>.from(event.snapshot.value as Map);
//       });
//     });
//   }


//  @override
// Widget build(BuildContext context) {
//   String overallHealth = checkOverallHealth(sensorData);
//   return Scaffold(
//     backgroundColor: const Color.fromARGB(255, 4, 32, 70),
//     appBar: AppBar(title: const Text("Water Quality Monitor"),backgroundColor: const Color.fromARGB(255, 48, 67, 102)),
//     body: sensorData == null
//         ? const Center(child: CircularProgressIndicator())
//         : Padding(
//             padding: const EdgeInsets.all(16.0),
//             child:Column(
//                children:[
//                 Text.rich(
//                   TextSpan(
//                     text: "Overall Status: ",
//                     style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 255, 255)),
//                     children: [
//                       TextSpan(
//                         text: overallHealth,
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: overallHealth == "Normal" ? Colors.green : Colors.red,
//                         )
//                       ),
//                     ]
//                   )
//                 ),
//                 const SizedBox(height: 16),
//                 Expanded(
//                   child:GridView.count(
//                     crossAxisCount: 2, // Number of columns
//                     crossAxisSpacing: 8.0, // Space between columns
//                     mainAxisSpacing: 8.0, // Space between rows
//                     childAspectRatio: 3/2,
                    
//                     children: [
//                       SensorCard(
//                   title: "Temperature",
//                   value: sensorData?['temperature'] != null
//                       ? "${sensorData?['temperature']} °C"
//                       : "Loading...",
//                   status: sensorData?['temperature'] != null &&
//                           sensorData!['temperature'] > 35
//                       ? "High"
//                       : "Safe",
//                   // icon:const Icon(
//                   //           Icons.thermostat, // Built-in icon
//                   //           size: 40.0, // Change size
//                   //           color: Colors.blue, // Change color
//                   //           semanticLabel: 'Temperature Icon', // Accessibility label
//                   //         ),
//                 ),
//                 SensorCard(
//                   title: "pH Level",
//                   value: sensorData?['ph'] != null
//                       ? "${sensorData?['ph']}"
//                       : "Loading...",
//                   status: sensorData?['ph'] != null &&
//                           (sensorData!['ph'] < 6.5 || sensorData!['ph'] > 8.5)
//                       ? "Unsafe"
//                       : "Safe",
//                       // icon:const Icon(
//                       //       Icons.thermostat, // Built-in icon
//                       //       size: 40.0, // Change size
//                       //       color: Colors.blue, // Change color
//                       //       semanticLabel: 'Temperature Icon', // Accessibility label
//                       //     ),
//                 ),
//                 SensorCard(
//                   title: "TDS",
//                   value: sensorData?['tds'] != null
//                       ? "${sensorData?['tds']} ppm"
//                       : "Loading...",
//                   status: "N/A",
//                   // icon:const Icon(
//                   //           Icons.thermostat, // Built-in icon
//                   //           size: 40.0, // Change size
//                   //           color: Colors.blue, // Change color
//                   //           semanticLabel: 'Temperature Icon', // Accessibility label
//                   //         ),
//                 ),
//                 SensorCard(
//                   title: "Turbidity",
//                   value: sensorData?['turbidity'] != null
//                       ? "${sensorData?['turbidity']}%"
//                       : "Loading...",
//                   status: sensorData?['turbidity'] > 50 ? "High" : "Normal",
//                   // icon:const Icon(
//                   //           Icons.thermostat, // Built-in icon
//                   //           size: 40.0, // Change size
//                   //           color: Colors.blue, // Change color
//                   //           semanticLabel: 'Temperature Icon', // Accessibility label
//                   //         ),
//                 ),
//                     ],
//                   ),
//                 )
                
//             ]
//             )
//                 ),
//             );
          
// }

// String checkOverallHealth(Map<String, dynamic>? sensorData){
//   if (sensorData==null){
//     return "unknown";
//   }else if((sensorData['temperature'] != null && sensorData['temperature'] < 35)&&
//             (sensorData['ph'] != null && (sensorData['ph'] >= 6.5 && sensorData['ph'] <= 8.5))&&
//             (sensorData['turbidity'] < 50)){
//     return "Normal";
//   }else {
//     return "Unhealthy";
//   }
// }
// }

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:water_quality_monitor/widgets/sensor_card.dart';

final DatabaseReference databaseRef = FirebaseDatabase.instance.ref("sensorData");

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic>? sensorData;

  @override
  void initState() {
    super.initState();

    // Listen for Firebase updates
    databaseRef.onValue.listen((DatabaseEvent event) {
      setState(() {
        sensorData = Map<String, dynamic>.from(event.snapshot.value as Map);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String overallHealth = checkOverallHealth(sensorData);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 4, 32, 70),
      appBar: AppBar(title: const Text("Water Quality Monitor"),foregroundColor: Colors.white, backgroundColor: const Color.fromARGB(255, 48, 67, 102)),
      body: sensorData == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text.rich(
                    TextSpan(
                      text: "Overall Status: ",
                      style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 255, 255, 255)),
                      children: [
                        TextSpan(
                          text: overallHealth,
                          style: TextStyle(
                            fontSize: 18,
                            
                            color: overallHealth == "Healthy" ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children: [
                        SensorCard(
                          title: "Temperature",
                          value: sensorData?['temperature'] != null
                              ? "${sensorData?['temperature']} °C"
                              : "Loading...",
                          progressValue: (sensorData?['temperature'] ?? 0) / 100,
                          progressColor: (sensorData?['temperature'] ?? 0) > 35 ? Colors.red : Colors.green,
                          icon:const Icon(
                            Icons.thermostat, // Built-in icon
                            size: 40.0, // Change size
                            color: Color.fromARGB(255, 255, 255, 255), // Change color
                            semanticLabel: 'Temperature Icon', // Accessibility label
                          ),
                        ),
                        SensorCard(
                          title: "pH Level",
                          value: sensorData?['ph'] != null ? "${sensorData?['ph']}" : "Loading...",
                          progressValue: (sensorData?['ph'] ?? 0) / 14,
                          progressColor: (sensorData?['ph'] != null &&
                                  (sensorData!['ph'] >= 6.5 && sensorData!['ph'] <= 8.5))
                              ? Colors.green
                              : Colors.red,
                          icon:const Icon(
                            Icons.science, // Built-in icon
                            size: 40.0, // Change size
                            color: Color.fromARGB(255, 255, 255, 255), // Change color
                            semanticLabel: 'Temperature Icon', // Accessibility label
                          ),
                        ),
                        SensorCard(
                          title: "TDS",
                          value: sensorData?['tds'] != null ? "${sensorData?['tds']} ppm" : "Loading...",
                          progressValue: (sensorData?['tds'] ?? 0) / 1000,
                          progressColor: (sensorData?['tds'] ?? 0) > 500 ? Colors.red : Colors.green,
                          icon:const Icon(
                            Icons.water_drop, // Built-in icon
                            size: 40.0, // Change size
                            color: Color.fromARGB(255, 255, 255, 255), // Change color
                            semanticLabel: 'Temperature Icon', // Accessibility label
                          ),
                        ),
                        SensorCard(
                          title: "Turbidity",
                          value: sensorData?['turbidity'] != null ? "${sensorData?['turbidity']}%" : "Loading...",
                          progressValue: (sensorData?['turbidity'] ?? 0) / 100,
                          progressColor: (sensorData?['turbidity'] ?? 0) > 50 ? Colors.red : Colors.green,
                          icon:const Icon(
                            Icons.bubble_chart, // Built-in icon
                            size: 40.0, // Change size
                            color: Color.fromARGB(255, 255, 255, 255), // Change color
                            semanticLabel: 'Temperature Icon', // Accessibility label
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  String checkOverallHealth(Map<String, dynamic>? sensorData) {
    if (sensorData == null) {
      return "Unknown";
    } else if ((sensorData['temperature'] != null && sensorData['temperature'] < 35) &&
        (sensorData['ph'] != null && (sensorData['ph'] >= 6.5 && sensorData['ph'] <= 8.5)) &&
        (sensorData['turbidity'] < 50)) {
      return "Healthy";
    } else {
      return "Unhealthy";
    }
  }
}
