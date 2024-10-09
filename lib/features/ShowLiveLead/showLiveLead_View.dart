import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:junofast/routing/routes_constant.dart';
import 'showLiveLead_controller.dart';

class ShowLiveLeadView extends GetView<ShowLiveLeadController> {
  const ShowLiveLeadView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Leads'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('leads').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No leads available.'));
          }

          var leads = snapshot.data!.docs;

          return ListView.builder(
            itemCount: leads.length,
            itemBuilder: (context, index) {
              var lead = leads[index];

              return Card(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                elevation: 4,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  title: Text("Client Name: ${lead['clientName']}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Pickup Location: ${lead['pickupLocation']}"),
                      Text("Drop Location: ${lead['dropLocation']}"),
                      Text("Pickup Date: ${lead['pickupDate']}"),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          // Navigate to the update screen with the lead data
                          Get.to(() => UpdateLeadScreen(
                              leadId: lead.id,
                              leadData: lead.data() as Map<String, dynamic>));
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Show confirmation dialog before deleting
                          _showDeleteConfirmation(context, lead.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String leadId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Lead'),
          content: const Text('Are you sure you want to delete this lead?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Delete the lead from Firestore
                FirebaseFirestore.instance
                    .collection('leads')
                    .doc(leadId)
                    .delete()
                    .then((_) {
                  Navigator.of(context).pop(); // Close the dialog
                  Get.snackbar('Success', 'Lead deleted successfully');
                }).catchError((error) {
                  Get.snackbar('Error', 'Failed to delete lead: $error');
                });
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

// Separate screen for updating a lead
class UpdateLeadScreen extends StatefulWidget {
  final String leadId;
  final Map<String, dynamic> leadData;

  const UpdateLeadScreen(
      {required this.leadId, required this.leadData, super.key});

  @override
  _UpdateLeadScreenState createState() => _UpdateLeadScreenState();
}

class _UpdateLeadScreenState extends State<UpdateLeadScreen> {
  late TextEditingController _clientNameController;
  late TextEditingController _pickupLocationController;
  late TextEditingController _dropLocationController;
  late TextEditingController _amountController;
  late TextEditingController _pickupDateController;
  late TextEditingController _labourController;
  late TextEditingController _mobileController;
  bool _isLoading = false; // Add loading state

  @override
  void initState() {
    super.initState();
    // Initialize controllers with the current lead data
    _clientNameController =
        TextEditingController(text: widget.leadData['clientName']);
    _pickupLocationController =
        TextEditingController(text: widget.leadData['pickupLocation']);
    _dropLocationController =
        TextEditingController(text: widget.leadData['dropLocation']);
    _amountController =
        TextEditingController(text: widget.leadData['amount'].toString());
    _pickupDateController =
        TextEditingController(text: widget.leadData['pickupDate']);
    _labourController =
        TextEditingController(text: widget.leadData['laborRequired']);
        _mobileController =
        TextEditingController(text: widget.leadData['clientNumber']);
  }

  @override
  void dispose() {
    _clientNameController.dispose();
    _pickupLocationController.dispose();
    _dropLocationController.dispose();
    _amountController.dispose();
    _pickupDateController.dispose();
    _labourController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  void _updateLead() async {
    setState(() {
      _isLoading = true; // Set loading state to true
    });

    try {
      // Update the lead in Firestore
      await FirebaseFirestore.instance
          .collection('leads')
          .doc(widget.leadId)
          .update({
        'clientName': _clientNameController.text,
        'pickupLocation': _pickupLocationController.text,
        'dropLocation': _dropLocationController.text,
        'amount': double.tryParse(_amountController.text),
        'pickupDate': _pickupDateController.text,
        'laborRequired': _labourController.text,
        'clientNumber': _mobileController.text,
      });
      Get.back();
      Get.snackbar('Success', 'Lead updated successfully');
      Get.offAndToNamed(RoutesConstant.showLiveLead);
    } catch (error) {
      Get.snackbar('Error', 'Failed to update lead: $error');
    } finally {
      setState(() {
        _isLoading = false; // Set loading state back to false
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Update Lead'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              buildTextField(
                  "Client Name", _clientNameController, TextInputType.name),
              const SizedBox(height: 10),
              buildTextField("Pickup Location", _pickupLocationController,
                  TextInputType.streetAddress),
              const SizedBox(height: 10),
              buildTextField("Mobile number", _mobileController,
                  TextInputType.number),
              const SizedBox(height: 10),
              buildTextField("Drop Location", _dropLocationController,
                  TextInputType.streetAddress),
              const SizedBox(height: 10),
              buildTextField("Labour Required", _labourController, TextInputType.number),
              const SizedBox(height: 10),
              buildTextField("Amount", _amountController, TextInputType.number),
              const SizedBox(height: 10),
              buildDatePickerField("Pickup Date", _pickupDateController, context),
              const SizedBox(height: 20),
              _isLoading // Check if loading
                  ? const CircularProgressIndicator() // Show loading spinner
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      onPressed: _updateLead,
                      child: const Text('Update Lead',style: TextStyle(color: Colors.white),),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  // Build TextField helper
  TextField buildTextField(String label, TextEditingController controller,
      TextInputType keyboardType) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.orange),
        ),
      ),
    );
  }

  // Build DatePicker Field
  Widget buildDatePickerField(
      String label, TextEditingController controller, BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: const Icon(Icons.calendar_today, color: Colors.orange),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.orange),
        ),
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          controller.text = pickedDate.toLocal().toString().split(' ')[0];
        }
      },
    );
  }
}
