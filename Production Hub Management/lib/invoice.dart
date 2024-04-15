import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InvoiceDetailsPage extends StatefulWidget {
  final String enquiryId;

  const InvoiceDetailsPage({Key? key, required this.enquiryId})
      : super(key: key);

  @override
  _InvoiceDetailsPageState createState() => _InvoiceDetailsPageState();
}

class _InvoiceDetailsPageState extends State<InvoiceDetailsPage> {
  List<Map<String, dynamic>> productDetails = [];

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
  }

  Future<void> fetchProductDetails() async {
    final apiUrl =
        'http://192.168.193.197:3000/api/fetch_quotation_details/${widget.enquiryId}';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      print('Response Body: ${response.body}'); // Print the response body
      if (response.statusCode == 200) {
        final List<dynamic> data =
            jsonDecode(response.body); // Parse response as a list
        print('Parsed Data: $data'); // Print the parsed data
        setState(() {
          productDetails = List<Map<String, dynamic>>.from(data.map((row) {
            final Map<String, dynamic> rowData = {
              'USERNAME': row['username'],
              'PRODUCTID': row['productId'],
              'PRODUCTNAME': row['productName'],
              'QUANTITY': row['quantity'],
              'LEN': row['len'],
              'WIDTH': row['width'],
              'HEIGHT': row['height'],
            };
            print('Row Data: $rowData'); // Print the row data
            return rowData;
          }));
        });
      } else {
        throw Exception('Failed to fetch product details');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> generateInvoice(BuildContext context) async {
    final apiUrl =
        'http://192.168.193.197:3000/api/generate-invoice/${widget.enquiryId}';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        // Handle successful invoice generation
        // You can show a success message or navigate to the generated invoice
      } else {
        throw Exception('Failed to generate invoice');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enquiry Details'),
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
              itemCount: productDetails.length,
              itemBuilder: (context, index) {
                final product = productDetails[index];
                return ListTile(
                  title: Text('Product Name: ${product['PRODUCTNAME']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Quantity: ${product['QUANTITY']}'),
                      Text('Length: ${product['LEN']}'),
                      Text('Width: ${product['WIDTH']}'),
                      Text('Height: ${product['HEIGHT']}'),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                generateInvoice(
                    context); // Call the function to generate invoice
              },
              child: Text('Invoice'),
            ),
          ),
        ],
      ),
    );
  }
}
