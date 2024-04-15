import 'dart:convert';
import 'package:flutter/material.dart';
import 'con_accepteddetails.dart';
import 'package:http/http.dart' as http;

class AcceptedEnquiries extends StatefulWidget {
  @override
  _AcceptedEnquiriresPageState createState() => _AcceptedEnquiriresPageState();
}

class _AcceptedEnquiriresPageState extends State<AcceptedEnquiries> {
  List<int> enquiryIds = [];
  List<Map<String, dynamic>> enquiryDetails = []; // Declare the variable

  @override
  void initState() {
    super.initState();
    // Fetch list of enquiry IDs from the API
    fetchAcceptedEnquiry();
  }

  Future<void> fetchAcceptedEnquiry() async {
    final String apiUrl =
        'http://192.168.193.197:3000/api/fetchAccepted'; // Updated API endpoint
    try {
      final response = await http.get(Uri.parse(apiUrl));
      print(
          'API Response: ${response.body}'); // Print the response for debugging
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        List<Map<String, dynamic>> enquiries = [];
        for (var item in data) {
          enquiries.add({
            'enquiryId': item[0],
            'username': item[1],
          });
        }
        setState(() {
          enquiryDetails = enquiries;
        });
      } else {
        throw Exception('Failed to fetch enquiry IDs');
      }
    } catch (error) {
      print('Error fetching enquiry IDs: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enquiries Created'),
      ),
      body: _buildEnquiryList(),
    );
  }

  Widget _buildEnquiryList() {
    return ListView.builder(
      itemCount: enquiryDetails.length,
      itemBuilder: (context, index) {
        int enquiryId = enquiryDetails[index]['enquiryId'];
        String username = enquiryDetails[index]['username'];
        return Card(
          elevation: 10, // Add elevation for shadow effect
          margin: EdgeInsets.symmetric(
              vertical: 8, horizontal: 16), // Add margin for spacing
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(
                vertical: 8, horizontal: 16), // Adjust content padding
            leading: Icon(Icons.done_outline,
                color:
                    const Color.fromARGB(255, 63, 70, 77)), // Add leading icon
            title: Center(
              child: Text(
                'Enquiry ID: $enquiryId\nUsername: $username',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black87, // Adjust text color
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            trailing: Icon(Icons.arrow_forward_ios), // Add trailing arrow icon
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AcceptedDetailsPage(enquiry_Id: enquiryId),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
