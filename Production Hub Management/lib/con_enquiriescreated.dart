import 'dart:convert';
import 'package:flutter/material.dart';
import 'contractorenqdetails.dart';
import 'package:http/http.dart' as http;

class EnquiriesCreatedPage extends StatefulWidget {
  @override
  _EnquiriesCreatedPageState createState() => _EnquiriesCreatedPageState();
}

class _EnquiriesCreatedPageState extends State<EnquiriesCreatedPage> {
  List<int> enquiryIds = [];
  List<Map<String, dynamic>> enquiryDetails = []; // Declare the variable

  @override
  void initState() {
    super.initState();
    // Fetch list of enquiry IDs from the API
    fetchEnquiryIds();
  }

  Future<void> fetchEnquiryIds() async {
    final String apiUrl =
        'http://192.168.193.197:3000/api/fetchEnquiryDetails'; // Updated API endpoint
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
        backgroundColor: Color.fromARGB(
            255, 142, 137, 137), // Change the background color of the AppBar
        title: Text(
          'Enquiries Created',
          style: TextStyle(
            color: Color.fromARGB(
                255, 233, 227, 227), // Change the text color of the title
            fontSize: 20, // Change the font size of the title
            fontWeight: FontWeight.w900, // Change the font weight of the title
          ),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 142, 137, 137),
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
          elevation: 10,
          color: Color.fromARGB(
              255, 32, 31, 31), // Add elevation for shadow effect
          margin: EdgeInsets.symmetric(
              vertical: 8, horizontal: 16), // Add margin for spacing
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(
                vertical: 8, horizontal: 16), // Adjust content padding
            leading: Icon(Icons.article_rounded,
                color: Color.fromARGB(255, 255, 255, 255)), // Add leading icon
            title: Center(
              child: Text(
                'Enquiry ID: $enquiryId\nUsername: $username',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color.fromARGB(
                      221, 255, 255, 255), // Adjust text color
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Color.fromARGB(255, 255, 255, 255),
            ), // Add trailing arrow icon
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EnquiryDetailsPage(enquiryId: enquiryId),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
