import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'quotationpdf.dart';

class QuotationListPage extends StatefulWidget {
  @override
  _QuotationListPageState createState() => _QuotationListPageState();
}

class _QuotationListPageState extends State<QuotationListPage> {
  List<Map<String, dynamic>> _quotations = [];

  @override
  void initState() {
    super.initState();
    _fetchQuotations();
  }

  Future<void> _fetchQuotations() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.193.197:3000/api/fetchQuotations'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['quotations'] is List) {
          setState(() {
            _quotations = List<Map<String, dynamic>>.from(data['quotations']);
          });
        } else {
          print('Quotations data is not in the expected format');
        }
      } else {
        print('Failed to fetch quotations: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while fetching quotations: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quotations'),
      ),
      body: ListView.builder(
        itemCount: _quotations.length,
        itemBuilder: (context, index) {
          final quotation = _quotations[index];
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            elevation: 8,
            color: Color.fromARGB(255, 88, 217, 249),
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              leading: CircleAvatar(
                child: Text(
                    quotation['enquiry_id'].toString()), // Convert to string
              ),
              //title: Text('Enquiry ID: ${quotation['enquiry_id']}'),
              title: Text('Username: ${quotation['username']}'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PdfGenerationPage(
                        enquiryId: quotation['enquiry_id'].toString()),
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
