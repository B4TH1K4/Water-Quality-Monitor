// import 'package:flutter/material.dart';
// import 'package:water_quality_monitor/screens/DetailsScreen.dart';

// class SensorCard extends StatelessWidget {
//   final String title;
//   final String value;
//   final String status;
//   // final Icon icon;

//   const SensorCard({super.key, 
//     required this.title,
//     required this.value,
//     required this.status,
//     // required this.icon,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         // Navigate to a new screen
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => DetailsScreen(
//               title: title,
//             ),
//           ),
//         );
//       },
//       child: Container(
//         child: Card(
//           color: const Color.fromARGB(255, 48, 67, 102),
//           elevation: 4,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(16.0,0.0,0.0,0.0),
//             child: Row(
//               children: [
//                 // icon,
//               Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
                
//                 Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 255, 255))),
                
//                 Text("Value: $value", style: const TextStyle(fontSize: 16, color: Color.fromARGB(255, 255, 255, 255))),
//                 Text(
//                   "Status: $status",
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: status == "Safe" ? Colors.green : Colors.red,
//                   ),
//                 ),
//               ],
//             ),
//             ],
             
//             )
            
//           ),
//         ),
//       ),
//     );
//   }
    
// }
