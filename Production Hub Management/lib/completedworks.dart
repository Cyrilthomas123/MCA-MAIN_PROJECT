import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'invoice.dart';

class CompletedWorksPage extends StatefulWidget {
  final String unitname;

  const CompletedWorksPage({Key? key, required this.unitname})
      : super(key: key);

  @override
  _CompletedWorksPageState createState() => _CompletedWorksPageState();
}

class _CompletedWorksPageState extends State<CompletedWorksPage> {
  List<String> completedEnquiries = [];

  @override
  void initState() {
    super.initState();
    fetchCompletedEnquiries();
  }

  Future<void> fetchCompletedEnquiries() async {
    final apiUrl =
        'http://192.168.193.197:3000/api/completed_enquiries/${widget.unitname}';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          completedEnquiries = List<String>.from(data);
        });
      } else {
        throw Exception('Failed to fetch completed enquiries');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Works'),
      ),
      body: ListView.builder(
        itemCount: completedEnquiries.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(
                completedEnquiries[index],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                'Tap to view details',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(
                  Icons.description,
                  color: Colors.white,
                ),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InvoiceDetailsPage(
                        enquiryId: completedEnquiries[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
