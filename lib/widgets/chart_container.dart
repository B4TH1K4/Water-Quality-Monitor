import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as charts;
import 'package:firebase_database/firebase_database.dart';

class ChartContainer extends StatefulWidget {
  const ChartContainer({super.key});

  @override
  _ChartContainerState createState() => _ChartContainerState();
}

class _ChartContainerState extends State<ChartContainer> {
  List<ChartData> liveData = [];
  List<ChartData> hourlyData = [];
  List<ChartData> dailyData = [];
  List<ChartData> monthlyData = [];

  @override
  void initState() {
    super.initState();
    fetchChartData("live", liveData);
    fetchChartData("hourly", hourlyData);
    fetchChartData("daily", dailyData);
    fetchChartData("monthly", monthlyData);
  }

  /// Fetches chart data from Firebase and updates the respective list.
  void fetchChartData(String type, List<ChartData> targetList) {
    DatabaseReference databaseRef = FirebaseDatabase.instance.ref("sensorData/$type");

    databaseRef.onValue.listen((DatabaseEvent event) {
      if (!mounted) return;
      final value = event.snapshot.value;

      if (value == null) {
        print("No data for $type");
        return;
      }

      if (value is Map<dynamic, dynamic>) {
        setState(() {
          targetList.clear();
          value.forEach((key, entry) {
            if (entry is Map<dynamic, dynamic>) {
              targetList.add(
                ChartData(
                  DateTime.tryParse(entry["time"] ?? "") ?? DateTime.now(),
                  double.tryParse(entry["value"].toString()) ?? 0.0,
                ),
              );
            }
          });
        });
      } else {
        print("Unexpected format in $type data: $value");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            const TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
              tabs: [
                Tab(text: "Live"),
                Tab(text: "Hourly"),
                Tab(text: "Daily"),
                Tab(text: "Monthly"),
              ],
            ),
            const SizedBox(height: 10),
            // Ensure charts don't overflow
            SizedBox(
              height: 300, // Fix the height to avoid infinite constraints
              child: TabBarView(
                children: [
                  buildChart(liveData, "Live Data"),
                  buildChart(hourlyData, "Hourly Data"),
                  buildChart(dailyData, "Daily Data"),
                  buildChart(monthlyData, "Monthly Data"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildChart(List<ChartData> data, String title) {
    return data.isEmpty
        ? const Center(child: Text("No Data", style: TextStyle(color: Colors.white)))
        : charts.SfCartesianChart(
            title: charts.ChartTitle(text: title, textStyle: const TextStyle(color: Colors.white)),
            primaryXAxis: const charts.DateTimeAxis(),
            primaryYAxis: const charts.NumericAxis(),
            series: <charts.LineSeries<ChartData, DateTime>>[
              charts.LineSeries<ChartData, DateTime>(
                dataSource: data,
                xValueMapper: (ChartData data, _) => data.time,
                yValueMapper: (ChartData data, _) => data.value,
                color: Colors.blue,
              ),
            ],
          );
  }
}

class ChartData {
  final DateTime time;
  final double value;

  ChartData(this.time, this.value);
}
