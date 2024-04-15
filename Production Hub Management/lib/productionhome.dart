import 'package:flutter/material.dart';
import 'package:login/main.dart';
import 'workdetailspage.dart  ';
import 'dart:convert';
import 'completedworks.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';

class LoggedInPage extends StatefulWidget {
  final String unitname;

  const LoggedInPage({Key? key, required this.unitname}) : super(key: key);

  @override
  State<LoggedInPage> createState() => _LoggedInPageState();
}

class _LoggedInPageState extends State<LoggedInPage> {
  String workStatus = '';
  List<Map<String, dynamic>> workDetails = [];

  @override
  void initState() {
    super.initState();
    fetchWorkStatus();
  }

  Future<void> fetchWorkStatus() async {
    final apiUrl =
        'http://192.168.193.197:3000/api/work_status/${widget.unitname}';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          workStatus = responseData['work_status'];
        });
      } else {
        throw Exception('Failed to fetch work status');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> updateStatusToFree() async {
    final apiUrl =
        'http://192.168.193.197:3000/api/update_status_to_free/${widget.unitname}';
    try {
      final response = await http.put(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Status Changed to FREE',
        );
        await fetchWorkStatus();
      } else {
        throw Exception('Failed to update production unit status to free');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> updateStatusToBusy() async {
    final apiUrl =
        'http://192.168.193.197:3000/api/update_status_to_busy/${widget.unitname}';
    try {
      final response = await http.put(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Status Changed to BUSY',
        );
        await fetchWorkStatus();
      } else {
        throw Exception('Failed to update production unit status to busy');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> fetchData() async {
    final apiUrl =
        'http://192.168.193.197:3000/api/fetch_enquiry_id/${widget.unitname}';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final enquiryId = jsonDecode(response.body)['enquiry_id'];

        // Fetch details from the quotation footer table using the enquiry ID
        final quotationFooterUrl =
            'http://192.168.193.197:3000/api/fetch_quotation_details/$enquiryId';
        final quotationResponse = await http.get(Uri.parse(quotationFooterUrl));
        if (quotationResponse.statusCode == 200) {
          final quotationDetails = jsonDecode(quotationResponse.body);
          print('Quotation Details Response: $quotationDetails');
          print('Enquiry ID: $enquiryId');
          return {
            'enquiryId': enquiryId,
            'quotationDetails':
                List<Map<String, dynamic>>.from(quotationDetails),
          };
        } else {
          throw Exception('Failed to fetch quotation details');
        }
      } else {
        throw Exception('Failed to fetch enquiry ID');
      }
    } catch (e) {
      print('Error: $e');
      throw e; // Rethrow the exception to be caught by the caller
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  'Current Status: $workStatus',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/Completed steps.gif', // Replace 'your_image.png' with the path to your image asset
                  // Adjust the BoxFit property as needed
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Navigate to completed works page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CompletedWorksPage(unitname: widget.unitname),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Background color
                  foregroundColor: Colors.black, // Text color
                  elevation: 4, // Add some shadow
                ),
                child: Text('Completed Works'),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 98, 98, 97),
              ),
              child: Center(
                child: Text(
                  'Home',
                  style: TextStyle(
                    fontSize: 24,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text('Change Status to Free'),
              onTap: () {
                updateStatusToFree();
              },
            ),
            ListTile(
              title: Text('Change Status to Busy'),
              onTap: () {
                updateStatusToBusy();
              },
            ),
            ListTile(
              title: Text('View Work Details'),
              onTap: () async {
                try {
                  final details = await fetchData();
                  final enquiryId = details['enquiryId'];
                  final quotationDetails = details['quotationDetails'];
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkDetailsPage(
                        workDetails: quotationDetails,
                        enquiryId: enquiryId,
                        unitname: widget.unitname,
                      ),
                    ),
                  );
                } catch (e) {
                  print('Error fetching work details: $e');
                  // Handle error
                }
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Homescreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
