import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'booking_controller.dart';

class BookingPageView extends StatelessWidget {
  final BookingPageController controller = Get.put(BookingPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Bookings"),
      ),
      body: Obx(() {
        if (controller.bookings.isEmpty) {
          return Center(child: Text("No bookings available"));
        }
        return ListView.builder(
          itemCount: controller.bookings.length,
          itemBuilder: (context, index) {
            final booking = controller.bookings[index];
            return BookingCard(booking: booking);
          },
        );
      }),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                "Booking ID: ${widget.booking['bookingId']}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Type: ${widget.booking['typeOfVehicleRequired']}"),
              trailing: IconButton(
                icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
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
                    Text("Pickup Address: ${widget.booking['pickupAddress']}"),
                    Text("Drop Address: ${widget.booking['dropAddress']}"),
                    Text("Number of Labor: ${widget.booking['laborRequired']}"),
                    Text("Amount: \$${widget.booking['amount']}"),
                    Text("Status: ${widget.booking['status']}"),
                    Text("Timestamp: ${widget.booking['timestamp']?.toDate()}"),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
