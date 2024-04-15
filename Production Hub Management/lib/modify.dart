import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';

class ModifyCompanyDetailsPage extends StatefulWidget {
  @override
  _ModifyCompanyDetailsPageState createState() =>
      _ModifyCompanyDetailsPageState();
}

class _ModifyCompanyDetailsPageState extends State<ModifyCompanyDetailsPage> {
  TextEditingController _companyIdController = TextEditingController();
  TextEditingController _companyNameController = TextEditingController();
  TextEditingController _address1Controller = TextEditingController();
  TextEditingController _address2Controller = TextEditingController();
  TextEditingController _address3Controller = TextEditingController();
  TextEditingController _websiteController = TextEditingController();
  TextEditingController _mailIdController = TextEditingController();
  TextEditingController _phNoController = TextEditingController();
  TextEditingController _countryCodeController = TextEditingController();

  @override
  void dispose() {
    _companyIdController.dispose();
    _companyNameController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _address3Controller.dispose();
    _websiteController.dispose();
    _mailIdController.dispose();
    _phNoController.dispose();
    _countryCodeController.dispose();
    super.dispose();
  }

  Future<void> _getCompanyDetails(String companyId) async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.193.197:3000/api/company/$companyId'),
      );

      if (response.statusCode == 200) {
        final parsedResponse = json.decode(response.body);
        if (parsedResponse is Map<String, dynamic>) {
          setState(() {
            _companyIdController.text = companyId;
            _companyNameController.text = parsedResponse['COMPANY_NAME'] ?? '';
            _address1Controller.text = parsedResponse['ADDRESS1'] ?? '';
            _address2Controller.text = parsedResponse['ADDRESS2'] ?? '';
            _address3Controller.text = parsedResponse['ADDRESS3'] ?? '';
            _websiteController.text = parsedResponse['WEBSITE'] ?? '';
            _mailIdController.text = parsedResponse['MAILID'] ?? '';
            _phNoController.text = parsedResponse['PHNO'] ?? '';
            _countryCodeController.text = parsedResponse['COUNTRY_CODE'] ?? '';
          });
        } else {
          // Invalid response format
          _showMessage(
              'Failed to retrieve company details: Invalid response format');
        }
      } else if (response.statusCode == 404) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Oops...',
          text: 'Company ID not Found.Enter a valid ID',
        );
        // Company ID not found
        //_showMessage('Company ID not found. Please enter a valid Company ID.');
      } else {
        // Other HTTP error
        _showMessage(
            'Failed to retrieve company details: ${response.statusCode}');
      }
    } catch (e) {
      // Error
      print('Error: $e');
      _showMessage(
          'An error occurred while retrieving company details. Please check your connection and try again.');
    }
  }

  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitChanges() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.193.197:3000/api/update_company'),
        body: {
          'COMPANY_ID': _companyIdController.text,
          'COMPANY_NAME': _companyNameController.text,
          'ADDRESS1': _address1Controller.text,
          'ADDRESS2': _address2Controller.text,
          'ADDRESS3': _address3Controller.text,
          'WEBSITE': _websiteController.text,
          'MAILID': _mailIdController.text,
          'PHNO': _phNoController.text,
          'COUNTRY_CODE': _countryCodeController.text,
        },
      );

      if (response.statusCode == 200) {
        // Show a pop-up indicating that changes are made successfully
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Changes Made Successfully',
        );
      } else {
        print('Failed to submit changes: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Retrieve Company Details'),
        titleTextStyle: TextStyle(fontSize: 20, color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _companyIdController,
              decoration: InputDecoration(
                labelText: 'Company ID',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                _getCompanyDetails(_companyIdController.text);
              },
              child: Text('Show Details'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _companyNameController,
              decoration: InputDecoration(
                labelText: 'Company Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _address1Controller,
              decoration: InputDecoration(
                labelText: 'Address 1',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _address2Controller,
              decoration: InputDecoration(
                labelText: 'Address 2',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _address3Controller,
              decoration: InputDecoration(
                labelText: 'Address 3',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _websiteController,
              decoration: InputDecoration(
                labelText: 'Website',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _mailIdController,
              decoration: InputDecoration(
                labelText: 'Mail ID',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _phNoController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _countryCodeController,
              decoration: InputDecoration(
                labelText: 'Country Code',
                border: OutlineInputBorder(),
              ),
            ),
            //SizedBox(height: 5),
            Center(
              child: GestureDetector(
                onTap: _submitChanges, // Handle the click event here
                child: Container(
                  // decoration: BoxDecoration(
                  //   //color: Colors.black,
                  //   borderRadius: BorderRadius.circular(
                  //       8), // Adjust the border radius as needed
                  // ),
                  padding: EdgeInsets.symmetric(
                      vertical: 12, horizontal: 24), // Adjust padding as needed
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/Animation.gif', // Path to your submit button icon
                        height: 140, // Adjust the height as needed
                        width: 100, // Adjust the width as needed
                        //color: Colors.white, // Apply color to the icon
                      ),
                      //SizedBox(width: 8), // Add spacing between icon and text
                      Text(
                        'Submit Changes',
                        style: TextStyle(
                          //color: Colors.white,
                          fontSize: 16, // Adjust font size as needed
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
