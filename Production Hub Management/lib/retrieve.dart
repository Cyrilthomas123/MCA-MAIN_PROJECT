import 'dart:convert';
import 'package:quickalert/quickalert.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Retrieve Company Details',
//       theme: ThemeData(
//         primaryColor: Colors.black,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: RetrieveDetailsScreen(),
//     );
//   }
// }

class RetrieveDetailsScreen extends StatefulWidget {
  @override
  _RetrieveDetailsScreenState createState() => _RetrieveDetailsScreenState();
}

class _RetrieveDetailsScreenState extends State<RetrieveDetailsScreen> {
  TextEditingController _idController = TextEditingController();
  List<String>? _columnNames;
  List<String>? _companyDetails;
  bool _isLoading = false;

  Future<void> _retrieveDetails(String companyId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('http://192.168.193.197:3000/api/company/$companyId'),
      );

      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final parsedResponse = json.decode(response.body);
        if (parsedResponse is Map<String, dynamic>) {
          setState(() {
            _columnNames = parsedResponse.keys.toList();
            _companyDetails = parsedResponse.values
                .toList()
                .map((value) => value.toString())
                .toList();
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
            _columnNames = null;
            _companyDetails = null;
          });
          print('Failed to retrieve company details: Invalid response format');
        }
      } else if (response.statusCode == 404) {
        setState(() {
          _isLoading = false;
          _columnNames = null;
          _companyDetails = null;
        });
        QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          text: 'Enter a valid company ID',
        );
      } else {
        setState(() {
          _isLoading = false;
          _columnNames = null;
          _companyDetails = null;
        });
        print('Failed to retrieve company details: ${response.statusCode}');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(
                'Failed to retrieve company details. Please check your connection and try again.',
              ),
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
    } catch (e) {
      setState(() {
        _isLoading = false;
        _columnNames = null;
        _companyDetails = null;
      });
      print('Error: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
              'An error occurred while retrieving company details. Please check your connection and try again.',
            ),
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
            Text(
              'Enter Company ID',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _idController,
              decoration: InputDecoration(
                labelText: 'Company ID',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                _retrieveDetails(_idController.text);
              },
              child: Text('Show Details'),
            ),
            SizedBox(height: 16.0),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : _companyDetails != null && _columnNames != null
                    ? Column(
                        children: [
                          for (int i = 0; i < _columnNames!.length; i++)
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Center(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        _columnNames![i],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8.0),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        _companyDetails![i],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      )
                    : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }
}
