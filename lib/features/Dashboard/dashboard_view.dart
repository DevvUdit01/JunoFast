import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:junofast/features/Dashboard/dashboard_controller.dart';
import 'package:junofast/routing/routes_constant.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background for main theme
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.orange, // Orange secondary color for AppBar
      ),
      drawer: buildDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Admin Profile Information
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.orange.shade100, // Light orange shade
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 30,
                        child: Icon(Icons.person, size: 50.0, color: Colors.orange),
                      ),
                      const SizedBox(width: 16.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Admin Name",
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                          ),
                          Text(
                            "AdminName@gmail.com",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.grey[700],
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.toNamed(RoutesConstant.Lead);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange, // Button with orange color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Text(
                          "Create New Lead",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Key Metrics Section
            Row(
              children: [
                // Expanding both Metric Cards to take up available space equally
                Expanded(
                  child: Obx(() => GestureDetector(
                        onTap: () => Get.toNamed(RoutesConstant.showLiveLead),
                        child: MetricCard(
                          title: 'Live Leads',
                          value: controller.liveLeads.value.toString(),
                          color: Colors.orange,
                        ),
                      )),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Obx(() => GestureDetector(
                        onTap: () => Get.toNamed(RoutesConstant.showAllVendors),
                        child: MetricCard(
                          title: 'Active Vendors',
                          value: controller.activeVendors.value.toString(),
                          color: Colors.purple,
                        ),
                      )),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Recent Activities Section
            Text(
              'Recent Activities',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: controller.recentActivities.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          title: Text(
                            controller.recentActivities[index],
                            style: const TextStyle(color: Colors.black87),
                          ),
                        ),
                      );
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const MetricCard({super.key, required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1), // Lighter shade of the metric color
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

Drawer buildDrawer() {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        const UserAccountsDrawerHeader(
          accountName: Text("Admin Name"),
          accountEmail: Text("AdminName@gmail.com"),
          currentAccountPicture: CircleAvatar(
            backgroundImage: NetworkImage("https://example.com/avatar.jpg"), // Placeholder image
          ),
          decoration: BoxDecoration(
            color: Colors.orange,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.person, color: Colors.orange),
          title: const Text('Profile'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.payment, color: Colors.orange),
          title: const Text('Payment'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.note, color: Colors.orange),
          title: const Text('Notes'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.help, color: Colors.orange),
          title: const Text('Help'),
          onTap: () {},
        ),
      ],
    ),
  );
}
