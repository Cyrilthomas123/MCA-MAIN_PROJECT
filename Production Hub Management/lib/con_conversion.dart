import 'dart:convert'; // Import the 'dart:convert' library

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ConversionPage extends StatefulWidget {
  @override
  _ConversionPageState createState() => _ConversionPageState();
}

class _ConversionPageState extends State<ConversionPage> {
  List<Map<String, dynamic>> enquiryDetails = [];

  @override
  void initState() {
    super.initState();
    fetchconDetail();
  }

  Future<void> fetchconDetail() async {
    final apiUrl = 'http://192.168.193.197:3000/api/con_enquiry_ids';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        // Decode the JSON response body into a list of maps
        List<dynamic> data = jsonDecode(response.body);
        // Cast each map to Map<String, dynamic> and assign to enquiryDetails
        setState(() {
          enquiryDetails =
              data.map((item) => item as Map<String, dynamic>).toList();
        });
      } else {
        throw Exception('Failed to fetch enquiry details');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Conversion Page'),
        ),
        body: ListView.builder(
          itemCount: enquiryDetails.length,
          itemBuilder: (context, index) {
            final detail = enquiryDetails[index];
            return ListTile(
              tileColor: index % 2 == 0
                  ? Colors.grey[200]
                  : Colors.white, // Alternate row colors
              leading: CircleAvatar(
                child: Text(detail['username']
                    [0]), // Display the first letter of the username as avatar
                backgroundColor: Colors.blue, // Avatar background color
                foregroundColor: Colors.white, // Avatar text color
              ),
              title: Text(
                'Enquiry ID: ${detail['enquiry_id']}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                'Username: ${detail['username']}',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[700],
                ),
              ),
              trailing: Icon(Icons.arrow_forward), // Add trailing icon
              onTap: () {
                // Handle tap on the list tile
              },
              onLongPress: () {
                // Handle long press on the list tile
              },
            );
          },
        ));
  }
}
