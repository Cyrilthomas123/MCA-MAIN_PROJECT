import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'productionhome.dart';
//import 'production_login.dart';
import 'package:quickalert/quickalert.dart';

class WorkDetailsPage extends StatefulWidget {
  final List<Map<String, dynamic>> workDetails;
  final enquiryId;
  final String unitname;

  const WorkDetailsPage({
    Key? key,
    required this.workDetails,
    required this.enquiryId,
    required this.unitname,
  }) : super(key: key);

  @override
  State<WorkDetailsPage> createState() => _WorkDetailsPageState();
}

class _WorkDetailsPageState extends State<WorkDetailsPage> {
  Future<void> updateQuotationHeaderStatus(String enquiryId) async {
    final apiUrl =
        'http://192.168.193.197:3000/api/update_quotation_status/$enquiryId';
    try {
      final response = await http.put(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        // Handle success
        print('Quotation header status updated successfully');
      } else {
        throw Exception('Failed to update quotation header status');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> deleteWorkAllocation(String enquiryId) async {
    final apiUrl =
        'http://192.168.193.197:3000/api/delete_work_allocation/$enquiryId';
    try {
      final response = await http.delete(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        // Handle success
        print('Work allocation deleted successfully');
      } else {
        throw Exception('Failed to delete work allocation');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> setCompletionDate(String enquiryId) async {
    final apiUrl =
        'http://192.168.193.197:3000/api/set_completion_date/$enquiryId';
    try {
      // Get the current system date and time
      final currentDate = DateTime.now();

      // Format the date and time
      final formattedDate = '${currentDate.day.toString().padLeft(2, '0')}-'
          '${currentDate.month.toString().padLeft(2, '0')}-'
          '${currentDate.year}'; // Format: "DD-MM-YYYY"
      final formattedTime = '${currentDate.hour.toString().padLeft(2, '0')}:'
          '${currentDate.minute.toString().padLeft(2, '0')}:'
          '${currentDate.second.toString().padLeft(2, '0')}'; // Format: "HH:MM:SS"

      print(
          'Current date and time: $formattedDate $formattedTime'); // Print the formatted date and time

      final response = await http.put(Uri.parse(apiUrl), body: {
        'completiondate': '$formattedDate $formattedTime',
      });

      if (response.statusCode == 200) {
        // Handle success
        print('Completion date set successfully');
      } else {
        throw Exception('Failed to set completion date');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> insertJobComplete(String enquiryId) async {
    final apiUrl = 'http://192.168.193.197:3000/api/insert_job_complete';
    try {
      final response = await http.post(Uri.parse(apiUrl), body: {
        'enquiry_id': enquiryId,
        'unitname': widget.unitname,
      });

      if (response.statusCode == 200) {
        // Handle success
        print('Job complete record inserted successfully');
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Notified Completion',
        );
      } else {
        throw Exception('Failed to insert job complete record');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Work Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Enquiry ID: ${widget.enquiryId}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.workDetails.length,
              itemBuilder: (context, index) {
                final row = widget.workDetails[index];
                return ListTile(
                  title: Text(row['name'] ?? ''),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Product ID: ${row['productId']}'),
                      Text('Product Name: ${row['productName']}'),
                      Text('Quantity: ${row['quantity']}'),
                      Text('Length: ${row['len']}'),
                      Text('Width: ${row['width']}'),
                      Text('Height: ${row['height']}'),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          // Call API methods when button is pressed
          updateQuotationHeaderStatus(widget.enquiryId);
          deleteWorkAllocation(widget.enquiryId);
          setCompletionDate(widget.enquiryId);
          insertJobComplete(widget.enquiryId);
        },
        child: Text('Notify Completion'), // Text displayed on the button
      ),
    );
  }
}
