import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:water_quality_monitor/screens/DetailsScreen.dart';
import 'package:water_quality_monitor/screens/dashboard.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: Colors.grey, // Selected item background color
            labelTextStyle: WidgetStateProperty.all(
              const TextStyle(color: Colors.white), // Text color
            ),
          ),
          child: NavigationBar(
            backgroundColor: const Color.fromRGBO(36, 42, 64,1),
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (index) => controller.selectedIndex.value = index,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.device_thermostat, color: Colors.white),
                selectedIcon: Icon(Icons.device_thermostat, color: Colors.white),
                label: 'TEMP',
              ),
              NavigationDestination(
                icon: Icon(Icons.science, color: Colors.white),
                selectedIcon: Icon(Icons.science, color: Colors.white),
                label: 'PH',
              ),
              NavigationDestination(
                icon: Icon(Icons.home, color: Colors.white),
                selectedIcon: Icon(Icons.home, color: Colors.white),
                label: 'HOME',
              ),
              NavigationDestination(
                icon: Icon(Icons.water_drop, color: Colors.white),
                selectedIcon: Icon(Icons.water_drop, color: Colors.white),
                label: 'TDS',
              ),
              NavigationDestination(
                icon: Icon(Icons.bubble_chart, color: Colors.white),
                selectedIcon: Icon(Icons.bubble_chart, color: Colors.white),
                label: 'TURBIDITY',
              ),
            ],
          ),
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 2.obs;


  final screens = [
    const DetailsScreen(title: "Temperature"),
    const DetailsScreen(title: "pH Level"),
    const DashboardScreen(),
    const DetailsScreen(title: "TDS"),
    const DetailsScreen(title: "Turbidity"),
  ];
}
