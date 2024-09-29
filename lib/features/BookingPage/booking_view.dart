import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'booking_controller.dart';

class BookingPageView extends StatelessWidget {
  final BookingPageController controller = Get.put(BookingPageController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 4,
          title: const Text(
            "All Bookings"),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: "Ongoing & Processing"),
              Tab(text: "Completed"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Ongoing & Processing Bookings
            Obx(() {
              if (controller.ongoingProcessingBookings.isEmpty) {
                return _buildEmptyState("No ongoing or processing bookings");
              }
              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: controller.ongoingProcessingBookings.length,
                itemBuilder: (context, index) {
                  final booking = controller.ongoingProcessingBookings[index];
                  return BookingCard(booking: booking);
                },
              );
            }),
            // Completed Bookings
            Obx(() {
              if (controller.completedBookings.isEmpty) {
                return _buildEmptyState("No completed bookings");
              }
              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: controller.completedBookings.length,
                itemBuilder: (context, index) {
                  final booking = controller.completedBookings[index];
                  return BookingCard(booking: booking);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.grey,
        ),
      ),
    );
  }
}

class BookingCard extends StatefulWidget {
  final Map<String, dynamic> booking;

  BookingCard({required this.booking});

  @override
  _BookingCardState createState() => _BookingCardState();
}

class _BookingCardState extends State<BookingCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // Ensure all fields are safely handled if null
    String leadId = widget.booking['leadId']?.toString() ?? "Unknown";
    String pickupAddress = widget.booking['pickupLocation'] ;
    String dropAddress = widget.booking['dropLocation'] ;
    String laborRequired = widget.booking['laborRequired'];
    String amount = widget.booking['amount']?.toString() ?? "N/A";
    String pickupDate = widget.booking['pickupDate'];
    String createdOn = widget.booking['timestamp']?.toDate().toString() ?? "N/A";

    // Determine the status message with null safety
    String statusMessage;
    if (widget.booking['status'] == 'processing') {
      statusMessage = "Lead Accepted";
    } else if (widget.booking['status'] == 'ongoing') {
      statusMessage = "Lead Updated by Vendor";
    } else {
      statusMessage = widget.booking['status']?.toString() ?? "Unknown";
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                "Booking ID: $leadId",
                style:const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Text(
                statusMessage,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
              ),
            ),
            if (_isExpanded)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow("Pickup Address", pickupAddress),
                    _buildInfoRow("Drop Address", dropAddress),
                    _buildInfoRow("Number of Labor", laborRequired),
                    _buildInfoRow("Amount", "\$$amount"),
                    _buildInfoRow("Pickup Date", pickupDate),
                    _buildInfoRow("Created on", createdOn),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[700], fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}