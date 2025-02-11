

import 'package:flutter/material.dart';
import 'package:water_quality_monitor/screens/DetailsScreen.dart';

class SensorCard extends StatelessWidget {
  final String title;
  final String value;
  final double progressValue; // For the progress bar (0.0 to 1.0)
  final Icon icon;
  final Color progressColor; // Dynamic color for the progress bar

  const SensorCard({
    Key? key,
    required this.title,
    required this.value,
    required this.progressValue,
    required this.icon,
    required this.progressColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to a new screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsScreen(
              title: title,
            ),
          ),
        );
      }, 
    child:Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color.fromARGB(255, 48, 67, 102), // Dark theme background
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                    TextSpan(
                      text: "$title: ",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 255, 255),),
                      children: [
                        TextSpan(
                          text: value,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ],
                    ),
                  ),
                icon,
              ],
            ),
            const SizedBox(height: 8),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progressValue.clamp(0.0, 1.0),
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              minHeight: 10,
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
          ],
        ),
      ),
    )
    );
  }
}
